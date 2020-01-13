function [simulatedSignal,t,fr] = funSignalGenerator(speed_profile,main_table_bearing_data,main_table_bearing_mask,main_table_ord_data,main_table_ord_mask,noise_mean,noise_variance,noise_nat_freq,noise_damping)
%% Function for generating the overall signature (in the time domain)
%
% M. Buzzoni
% Aug. 2018

%% differentiating the signal
answer = questdlg('Select the response type:','Response type','displacement','velocity','acceleration','displacement');
% Handle response
switch answer
    case 'displacement'
        % do nothing
        irfFlag = 0;
    case 'velocity'
        irfFlag = 1;
    case 'acceleration'
        irfFlag = 2;
end

f_w8bar = waitbar(0,'Please wait...');
pause(.5)

%% define the speed of the system based on considerations about shafts and transmission ratios
NOSignatureGenerationFlag = 0;

% input speed (shaft #1)
fs = speed_profile.fs;
fr = speed_profile.fr; fr = fr(:);
theta = speed_profile.theta;
theta = theta(:);
M = speed_profile.M;
deltaTheta = 2*pi/M;
tau = 1;
shafts(1) = 1;

try
    % check if there are different shaft speeds due to the presence of geared
    % shafts
    
    Nshafts = max(main_table_ord_data{:,2});
    fr = [fr, zeros(length(fr),Nshafts-1)];
    theta = [theta, zeros(length(fr),Nshafts-1)];
    matingGearIndex = 2;
    for k = 2:length(cell2mat(main_table_ord_mask(:,1)))
        matingGearIndex(k) = cell2mat(main_table_ord_mask(k,3));
        tau(k) = cell2mat(main_table_ord_mask(k,4))./cell2mat(main_table_ord_mask(matingGearIndex(k),4));
        fr(:,k) = fr(:,matingGearIndex(k))./tau(k);
        theta(:,k) = theta(:,matingGearIndex(k))./tau(k);
        deltaTheta(:,k) = deltaTheta(1)./tau(k);
        shafts(k) = cell2mat(main_table_ord_mask(k,2));
    end
catch
    % all the bearings rotate at the same speed
    Nshafts = max(main_table_bearing_data{:,2});
    fr = repmat(fr,[1 Nshafts]);
end

bearingResponseOverall = [];
gearResponseOverall = [];
LbearingResponse = [];

%% bearing section
waitbar(.33,f_w8bar,'Generation of bearing fault signature');

if ~isempty(main_table_bearing_mask)
    
    faultTypes = {'outer' 'inner' 'ball'};
    countBearingResponse = 1;
    
    for k = 1:length(cell2mat(main_table_bearing_mask(:,1)))
        nr = cell2mat(main_table_bearing_mask(k,3));
        d = cell2mat(main_table_bearing_mask(k,4));
        D = cell2mat(main_table_bearing_mask(k,5));
        beta = cell2mat(main_table_bearing_mask(k,6))*pi/180;
        distrFlag = cell2mat(main_table_bearing_mask(k,7));
        localFlag = cell2mat(main_table_bearing_mask(k,8));
        thetaTemp = theta(:,k);
        shaft_bearing = cell2mat(main_table_bearing_mask(k,2));
        frInd = shafts == shaft_bearing;
        frInd = find(frInd,1);
        frTemp = fr(:,frInd);
%         figure, plot(frTemp); %%%%%%%
        
        if cell2mat(main_table_bearing_mask(k,7)) % distributed fault
            for j = 2:4
                qRotation = cell2mat(main_table_bearing_data{k,7}(1,j));
                qStiffness = cell2mat(main_table_bearing_data{k,7}(2,j));
                qFault = cell2mat(main_table_bearing_data{k,7}(3,j));
                fn = cell2mat(main_table_bearing_data{k,7}(4,j));
                zita = cell2mat(main_table_bearing_data{k,7}(5,j));
                deltaTheta_temp = deltaTheta(frInd);
                if ~isempty(find([qRotation qStiffness qFault]))
                    [bearingResponse{countBearingResponse}, estFaultFreq{countBearingResponse}, bearingfrTime{countBearingResponse}, timeTheta{countBearingResponse}] = bearingSignalModelDistributed(frTemp,deltaTheta_temp,faultTypes{j - 1},nr,d,D,beta,qRotation,qStiffness,qFault,fs,zita,fn,2^9,irfFlag);
                    LbearingResponse(countBearingResponse) = length(bearingResponse{countBearingResponse});
                    countBearingResponse = countBearingResponse + 1;
                end
            end
        end
        
        % local fault
        if cell2mat(main_table_bearing_mask(k,8))
            for j = 2:4
                jitter = cell2mat(main_table_bearing_data{k,8}(1,j));
                meanDelta = cell2mat(main_table_bearing_data{k,8}(2,j))./100;
                stdDelta = cell2mat(main_table_bearing_data{k,8}(3,j))./100;
                periodicModulation = cell2mat(main_table_bearing_data{k,8}(4,j))./100;
                doubleImpactFactor = cell2mat(main_table_bearing_data{k,8}(5,j))./100;
                fn = cell2mat(main_table_bearing_data{k,8}(6,j));
                zita = cell2mat(main_table_bearing_data{k,8}(7,j));
                deltaTheta_temp = deltaTheta(frInd);
                if ~isempty(find([jitter fn zita]))
                    [bearingResponse{countBearingResponse}, estFaultFreq{countBearingResponse}, bearingfrTime{countBearingResponse}, timeTheta{countBearingResponse}] = bearingSignalModelLocal(frTemp,deltaTheta_temp,faultTypes{j - 1},nr,d,D,beta,jitter,meanDelta,stdDelta,periodicModulation,doubleImpactFactor,fs,zita,fn,2^9,irfFlag);
                    LbearingResponse(countBearingResponse) = length(bearingResponse{countBearingResponse});
                    countBearingResponse = countBearingResponse + 1;
%                     figure, plot(bearingfrTime{countBearingResponse})
                end
            end
        end
    end
    
    % overall bearing signal
    if ~isempty(LbearingResponse)
        LbearingResponse = min(LbearingResponse);
        bearingResponseOverall = zeros(LbearingResponse,1);
        for k = 1:length(bearingResponse)
            bearingResponseOverall = bearingResponseOverall + bearingResponse{k}(1:LbearingResponse);
            bearingfrTime{k} = bearingfrTime{k}(1:LbearingResponse);
            timeTheta{k} = bearingfrTime{k}(1:LbearingResponse);
        end
    end
end


%% gear section
waitbar(.33,f_w8bar,'Generation of gear fault signature');
if ~isempty(main_table_ord_mask)
    
    %% how many shafts???
    number_of_shafts = size(main_table_ord_data,1);
    [~,pos] = sort(cell2mat(main_table_ord_data(:,1)));
    main_table_ord_data = main_table_ord_data(pos,:);
    main_table_ord_mask = main_table_ord_mask(pos,:);
    
    for ind_shaft = 1:number_of_shafts
        shaft_gear = cell2mat(main_table_ord_mask(ind_shaft,2));
        frInd = shafts == shaft_gear;
        frInd = find(frInd,1);
        frTemp = fr(:,frInd);
        deltaTheta_temp = deltaTheta(frInd);
        [gearResponse{ind_shaft},gearfrTime{ind_shaft},t{ind_shaft},timeTheta{ind_shaft}] = ordgearSignalModel(frTemp,deltaTheta_temp,main_table_ord_data,main_table_ord_mask,shaft_gear,fs,irfFlag);
        LgearResponse(ind_shaft) = length(gearResponse{ind_shaft});
    end
    
    % overall gear signal
    LgearResponse = min(LgearResponse);
    gearResponseOverall = zeros(1,LgearResponse);
    for k = 1:length(gearResponse)
        gearResponseOverall = gearResponseOverall(:) + gearResponse{k}(1:LgearResponse);
        gearfrTime{k} = gearfrTime{k}(1:LgearResponse);
        timeTheta{k} = timeTheta{k}(1:LgearResponse);
    end
end

%% overall simulated signal
waitbar(.67,f_w8bar,'Synthesis of the overall vibration signature');
LsimulatedSignal = [length(bearingResponseOverall) length(gearResponseOverall)];
LsimulatedSignal(LsimulatedSignal == 0) = [];
LsimulatedSignal = min(LsimulatedSignal);

if isempty(LsimulatedSignal)
    NOSignatureGenerationFlag = 1;
    warndlg('Neither bearing signature nor gear signature have been defined ','Warning');
end

if ~isempty(bearingResponseOverall)
    bearingResponseOverall = bearingResponseOverall(1:LsimulatedSignal);
    for ind = 1:length(bearingfrTime)
        bearingfrTime{ind} = bearingfrTime{ind}(1:LsimulatedSignal);
    end
else
    bearingResponseOverall = zeros(size(gearResponseOverall));
end

if ~isempty(gearResponseOverall)
    gearResponseOverall = gearResponseOverall(1:LsimulatedSignal);
    for ind = 1:length(gearfrTime)
        gearfrTime{ind} = gearfrTime{ind}(1:LsimulatedSignal);
    end
else
    gearResponseOverall = zeros(size(bearingResponseOverall));
end

figure, plot(bearingResponseOverall(:))
hold on
plot(gearResponseOverall(:))

simulatedSignal = bearingResponseOverall(:) + gearResponseOverall(:);
t = (0:LsimulatedSignal-1)./fs;

%% cut the initial part due to distorstion effects of convolution operator
newStartingIndex = 2^9 + 1;
simulatedSignal = simulatedSignal(newStartingIndex:end);

try
    for ind = 1:length(bearingfrTime)
        bearingfrTime{ind} = bearingfrTime{ind}(newStartingIndex:end);
    end
catch
    bearingfrTime = [];
end

try
    for ind = 1:length(gearfrTime)
        gearfrTime{ind} = gearfrTime{ind}(newStartingIndex:end);
    end
    
catch
    gearfrTime = [];
end


%% add background noise
noise = zeros(size(simulatedSignal));
rng('default')
if noise_variance > 0
    noise = sqrt(noise_variance).*randn(size(simulatedSignal)) + noise_mean;
    if noise_nat_freq > 0
        h_noise = mySdofResponse(fs,noise_damping/100,noise_nat_freq,2^9);
        noise = fftfilt(h_noise,noise);
    end
end
simulatedSignal = simulatedSignal(:) + noise(:);


%% save dialog box and plot
if NOSignatureGenerationFlag == 0
    waitbar(1,f_w8bar,'Data plot')
    uisave({'simulatedSignal','noise','gearfrTime','bearingfrTime','fs','M','tau','gearResponseOverall','bearingResponseOverall','estFaultFreq'},'simulatedSignalVars')
    figure, plot((0:length(simulatedSignal)-1)/fs,simulatedSignal,'k')
    title('overall simulated signal')
    xlabel('time (s)')
    box off
else
    waitbar(1,f_w8bar,'Terminating process')
end

close(f_w8bar)