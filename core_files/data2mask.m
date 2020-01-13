function outputData = data2mask(inputData,Nmh_static)
%
%   Transform table data into table mask
% 
% M. Buzzoni
% Mar 2018

outputData = inputData;
[r,c] = size(inputData);

for i = 1:r
    for j = 5:c
        if length(inputData{i,j}) > 1
            if j == 5
                outputData{i,j} = size(inputData{i,j},1);
            else
                outputData{i,j} = true;
            end
        elseif inputData{i,j} == 0
            outputData{i,j} = false;
        elseif isempty(inputData{i,j})
            outputData{i,j} = false;
        end
    end
end