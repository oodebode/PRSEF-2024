function [fullTable] = analyzeBetaOne(matDir)

twoLetterTable = table;

twoLetterTable.subName = ['BN';'CW';'EG';'EN';'ER';'ES';'GR';'IP';'JC';'JK';'JN';'KC';'KL';'KW';'LK';'LY'];

betaOne = table;

for n = 1:height(twoLetterTable)
    [beta] = analyzeRG_gameJava2(twoLetterTable.subName(n),matDir);
    
    betaOne.subID(n) = twoLetterTable.subName(n);
    betaOne.Twenty(n) = beta{1,1};
    betaOne.Thirty(n) = beta{2,1};
    betaOne.Forty(n) = beta{3,1};
end

fullTable = table(twoLetterTable{:,:},betaOne);
end