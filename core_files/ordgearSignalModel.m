function [response,tachoTime,t,timeTheta] = ordgearSignalModel(frTheta,deltaTheta,main_table_ord_data,main_table_ord_mask,nShaft,fs,irfFlag)

% old [signalTime,tachoTime,t] = ordgearSignalModel(frTheta,M,tauNumerator,tauDenominator,main_table_ord_data,main_table_ord_mask,nShaft,fs)

% frTheta is the angle domain rotation frequency vector of the first shaft

% if we are not in the first shaft, compute the vector of angles referenced
% to the correct shaft
%
% if gear 1 and gear 2 are in the same shaft or gear 1 is tied in the
% first shaft, then tauNumerator = tauDenominator

% frTheta = speed_profile.fr;
% % frTheta = fr(:,2);
% M = 5000;
% nShaft = 1;
% fs = 25600;

response = [];
Ltheta = length(frTheta);
thetaEquispaced = (0:Ltheta-1)*deltaTheta;
nRev = floor(thetaEquispaced(end)/(2*pi));

%%  how many gearmnesh harmonics do we have?
Z = main_table_ord_data{nShaft,4}; % tooth number
GMharmonics = cell2mat(main_table_ord_data{nShaft,5});
nGMharmonics = size(GMharmonics,1);

%% NOTE: if the GM harmonic amplitudes are set to 0, then return
if sum(GMharmonics(:,1)) == 0    
    return
end

% some initializations
signal = zeros(1,Ltheta); % signal initialization
a = zeros(nGMharmonics,Ltheta); % AM contribution initialization
b = zeros(nGMharmonics,Ltheta); % PM contribution initialization
a_loc = zeros(nGMharmonics,Ltheta); % local AM contribution initialization
b_loc = zeros(nGMharmonics,Ltheta); % local PM contribution initialization
thetaImpulses = zeros(1,nRev);
frThetaImpulses = zeros(1,nRev);
%% generate local and distributed AM/PM
for k = 6:7
    if k == 6
        %     if faultMaskVector(k) && k == 1 % AM
        try
            AM = cell2mat(main_table_ord_data{nShaft,k});
            for j = 1:nGMharmonics
                if AM(j,2) == 0
                    a(j,:) = AM(j,2) .* cos(j*thetaEquispaced + AM(j,3)*pi/180);
                else
                    a(j,:) = 1 + AM(j,2) .* cos(j*thetaEquispaced + AM(j,3)*pi/180);
                end
                
                if AM(j,5) == 0
                    b(j,:) = AM(j,5) .* cos(j*thetaEquispaced + PM(j,6)*pi/180);
                else
                    b(j,:) = 1 + AM(j,5) .* cos(j*thetaEquispaced + PM(j,6)*pi/180);
                end
            end
        catch
            a = zeros(nGMharmonics,length(thetaEquispaced));
            b = zeros(nGMharmonics,length(thetaEquispaced));
        end
    elseif k == 7
        try
            main_table_ord_data_temp = main_table_ord_data;
            main_table_ord_data_temp{nShaft,7}{11} = str2num(main_table_ord_data{nShaft,7}{11});
            LOCALIZED = cell2mat(main_table_ord_data_temp{nShaft,7});
            faultedToothNumber = LOCALIZED(11);
            for j = 1:nGMharmonics
                theta0 = 2*pi/Z*faultedToothNumber;
                if LOCALIZED(j,2) == 0
                    a_loc(j,:) = LOCALIZED(j,2) .* cos(j*thetaEquispaced + LOCALIZED(j,3)*pi/180);
                else
                    a_loc(j,:) = 1 + LOCALIZED(j,2) .* cos(j*thetaEquispaced + LOCALIZED(j,3)*pi/180);
                end
                
                if LOCALIZED(j,6) == 0
                    b_loc(j,:) = LOCALIZED(j,6) .* cos(j*thetaEquispaced + LOCALIZED(j,7)*pi/180);
                else
                    b_loc(j,:) = 1 + LOCALIZED(j,6) .* cos(j*thetaEquispaced + LOCALIZED(j,7)*pi/180);
                end
                gaussWin_a_loc = zeros(1,Ltheta);
                gaussWin_b_loc = zeros(1,Ltheta);
                while theta0 < thetaEquispaced(end)
                    gaussWin_a_loc = gaussWin_a_loc + (exp(-(thetaEquispaced-theta0).^2/4/LOCALIZED(j,4)^2));
                    gaussWin_b_loc = gaussWin_b_loc + (exp(-(thetaEquispaced-theta0).^2/4/LOCALIZED(j,8)^2));
                    theta0 = theta0 + 2*pi;
                end
                a_loc(j,:) = a_loc(j,:) .* gaussWin_a_loc;
                b_loc(j,:) = b_loc(j,:) .* gaussWin_b_loc;  
            end
        catch
            a_loc = zeros(nGMharmonics,length(thetaEquispaced));
            b_loc = zeros(nGMharmonics,length(thetaEquispaced));
        end
    end
