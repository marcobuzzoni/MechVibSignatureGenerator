function y = checkFun(x)
%
%   Check the data before acceptance
%   error codes:
%       1:  data must be integer and positive
% M. Buzzoni
% Mar 2018
y = 0;
[r,~] = size(x);
names = {'Gear number','Shaft number','Mating gear number'};

% data must be positive and integer numbers
for i = 1:r
    for j = 1:4
        test = x{i,j};
        if not(isreal(test) && rem(test,1)==0)
        warndlg([names{j} ' must be positive and integer','Warning'])
        y = 1;
        end
    end
end

% a wheel must mate with another one
flagOk = zeros(1,r);
for i = 1:r % checked gear
    for j = 1:r
        test1 = x{i,3};
        test2 = x{j,1};
        if test1 == test2 && i ~= j
            flagOk(i) = 1;
        end
    end
end
indWarning = find(not(flagOk));
if not(isempty(indWarning))
    y = 1;
    warndlg({['Some gears are not mating with other gears'];['Gear ' num2str(indWarning) ' must be fixed','Warning']})
end