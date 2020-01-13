function sdofRespTime = mySdofResponse(fs,zita,fn,Lsdof,irfFlag)
%% Single DOF response generator
%
%
% M. Buzzoni
% Aug. 2018
% revised in May 2018

fs = 25600;
zita = .05;
fn = 6000;
Lsdof = 2^8;

t = (0:Lsdof-1)/fs;
omegan = fn*(2*pi); % undamped natural frequency in rad/s
omegad = omegan*sqrt(1-zita^2); % damped natural frequency in rad/s
        
switch irfFlag
    case 0
    sdofRespTime = exp(-zita*omegan*t).*sin(omegad*t); % solution to the underdamped system for the mass-spring-damper (displacement)
    case 1
        % solution to the underdamped system for the mass-spring-damper (velocity)
    sdofRespTime = omegad .* exp(-omegan .* t .*zita) .* cos(omegad .* t) - omegan .* zita .*exp(-omegan .*t .* zita) .* sin(omegad .* t);
    case 2
    % solution to the underdamped system for the mass-spring-damper (acceleration)
    sdofRespTime = (omegan^2*zita^2) .* exp(-omegan .* t .* zita) .* sin(omegad .* t) ...
    - (omegad^2) .* exp(-omegan .* t*zita) .* sin(omegad .* t) ...
    - (2*omegad*omegan*zita) .* exp(-omegan .* t .* zita) .* cos(omegad .* t);
end

