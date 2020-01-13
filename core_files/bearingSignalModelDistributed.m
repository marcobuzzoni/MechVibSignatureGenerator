function [x, estFaultFreq, frTime, timeTheta] = bearingSignalModelDistributed(frTheta,deltaTheta,faultType,nr,d,D,beta,qRotation,qStiffness,qFault,fs,zita,fn,Lsdof,irfFlag)

% qRotation:    periodic contribution at the rotation frequency
% qStiffness:   periodic contribution due to the stiffness variation at the
%               outer race frequency
% qFault:       contribution due to the presence of an extended defect

switch faultType
    case 'inner'
        geometryParameter = 1 / 2 * (1 + d/D*cos(beta)); % inner race fault
    case 'outer'
        geometryParameter = 1 / 2 * (1 - d/D*cos(beta)); % outer race fault
    case 'ball'
        geometryParameter = 1 / (2*nr) * (1 - (d/D*cos(beta))^2) /(d/D); % outer race fault
end
estFaultFreq = geometryParameter*nr;
% bearingFaultFreq = estFaultFreq * mean(frTheta)
Ltheta = length(frTheta);
thetaEquispaced = (0:Ltheta-1)*deltaTheta;

thetaTime = zeros(1,length(frTheta)); % times at equispaced theta
for index = 2:length(frTheta)
    thetaTime(index) = thetaTime(index - 1) + (deltaTheta)/(2*pi*frTheta(index));
end
Ltime = length(thetaTime);
tEquispaced = (0:Ltime-1)./fs;
frTime = interp1(thetaTime,frTheta,tEquispaced,'spline'); % fr related to equispaced times
timeTheta = interp1(thetaTime,thetaEquispaced,tEquispaced,'spline'); % theta at equispaced times

% generating rotation frequency component
xRotation = qRotation * cos(timeTheta);

% generating stiffness variation component
tauStiffness = nr / 2 * (1 - d/D*cos(beta));
xStiffness = qStiffness * cos(timeTheta*tauStiffness);

% amplitude modulation - MUST have a periodic component and a random one
tauFault = nr*geometryParameter;
q = qFault .* cos(timeTheta*tauFault/2); figure, plot(q), xlim([0 10000])
f = (0:length(q)-1).*fs./length(q);
xFault = (1+q).*randn(1,Ltime);


% adding terms
x = xFault + xStiffness + xRotation;

x = x(:);

%% structural resonance
if zita ~= 0 || fn ~= 0
    zita = zita*.01; % because it's defined as percentage
    h = mySdofResponse(fs,zita,fn,Lsdof,irfFlag);
    y = fftfilt(h,x);
    y = y(:);
else
    y = x;
end