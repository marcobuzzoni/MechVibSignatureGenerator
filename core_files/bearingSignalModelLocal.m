function [y, estFaultFreq, frTime, timeTheta] = bearingSignalModelLocal(frTheta,deltaTheta,faultType,nr,d,D,beta,jitterFactor,meanDelta,stdDelta,periodicModulation,doubleImpactFactor,fs,zita,fn,Lsdof,irfFlag)

% timeTheta: theta at equispaced times!

% meanDelta:                mean amplitude of the impulses
% varianceFactor:       parameter that controls the jitter contribution
% stdDelta:      std of the impulse amplitude, which is Gaussian
%                       distributed, wrt delta
% periodicFactor:       percentage [0,1] of Amplitude Modulation of the extended
%                       fault contribution w.r.t. to qFault
% doubleImpactFactor:   only in case of rolling element fault, it defines the std of the amplitude of the secondary impulses

%% definition of the geometry parameter
switch faultType
    case 'inner'
        geometryParameter = 1 / 2 * (1 + d/D*cos(beta)); % inner race fault
    case 'outer'
        geometryParameter = 1 / 2 * (1 - d/D*cos(beta)); % outer race fault
    case 'ball'
        geometryParameter = D/(2*d*nr) * (1 - (d/D*cos(beta))^2); % outer race fault
end

estFaultFreq = geometryParameter*nr;
% bearingFaultFreq = estFaultFreq * mean(frTheta)
Ltheta = length(frTheta);
thetaEquispaced = (0:Ltheta-1)*deltaTheta;

%% definition of the impulse train occurrences
if strcmp(faultType,'ball')
    deltaThetaFault = 2*pi/(nr*geometryParameter*2);
else
    deltaThetaFault = 2*pi/(nr*geometryParameter);
end
numberOfImpulses = floor(thetaEquispaced(end)/deltaThetaFault);
meanDeltaTheta = deltaThetaFault;
jitterFactor = jitterFactor.*.01; % because it's defined as percentage wrt deltaTheta
varDeltaTheta = (jitterFactor.*meanDeltaTheta)^2;
deltaThetaFault = sqrt(varDeltaTheta)*randn([1 numberOfImpulses-1]) + meanDeltaTheta;
thetaFault = [0 cumsum(deltaThetaFault)];
frThetaFault = interp1(thetaEquispaced,frTheta,thetaFault,'spline');
deltaTimp = deltaThetaFault ./ (2*pi*frThetaFault(2:end));
tTimp = [0 cumsum(deltaTimp)];
Ltime = floor(tTimp(end)*fs); % signal length (time)
thetaTime = zeros(1,length(frTheta)); % times at equispaced theta
for index = 2:length(frTheta)
    thetaTime(index) = thetaTime(index - 1) + (deltaTheta)/(2*pi*frTheta(index));
end
tEquispaced = (0:Ltime-1)./fs;
deltaTimpIndex = round(deltaTimp*fs);
errorDeltaTimp = deltaTimpIndex/fs - deltaTimp;
indexImpulses = [1 cumsum(deltaTimpIndex)];
index = length(indexImpulses);
while indexImpulses(index)/fs > tEquispaced(end)
    index = index - 1;
end
indexImpulses = indexImpulses(1:index);
indexImpulses(indexImpulses>Ltime) = [];

% mean and variance of the fault occurrence
meanDeltaT = mean(deltaTimp);
varDeltaT = var(deltaTimp);
meanDeltaTimpOver = mean(deltaTimpIndex/fs);
varDeltaTimpOver = var(deltaTimpIndex/fs);

frTime = interp1(thetaTime,frTheta,tEquispaced,'spline'); % fr related to equispaced times
timeTheta = interp1(thetaTime,thetaEquispaced,tEquispaced,'spline'); % theta at equispaced times

%% definition of the constant and random contributions
x = zeros(1,Ltime);

if strcmp(faultType,'ball')
    evenIndexImpulses = indexImpulses(2:2:length(indexImpulses));
    oddIndexImpulses = indexImpulses(1:2:length(indexImpulses));
    x(evenIndexImpulses) = meanDelta + stdDelta.*randn(1,length(evenIndexImpulses));
    x(oddIndexImpulses) = doubleImpactFactor + (doubleImpactFactor./meanDelta).*stdDelta.*randn(1,length(oddIndexImpulses));
else
    x(indexImpulses) = meanDelta + stdDelta.*randn(1,length(indexImpulses));
end

%% periodic modulation of the impulses
switch faultType
    case 'inner'
        Q = 1 + periodicModulation .* cos(timeTheta);
        x = x(:).*Q(:);
    case 'outer'
        % do nothing! BPFO do not has periodic modulation of the impulses
        Q = ones(1,length(x));
        x = x(:).*Q(:);
    case 'ball'
        FTF = (1 - d/D*cos(beta))/2;
        eps = meanDelta .* doubleImpactFactor .* 0.01;
        pEven = 1 + periodicModulation .* cos(timeTheta(evenIndexImpulses).*FTF);
        pOdd =  1 + periodicModulation .*cos(timeTheta(oddIndexImpulses).*FTF);
        x(evenIndexImpulses) = x(evenIndexImpulses).*pEven;
        x(oddIndexImpulses) = x(oddIndexImpulses).*pOdd;
end

% figure, plot(x)

%% structural resonance
if zita ~= 0 || fn ~= 0
    zita = zita*.01; % because it's defined as percentage
    h = mySdofResponse(fs,zita,fn,Lsdof,irfFlag);
    y = fftfilt(h,x);
else
    y = x;
end

y = y(:);
