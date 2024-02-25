function [rFrac1, rFrac2, rFrac3, answer, logical, probeDiff, choice, tElapsed] = createRG_game(xPx,yPx,SD)
% inputs: dimensions of figures, difference between red fraction of samples one and two
% outputs: red fraction of samples one, two, and the probe, correct answer
% to task, whether the subject made the correct choice, probe location
% (distance of probe from average redness of both samples), where the
% subject chose red, reaction time

% initialize the figure
rgImg = zeros(xPx,yPx,3);

% intialize layers of 3D matrix that compose figure
r = zeros(yPx,xPx);
g = zeros(yPx,xPx);
b = zeros(yPx,xPx);

% assign layers to 3D matrix
rgImg(:,:,1) = r;
rgImg(:,:,2) = g;
rgImg(:,:,3) = b;

% creates a random number between 0 and 1-the sample difference, rounded to
% two decimal points, to be rFrac one 
rFrac1 = round(randbetween(0,1-SD),2);

% creates the first figure, known as sample one 
box1 = rgGame(rgImg,rFrac1);

figure(1)

% initializes and plots sample one onto the entire figure
subplot(2,3,1)
imagesc(box1)
axis off equal
title 'Box One'

% creates the red fraction of second sample exactly the sample distance
% away from the first
rFrac2 = round((rFrac1 + SD),2);

box2 = rgGame(rgImg,rFrac2);

subplot(2,3,3)
imagesc(box2)
axis off equal
title 'Box Two'
pause(5)

subplot(2,3,1)
imagesc(zeros(xPx,yPx,3))
axis off equal
title 'One'

subplot(2,3,3)
imagesc(zeros(xPx,yPx,3))
axis off equal
title 'Two'
pause(1)

% creates red fraction of probe at a random point between samples one and
% two
rFrac3 = round(randbetween(rFrac1,rFrac2),2);

box3 = rgGame(rgImg,rFrac3);

subplot(2,3,5)
axis off equal
title '1 or 2?'
imagesc(box3)
pause(1)

% measures response time
tic

% collects subject input 
question = "Which box is 3 more similar to: enter 1 or 2";
response = input(question);

tElapsed = toc;

% covers samples with black box once viewing time is completed
subplot(2,3,5)
imagesc(zeros(xPx,yPx,3))
axis off 

% compare response to the correct answer and records subject answer
if abs(rFrac1 - rFrac3) < abs(rFrac2 - rFrac3)
    answer = 1;
else
    answer = 2;
end

% checks if subject responded correctly 
if response == answer
    logical = 1;
else
    logical = 0;
end

% determines probe location, distance of probe red fraction from the
% average redness of both samples

probeDiff = rFrac3 - mean([rFrac1,rFrac2]);

% records whether the subject chose red regardless of the correct answer
if rFrac1 > rFrac2 & answer == 1
    choice = 1;
elseif rFrac2 > rFrac1 & answer == 2
    choice = 1;
else
    choice = 0;
end

end