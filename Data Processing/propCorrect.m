function [betaTable] = propCorrect(saveDir,vSubjects,figSaveDir)

fullFiles = dir(fullfile(saveDir,'*.mat'));
betaTable = table;

for n = 1:length(fullFiles)
    loadTable = load([saveDir fullFiles(n).name]);
    finalTable = loadTable.finalTable;
    
    graphTitle = cell2mat(vSubjects(n));
    [beta,~,~,~,~,propCorrSD] = analyzeRG_gameJava2(finalTable,graphTitle,figSaveDir);

    betaTable.subID(n) = convertCharsToStrings(graphTitle);
    betaTable.b1_20(n) = beta.b1(1);
    betaTable.b1_30(n) = beta.b1(2);
    betaTable.b1_40(n) = beta.b1(3);

    betaTable.propCorr{n} = propCorrSD;
    
end

save(['C:\Users\ojdod\OneDrive\Documents\MATLAB\RGgame\Subject Data Output\' 'propCorrect.mat'],"betaTable")
end
