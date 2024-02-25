function [box] = rgGame(rgImg,rFrac)
% inputs: figure, red fraction of figure
% output: the colored figure, with a red percentage of rFrac

% initalizes a 3D matrix of zeros of a certain dimention
xPx = size(rgImg,2);
yPx = size(rgImg,1);

% initalizes each color layer of the image as zeros
r = zeros(yPx,xPx);
g = zeros(yPx,xPx);
b = zeros(yPx,xPx);

% stores each color layer within the matrix
rgImg(:,:,1) = r;
rgImg(:,:,2) = g;
rgImg(:,:,3) = b;

% creates a matrix of random numbers between 0 and 1 in the size of the
% matrix
randPx = rand(yPx,xPx);

% checks if the random number in the maxtrix is less than the percentage to
% be red
rIdx = randPx < rFrac;

% if the random number is less than the percent red (probability of numbers
% within a matrix being less than the red percentage is equal to the red
% percentage), it becomes 1 in the red layer, creating a red square
r(rIdx) = 1;

% anything that is not red is green
g(~rIdx) = 1;

% places these updated layers into the 3D matrix
rgImg(:,:,1) = r;
rgImg(:,:,2) = g;
rgImg(:,:,3) = b;

% names output variable
box = rgImg;

end