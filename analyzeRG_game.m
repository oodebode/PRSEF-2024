function analyzeRG_game(SD)

% take largest sample diff of data to form x-axis

% 600 trials @30,40,50 supersets data path file

beta = table;

% SD probed in pos + neg directions
xvals = -(SD/2):0.1:(SD/2);

% must manually enter given data table
load("subj_202312201020.mat");
% SDiff1 = 0.05;
signedProbe(:,1) = round(signedProbe(:,1),2);

% sofia's code, both versions work
uProbe = unique(signedProbe.probeDiff);
redTable = zeros(length(uProbe),2);
for f = 1:length(uProbe)
    redTable(f,1) = uProbe(f);
    red = sum(signedProbe.probeDiff == uProbe(f)&signedProbe.choice == 1);
    redTotal = sum(signedProbe.probeDiff == uProbe(f));
    redTable(f,2) = red/redTotal;
end

figure(1); hold all
plot(redTable(:,1), redTable(:,2),"LineStyle","none",'Marker',".", "Color",'r',"MarkerSize",30);

% alternative pathway - allows bypass of for loop
% plot(signedProbe.probeDiff,signedProbe.choice,"LineStyle", ...)
% [bs, yfit, stats] = getGLMfit_logistic(signedProbe.probeDiff,signedProbe.choice,xvals);

[bs, yfit, stats] = getGLMfit_logistic(redTable(:,1), redTable(:,2), xvals);

plot(xvals,yfit,"LineStyle","-","Color",'b','Marker','none','LineWidth',2)

% stores b0 and b1 of logisitic in table

% b1_1 = bs;

% attempts to store b1 and SD in a table
beta.b1(1) = bs(2);
beta.SD(1) = 0.05;

load("subj_202312201006.mat"); 
% SDiff2 = .1;

[bs, yfit, stats] = getGLMfit_logistic(signedProbe.probeDiff, signedProbe.choice, xvals);

% b1_2 = bs(1,2);
beta.b1(2) = bs(2);
beta.SD(2) = 0.1;


disp(beta)
% plots points, then lines
plot(signedProbe.probeDiff, signedProbe.choice,"LineStyle","none","Color",'b');
plot(xvals,yfit,"LineStyle","-","Color",'b','Marker','none',"LineWidth",2)

title('Generalized Logistic Model of Choices')
xlabel('Sample Difference Probed in Both Directions')
ylabel('"Redness" of Sample')

hold off

figure(2)
plot(beta.b1,beta.SD,"LineStyle","none","Marker","o")
% 
% b1 = [b1_1;b1_2];
% SDiff = [SDiff1;SDiff2];
% beta = table(b1,SDiff);

%assignin("base","beta",beta)
% 
% figure(2)
% plot(beta.b1,beta.SDiff)

end