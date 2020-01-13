function outputData = data2mask(inputData)
%
%   Transform table data into table mask
% 
% M. Buzzoni
% Mar 2018

outputData = inputData;
[r,c] = size(inputData);

try
    for i = 1:r
        for j = 7:c
            test = inputData{i,j};
            test = test(:,2:end);
            if isempty(find(test))
                outputData{i,j} = false;
            end
        end
    end
catch
    for i = 1:r
        for j = 7:c
            test = inputData{i,j};
            test = test(:,2:end);
            test = cell2mat(test);
            if isempty(find(test))
                outputData{i,j} = false;
            else
                outputData{i,j} = true;
            end
        end
    end
end
    
    
%             if j == 5
%                 outputData{i,j} = size(inputData{i,j},1);
%             else
%                 outputData{i,j} = true;
%             end
%         elseif inputData{i,j} == 0
%             outputData{i,j} = false;
%         elseif isempty(inputData{i,j})
%             outputData{i,j} = false;
%         end
%     end
% end