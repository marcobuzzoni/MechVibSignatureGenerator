function y = checkFun_bearing(x)
%
%   Check the data before acceptance
%
% M. Buzzoni
% Mar 2018

y = 0;
[r,~] = size(x);
names = {'Roll. element no.','Bearing roller d.','Pitch circle d.','Contact angle'};

% data must be positive and integer numbers
for i = 1:r
    for j = 3:5
        test = x{i,j};
        
        if j == 3
            if not(isreal(test) && rem(test,1)==0)
                warndlg([names{j-2} ' must be positive and integer','Warning'])
                y = 1;
            else
                continue
            end
        end
        
        if not(isreal(test) && test > 0)
        warndlg([names{j-2} ' must be real and positive','Warning'])
        y = 1;
        end
    end
end
