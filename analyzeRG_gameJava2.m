function [beta, uniqueSD, percentAccuracy, tempTable, fig] = analyzeRG_gameJava2(finalTable,graphTitle,figSaveDir)

% determines probe location (probeDiff) as distance from average redness of samples,
% is a percent
probeDiff = finalTable.probeRedFrac - mean([finalTable.sample1RedFrac,finalTable.sample2RedFrac],2);
isCorrect = logical(finalTable.accuracy);

% isolates relevant values into new table
signedJProbe =  table;
signedJProbe.probe = finalTable.probeRedFrac;
signedJProbe.s1 = finalTable.sample1RedFrac;
signedJProbe.s2 = finalTable.sample2RedFrac;
signedJProbe.signed = probeDiff;
signedJProbe.isCorrect = isCorrect;

% ie. did they choose the more red option? regardless of correctness
signedJProbe.choice = signedJProbe.signed < 0 & ~isCorrect | signedJProbe.signed > 0 & isCorrect;
signedJProbe.SD = round(abs(signedJProbe.s1 - signedJProbe.s2),2);


% sets up unique values and colors for for loop, expected only 3 SD to be
% tested at a time
uniqueSD = unique(signedJProbe.SD);  
color = ['b','g','r'];

% creates tables used later
beta = table;
percentAccuracy = table;
weightedAvgs = table;
tempTable = table;
addTable = table;

% creates overall figure, three tiled
fig = figure(1);
for f = 1:length(uniqueSD) % for each unique value
    
    SDIdx = signedJProbe.SD == uniqueSD(f); % create an index for each unique value
    uniqueSDTable = signedJProbe(SDIdx,:); % creates a table with only trials of same SD
    
    uniqueProbeLoc = unique(round(uniqueSDTable.signed,2)); % finds the unique probes
    cPercentAcc = table; % godspeed, so many tables from here

    for p = 1:length(uniqueProbeLoc) % from 1 to the number of unquie probes

        uProbeLocIdx = round(uniqueSDTable.signed,2) == uniqueProbeLoc(p);
        uniqueProbeLocTable = uniqueSDTable(uProbeLocIdx,:); % creates a table with only trials at specific probeLoc
        
        % all relevent data is stored in cProbeLoc
        cPercentAcc.SD(p) = uniqueSD(f); % stores the SD of the trials
        cPercentAcc.probeLoc(p) = uniqueProbeLoc(p); % stores the probe location
        cPercentAcc.nTrials(p) = length(uniqueProbeLocTable.signed); % number of trials at that probeLoc
        cPercentAcc.nCorr(p) = sum(uniqueProbeLocTable.isCorrect); % sums correct trials
        cPercentAcc.avgAcc(p) = cPercentAcc.nCorr(p)/cPercentAcc.nTrials(p); % calculates accuracy as a function of correct/total
    end
        

    if f == 1
        percentAccuracy = cPercentAcc; % oh my goodness another table
    else
        percentAccuracy = vertcat(percentAccuracy,cPercentAcc); % concatenates all cPercentAcc for every unique probe into one table

    end
    
    absUniqueProbe = unique(abs(cPercentAcc.probeLoc)); % finds the positive probes (since it is signed)
    weightedAvg = table; % nother table

    for i = 1:length(absUniqueProbe) 
        absIdx = cPercentAcc.probeLoc == absUniqueProbe(i);
        cWeightedAvg = cPercentAcc(absIdx,:);

        weightedAvg.probeLoc(i) = absUniqueProbe(i);

        % if height(cWeightedAvg) > 1
        %     weightedAvg.mean(i) = ((cWeightedAvg.nTrials(1) * cWeightedAvg.avgAcc(1)) + (cWeightedAvg.nTrials(2)*cWeightedAvg.avgAcc(2))) / (cWeightedAvg.nTrials(1) + cWeightedAvg.nTrials(2));
        % else
            weightedAvg.mean(i) = cWeightedAvg.avgAcc;
        % end
    end

    weightedAvgs.SD{f} = weightedAvg;
    randTable = table;

    for a = 1:height(weightedAvgs)
        cTable = weightedAvgs.SD{a};
        
        for b = 1:height(cTable.probeLoc)
            if cTable.probeLoc(b) == 0.02
                randTable.twoPercAcc = cTable{b,2};
            end

            if cTable.probeLoc(b) == 0.04
                randTable.fourPercAcc = cTable{b,2};
            end

            if cTable.probeLoc(b) == 0.08
                randTable.eightPercAcc = cTable{b,2};
            end
        end
    end
    
    tempTable.SD{f} = randTable;

    if f == 1
        addTable = tempTable.SD{1};
    else
        addTable = vertcat(addTable,tempTable.SD{f});
    end

    hold all
    [bs,~,redTable,stats] = createRedTable(uniqueSDTable,uniqueSD(f),color(f),graphTitle); % feeds table, SD (which is the index) and color (from earlier table) into function
     
    legend('Location','southeast')

    % storage of b1, SD, and redTables
    beta.b1(f) = bs(2);
    beta.SD(f) = uniqueSD(f);
    beta.redTable{f} = redTable;
    beta.error(f) = stats.se(2);
end

% each unique SD is graphed on top of each other
hold off

% center lines on graph
set(gca, 'xlim',[-0.25 0.25])
yLine = line([0 0],ylim,'LineWidth',1);
xLine = line(xlim,[0.5 0.5],'LineWidth',1);

% axis and analysis lines
vertLine = line([-0.08 -0.08],ylim);
set(vertLine, 'LineStyle', '--','Color', 'black','LineWidth',1);
set(get(get(vertLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

set(get(get(yLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(xLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

axes = gca;
axes.TickDir = 'out';

% plot beta v. SD as individual points
betaFig = figure(2);
errorbar(beta.SD,beta.b1,beta.error,"LineStyle","-","Marker",".",'MarkerSize',40,'LineWidth',2)

len = length(uniqueSD);
set(gca,'xlim',[(uniqueSD(1) - 0.01) (uniqueSD(len) + 0.01)])

title([sprintf('Subject %s',graphTitle), ' \DeltaS vs. \beta_1 ', 'of GLM']);
xlabel('Sample Difference (\DeltaS)')
ylabel('\beta_1 Value')
axes.TickDir = 'out';

set(gca, 'FontSize', 18)

hold off

figure(3)
plot(uniqueSD,addTable.twoPercAcc,"LineStyle","-","Marker","o",'MarkerSize',10)

hold on
plot(uniqueSD,addTable.fourPercAcc,"LineStyle","-","Marker","o",'MarkerSize',10)
plot(uniqueSD,addTable.eightPercAcc,"LineStyle","-","Marker","o",'MarkerSize',10)

title('Subject Accuracy at Probe Locations 2, 4, and 8%')
xlabel('\DeltaS')
ylabel('Percent Accuracy')

set(gca,'xlim',[(uniqueSD(1) - 0.01) (uniqueSD(len) + 0.01)])
legend('2%','4%','8%','Location','southeast')
set(gca, 'FontSize', 18)

hold off

filename = fullfile(figSaveDir,[graphTitle '20240122']);
saveas(fig,filename,'fig');

betaName = fullfile(figSaveDir,[graphTitle '20240122b1_SD']);
saveas(betaFig,betaName,'fig')

close all

end