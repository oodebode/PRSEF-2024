function [beta, signedJProbe] = analyzeRG_gameJava(subName, matDir)

% subName should be unique 2-3 letter string
matFiles = dir(fullfile(matDir,['*' subName '*']));

% stores the .mat files into table
subData = cell(length(matFiles),1);

for n = 2:length(matFiles) % pulls and concatenates tables
    cData = load([matDir matFiles(n).name]);
    subData{n} = cData.subjectData;

    dataTableOne = subData{1};
    finalTable = vertcat(dataTableOne,subData{n});
    
end

% determines probe location
probeDiff = finalTable.probeRedFrac - mean([finalTable.sample1RedFrac,finalTable.sample2RedFrac],2);
isCorrect = logical(finalTable.accuracy);

% isolates relevant values into new table
signedJProbe =  table;
signedJProbe.probe = finalTable.probeRedFrac;
signedJProbe.s1 = finalTable.sample1RedFrac;
signedJProbe.s2 = finalTable.sample2RedFrac;
signedJProbe.signed = probeDiff;
signedJProbe.isCorrect = isCorrect;
signedJProbe.choice = signedJProbe.signed < 0 & ~isCorrect | signedJProbe.signed > 0 & isCorrect;
signedJProbe.SD = abs(signedJProbe.s1 - signedJProbe.s2);


% sets up unique values and colors for for loop
% uniqueSD = unique(signedJProbe.SD);  %% this no longer works...
uniqueSD = [0.2,0.3,0.4];
color = ['b','g','r'];

% creates tables used later
beta = table;
probeLocation = table;

for f = 1:length(uniqueSD) % for each unique value, no longer proceeds
    SDIdx = signedJProbe.SD == uniqueSD(f); % create an index for each unique value
    uniqueSDTable = signedJProbe(SDIdx,:); % creates a table with only trials of same SD
    
    figure(1); hold all
    [bs,~,redTable] = createRedTable(uniqueSDTable,uniqueSD(f),color(f)); % feeds table, SD (which is the index) and color (from earlier table) into function
    
    % this legend no longer works... 
    legend('unique probes 20','SD = 20','x limit','y limit','unique probes 30','SD = 30','symbol 1','symbol 2','unique probes 40','SD = 40','Location',"southeast")

    % lines on graph
    set(gca, 'xlim',[-0.25 0.25])
    line([0 0],ylim)
    line(xlim,[0.5 0.5])

    % each unique SD is graphed on top of each other
    hold off

    % storage of b1, SD, and redTables
    beta.b1(f) = bs(2);
    beta.SD(f) = uniqueSD(f);
    beta.redTable{f} = redTable;

    betaRedTable = beta.redTable{f};

    % indexes out only 2%... integrate with a for loop later
    probeLocation.SD(f) = uniqueSD(f);
    probeLocation.negative(f) = 1 - betaRedTable(3,2);
    probeLocation.positive(f) = betaRedTable(6,2);
    
end

probeLocation.avg = mean([probeLocation.negative,probeLocation.positive],2);

% plot beta v. SD as individual points?
figure(2) %% place a stop here, all remaining values are dependant on getting earlier code to work
plot(beta.SD,beta.b1,"LineStyle","-","Marker","o",'MarkerSize',10)

title('Sample Difference vs. B1 of GLM')
xlabel('Sample Difference')
ylabel('B1 Value')

figure(3)
plot(probeLocation.SD,probeLocation.avg, Color='r',Marker='+',MarkerSize=10)

set(gca, 'ylim',[0 1])

title('Average Accuracy Across Probe Location 2%')
xlabel('Sample Difference')
ylabel('Accuracy at Probe Locations')

% legend('SD = 40','SD = 30','SD = 20','Location',"southeast")
end