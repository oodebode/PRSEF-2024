function statOut = doStats_GbemiProject(betaTable)
% Remove subject #27 because of incomplete data
betaTable(27,:) = [];
nSubjects = height(betaTable); % number of subjects

%% Stats on b1
b1_means = mean([betaTable.b1_20 betaTable.b1_30 betaTable.b1_40]);
b1_sem = std([betaTable.b1_20 betaTable.b1_30 betaTable.b1_40])/sqrt(nSubjects);

% b1 figure
figure(1);
errorbar(0.20:0.10:0.40,b1_means/100,b1_sem/100,'LineStyle','-','Marker','.','MarkerSize',40,'LineWidth',2)
% axprefs(gca)
set(gca,'xlim',[0.15 0.45],'xtick',0.20:0.10:0.40)
set(gca, 'FontSize', 18)

title('\DeltaS vs. Mean \beta_1 \pm \sigma_M')
xlabel 'Sample Difference (\DeltaS)'
ylabel 'Mean \beta_1 ± \sigma_M' 
print(1,'-djpeg','SDvsB.jpg')

% Do repeated measures ANOVA to test significance of trend
b1_table = array2table([betaTable.b1_20 betaTable.b1_30 betaTable.b1_40], ...
    'VariableNames',{'b1','b2','b3'});
rptMdl = fitrm(b1_table,'b1-b3~1','WithinDesign',{'SD20','SD30','SD40'},'WithinModel','separatemeans');
anova_stats = ranova(rptMdl);

statOut.b1_p = anova_stats.pValue(1);

%% Stats on accuracy
% % NOTE: THERE ARE INCONSISTENCIES IN THE ACCURACY DATA. SO PUTTING THIS
% % ANALYSIS ON HOLD UNTIL WE GET TO THE BOTTOM OF THAT
% % create new tables on accuracy
% sd20 = nan(6,nSubjects);
% sd30 = nan(10,nSubjects);
% sd40 = nan(10,nSubjects);
% 
% 
% for f = 1:nSubjects
%     idx = find(betaTable.propCorr{f}.SD==0.2);
%     if ~isempty(idx)
%         sd20(:,f) = betaTable.propCorr{f}.propCorrProbes{idx}.propCorrect;
%     end
%     idx = find(betaTable.propCorr{f}.SD==0.3);
%     if ~isempty(idx)
%         sd30(:,f) = betaTable.propCorr{f}.propCorrProbes{idx}.propCorrect;
%     end
%     idx = find(betaTable.propCorr{f}.SD==0.4);
%     if ~isempty(idx)
%         sd40(:,f) = betaTable.propCorr{f}.propCorrProbes{idx}.propCorrect;
%     end
% end


end
