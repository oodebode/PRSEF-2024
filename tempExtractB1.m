function tempExtractB1(matDir)

betaAnalysis = table;
%subNames = ['BN';'CW';'EG';'EN';'ER';'ES';'GR';'IP';'JC';'JK';'JN';'KC';'KL';'KW';'LK';'LUS';'LY_';'LYS';'MA_';'MIS';'MM';'MS';'PM';'PS';'RT';'SG';'SOG';'SS'];

matFiles = load("data202401_matFiles.mat");
openMatFiles = matFiles.matFiles;

for n = 1:length(openMatFiles)

    cSubName = openMatFiles.name{n};
    [beta] = analyzeRG_gameJava(cSubName,matDir);

    betaAnalysis.subName(n) = subNames(n);

    betaAnalysis.Twenty(n) = beta{1,1};
    betaAnalysis.Thirty(n) = beta{2,1};
    betaAnalysis.Fourty(n) = beta{3,1};

end
end
