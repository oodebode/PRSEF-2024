function totalSubjectTable(saveDir)

matFiles = dir(fullfile(saveDir,'*.mat'));
for n = 1:length(matFiles)
    cData = load([saveDir matFiles(n).name]);
    
    % concatenates all tables into a working table
    if n == 1
        totalSubTable = cData.finalTable;
    else
        totalSubTable = vertcat(totalSubTable,cData.finalTable);
    end
    
end

save([saveDir 'completeSubData20240122.mat'],"totalSubTable")

end