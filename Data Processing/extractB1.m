function extractB1(matDir)

betaOne = table;

matFiles = dir(fullfile(matDir));
uSubID = matFiles.name;


% for n = 1:length(matFiles)
%     extractIdx = regexp(matFiles.name(n),subName,"match");
% end

% [beta] = analyzeRG_gameJava2(subName, matDir);

betaOne.subID = subID;
betaOne.Twenty(n) = beta(1,1);
betaOne.Thirty(n) = beta(2,1);
betaOne.Forty(n) = beta(3,1);

end
