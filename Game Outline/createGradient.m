function [gradient] = createGradient(xPx,yPx)

% initialize red
gradient = zeros(xPx, yPx, 3); 
gradient(:, :, 2) = 1; % all red initially

% first column is all red, rest needs to change
for yPx = 2:yPx
    % green pixels increases by 1 after the first
    rNum = yPx - 1;
    
    % Generate a random permutation of row indices
    randIdx = randperm(xPx);
    
    % select the green indexes
    rIdx = randIdx(1:rNum);
    
    % set green ON
    gradient(rIdx, yPx, 1) = 1;
    
    gradient(rIdx, yPx, 2) = 0;
end


imagesc(gradient)
line([20,20],[0,100],'LineWidth',2,'Color','white');
line([60,60],[0,100],'LineWidth',2,'Color','white');
line([50,50],[0,100],'LineWidth',2,'Color','white');

xticks([20,50,60])
yticks([])
xticklabels({'Sample 1', 'Probe', 'Sample 2'})

title('Sample-Probe Visual')
axes = gca;
axes.XTickLabelRotation = 45;
axes.TickDir = 'out';

set(gca, 'FontSize', 18)

print(1,'gradient.svg','-dsvg')

end