end

try
    AM = cell2mat(main_table_ord_data{nShaft,6});
    for j = 1:nGMharmonics
    CYC_contribution = (1 + AM(j,8) .* cos(j/2*thetaEquispaced + AM(j,9)*pi/180)) .* randn(1,length(thetaEquispaced));
    end
catch
    CYC_contribution = zeros(nGMharmonics,length(thetaEquispaced));
end

for j = 1:nGMharmonics
    signal = signal + GMharmonics(j,2) .* (1 + a(j,:) + a_loc(j,:)) .* cos(j*Z*thetaEquispaced + GMharmonics(j,3) + b(j,:) + b_loc(j,:));
end

%% gear vibration time resampling
t_theta = zeros(1,length(frTheta)); % times at equispaced theta
for index = 2:length(frTheta)
    t_theta(index) = t_theta(index - 1) + (deltaTheta)/(2*pi*frTheta(index));
end
T = t_theta(end);
t = 0:1/fs:T;
% t = (0:L-1)/fs;
tachoTime = interp1(t_theta,frTheta,t,'spline'); % fr related to equispaced times
timeTheta = interp1(t_theta,thetaEquispaced,t,'spline'); % theta at equispaced times
if sum(abs(signal)) > 0
    signalTime = interp1(t_theta,signal,t,'spline'); % time domain signal
else
    signalTime = zeros(size(t));
end

% interpolation of the cyclostationary contribution
if sum(abs(CYC_contribution)) > 0
    CYC_contribution_time = interp1(t_theta,CYC_contribution,t,'spline');
else
    CYC_contribution_time = zeros(size(signalTime));
end
CYC_contribution_time = CYC_contribution_time(:);

%% include the impulsive part
timeImpulses = zeros(size(thetaImpulses));
frTheta = frTheta(:)';

%% find the impulse occurrences in the angle domain
try
    faultedToothNumber = str2num(main_table_ord_data{nShaft,7}{11});
    thetaImpulses(1) = (1 + (faultedToothNumber-1)) * floor(M/Z)*2*pi/M;
    for indexRev = 2:nRev
        thetaImpulses(indexRev) = thetaImpulses(indexRev-1) + 2*pi;
    end
    frThetaImpulses = interp1(thetaEquispaced,frTheta,thetaImpulses,'spline');
end

try
    W = main_table_ord_data{nShaft,7}{9};
    sigma_imp = main_table_ord_data{nShaft,7}{10};
    for index = 1:length(thetaImpulses)
        thetaBeforeImpulse = thetaEquispaced < thetaImpulses(index);
        thetaWithAddedImpulse = [thetaEquispaced(thetaBeforeImpulse) thetaImpulses(index)];
        frWithAddedImpulse = [frTheta(thetaBeforeImpulse) frThetaImpulses(index)];
        timeWithImpulse = cumsum(diff(thetaWithAddedImpulse)./(2*pi*frWithAddedImpulse(2:end)));
        timeImpulses(index) = timeWithImpulse(end);
    end
    win_impulses = zeros(size(t));
    for indexImpulses = 1:length(timeImpulses)
        new_win = (W*exp(-(t-timeImpulses(indexImpulses)).^2/4/sigma_imp^2));
        if max(new_win) < W - 10^-5
            sigma_imp_temp = sigma_imp + 10^-4;
            while max(new_win) < W - 10^-5 % just to be sure that the window width is proper
                 new_win = (W*exp(-(t-timeImpulses(indexImpulses)).^2/4/sigma_imp_temp^2));
                 sigma_imp_temp = sigma_imp_temp + + 10^-4;
            end
        end
        win_impulses = win_impulses + new_win;
    end
catch
    win_impulses = zeros(size(t)); 
end

%% LTI systems
try
    LTIsystemParam = cell2mat(main_table_ord_data{nShaft,8});
    fn_det = LTIsystemParam(1);
    zita_det = LTIsystemParam(2)/100;
    if fn_det ~= 0 && zita_det ~= 0
        h_det = mySdofResponse(fs,zita_det,fn_det,2^9,irfFlag);
        y_det = fftfilt(h_det,signalTime + win_impulses); y_det = y_det(:);
    else
        y_det = signalTime(:);
    end
catch
    y_det = signalTime(:);
end

try
    LTIsystemParam = cell2mat(main_table_ord_data{nShaft,8});
    fn_ran = LTIsystemParam(3);
    zita_ran = LTIsystemParam(4)/100;
    if fn_ran ~= 0 && zita_ran ~= 0
        h_ran = mySdofResponse(fs,zita_ran,fn_ran,2^9,irfFlag);
        y_ran = fftfilt(h_ran,CYC_contribution_time); y_ran = y_ran(:);
    else
        y_ran = CYC_contribution_time(:);
    end
catch
    y_ran = CYC_contribution_time(:);
end

%% response
response = y_det(:) + y_ran(:);
