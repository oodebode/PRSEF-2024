function wrapperRG_game(subjectID, nTrials,SD)
% inputs: subject identification, number of trials, difference between red
% fraction of samples one and two
    % subjectID = Subj_FILI_YYYYMMDDHHMM
    % FI = first initial
    % LI = last initial
    % YYYYMMDDHHMM = year,month,day,hour (military),minute
    % initialized the table within which results will be shared

results = table;
signedProbe = table;

% data file should save as date, time, subjectID
% save: (sample 1 red compositon percentage) rFrac1,(sample 2) rFrac2, (probe, tested variable) rFrac3, choice (of subject), reaction time, logical(isCorrect)

% subjectID will be a string
% nTrial - number of trials

for f = 1:nTrials

    % calls the game program for nTrials
    [rFrac1, rFrac2, rFrac3, answer, logical, probeDiff, choice, tElapsed] = createRG_game(30,30,SD);
    pause(1)

    % stores relevant information
    results.rFrac1(f) = rFrac1;
    results.rFrac2(f) = rFrac2;
    results.rFrac3(f) = rFrac3;
    results.answer(f) = answer;
    results.logical(f) = logical;
    results.timeElapsed(f) = tElapsed;
    
    % where probeDiff is probe location (distance from the avergae redness
    % of both samples in the more green, and more red directions)

    signedProbe.probeDiff(f) = round(probeDiff,2);
    signedProbe.choice(f) = choice;

end

assignin("base","results",results)
assignin("base","signedProbe",signedProbe)

% downloads subject file
save(subjectID,'results','signedProbe')

end