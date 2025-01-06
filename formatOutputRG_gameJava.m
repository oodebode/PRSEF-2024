function [betaTable, statSig, beta, tiredOfTables] = formatOutputRG_gameJava(saveDir,vSubjects,figSaveDir)

fullFiles = dir(fullfile(saveDir,'*.mat'));

betaTable = table;
statSig = table;
IDPerAcc = table;
fullPerAcc = table;

twenty = table;
thirty = table;
forty = table;

for n = 1:length(fullFiles)
    loadTable = load([saveDir fullFiles(n).name]);
    finalTable = loadTable.finalTable;
    
    subID = cell2mat(vSubjects(n));
    graphTitle = subID(1:end-1);

    [beta, uniqueSD, percentAccuracy, tempTable, ~] = analyzeRG_gameJava2(finalTable,graphTitle,figSaveDir);
    
    nSub = table;
    cTwenty = table;
    cThirty = table;
    cForty = table;

    for m = 1:height(percentAccuracy)
        nSub.subNum(m) = n;
    end
    
    IDPerAcc = [nSub,percentAccuracy];

    betaTable.b1_20(n) = beta.b1(1);
    betaTable.b1_30(n) = beta.b1(2);
    betaTable.b1_40(n) = beta.b1(3);

    cTwenty = tempTable.SD{1};
    cThirty = tempTable.SD{2};
    cFourty = tempTable.SD{3};

    if n == 1
        fullPerAcc = IDPerAcc;
        twenty = cTwenty;
        thirty = cThirty;
        forty = cFourty;

    else
        fullPerAcc = vertcat(fullPerAcc,IDPerAcc);
        twenty = vertcat(twenty,cTwenty);
        thirty = vertcat(thirty,cThirty);
        forty = vertcat(forty,cFourty);
    end 
end

tiredOfTables = table;

tiredOfTables.SD = beta.SD;
tiredOfTables.tables{1} = twenty;
tiredOfTables.tables{2} = thirty;
tiredOfTables.tables{3} = forty;
 
for d = 1:height(tiredOfTables)
    cTable = tiredOfTables.tables{d};

    tiredOfTables.two(d) = mean(cTable.twoPercAcc);
    tiredOfTables.twoStats(d) = std(cTable.twoPercAcc)/sqrt(length(cTable.twoPercAcc));
    tiredOfTables.four(d) = mean(cTable.fourPercAcc);
    tiredOfTables.fourStats(d) = std(cTable.fourPercAcc)/sqrt(length(cTable.fourPercAcc));
    tiredOfTables.eight(d) = mean(cTable.eightPercAcc);
    tiredOfTables.eightStats(d) = std(cTable.eightPercAcc)/sqrt(length(cTable.eightPercAcc));
end
% stores mean first, then standard deviation, then standard error
for l = 1:width(betaTable)

    statSig.mean(l) = mean(betaTable{:,l});
    statSig.standDiv(l) = std(betaTable{:,l});
    statSig.standErr(l) = statSig.standDiv(l)/sqrt(length(betaTable{:,l}));

end

b1_SD = figure;
errorbar(beta.SD,statSig.mean,statSig.standErr,"LineStyle","-","Marker","o",'MarkerSize',10);
title('Averaged \beta_1 Value against \DeltaS')
xlabel('Sample Difference (\DeltaS)')
ylabel('Averaged \beta_1 Value')

len = length(uniqueSD);
set(gca,'xlim',[(uniqueSD(1) - 0.01) (uniqueSD(len) + 0.01)]) 
set(gca, 'FontSize', 18)


percAcc = figure;
errorbar(tiredOfTables.SD,tiredOfTables.two,tiredOfTables.twoStats)
title('Average Weighted Accuracy at Probe Locations')
xlabel('\DeltaS')
ylabel('Average Accuracy')

hold all
errorbar(tiredOfTables.SD,tiredOfTables.four,tiredOfTables.fourStats)
errorbar(tiredOfTables.SD,tiredOfTables.eight,tiredOfTables.eightStats)

legend('2%','4%','8%')
set(gca,'xlim',[(uniqueSD(1) - 0.01) (uniqueSD(len) + 0.01)]) 
set(gca, 'FontSize', 18)

hold off

statOut = doStats_GbemiProject(betaTable);
% filename = fullfile(figSaveDir,['b1_SD' '20240122']);
% saveas(b1_SD,filename,'fig');
end