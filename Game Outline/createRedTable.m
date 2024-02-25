function [bs,yfit,redTable,stats] = createRedTable(SDtable,SD,color,graphTitle)
% inputs: trials with the same sample difference (SDTable), the sample
% difference (SD), the color of the graph, subject ID or general naming
% information string (graphTitle)

% outputs: beta values of GLM (bs), slope of GLM (yfit), table containing
% probe location and probability of choosing red (redTable), general GLM
% statistics (stats)

% looks for the number of unique probe values in trial data
%% must round to 2 decimal places or you WILL GET THE WRONG ANSWER
uProbe = unique(round(SDtable.signed,2));

% creates a zeros tables that is uProbe rows by 2 columns
redTable = zeros(length(uProbe),2);
for f = 1:length(uProbe)

    % stores probe location
    redTable(f,1) = uProbe(f);

    % sum (number of) probes where the subject chose the more red option
    red = sum(round(SDtable.signed,2) == uProbe(f) & SDtable.choice == 1);

    % sum of probes, regardless of subject choice
    redTotal = sum(round(SDtable.signed,2) == uProbe(f));

    % calculates the probability of subject choosing red, (red
    % choices/total choices)
    redTable(f,2) = red/redTotal;
end

% creates the restriction on the x for GLM fit, probes have /pm locations
% based on averge redness btwn samples, xvals must account for max probe
% location in both directions. ie. if the probe was completely green, where
% would it be, and vice versa
xvals = -(SD/2):0.01:(SD/2);

% plots probe against probability of choosing red
probePoints = plot(redTable(:,1), redTable(:,2),"LineStyle","none",'Marker',".","Color",color,"MarkerSize",20);
[bs, yfit, stats] = getGLMfit_logistic(redTable(:,1), redTable(:,2), xvals); % creates GLM (literally just calls fitglm)
% outputs are the beta factors of a GLM, the y-axis range, and the general
% statisics associated with the model

% plots the line
plot(xvals,yfit,"LineStyle","-","Color",color,'Marker','none',"LineWidth",1,'DisplayName',['\Delta S = ',sprintf('%s',round(SD,2))])
set(get(get(probePoints,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

% housekeeping
title(sprintf('Subject %s Generalized Logistic Model',graphTitle))
xlabel('Probe Location (\Delta from center)')
ylabel('Probability of Choosing Red')

end