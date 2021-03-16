function FigName = VaccinesVsActivePlots(TableV, columnsV, TableA, field,figNo)
addpath(genpath('SubFuncs/'));
figName = 'Vaccines Plots';

figure(figNo)
labels = [];


for i = 1:width(TableV)
    if ~strcmp(columnsV{i}, 'data') & contains(columnsV{i}, 'doses') & (count( columnsV{i},'_') == 0) 
        
        label = string(columnsV{i});
        
        Minimum = min([height(TableV),height(TableA) ])
        
        subplot(1,1,1);
        title1 = Relative(TableV(1:Minimum,:),columnsV{i}, TableA(1:Minimum, :), field);
        
        labels = [labels, label];
        
    end
end

subplot(1,1,1);

title(figName);
lgd = legend(labels', 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;



FigName = strrep(figName, ' ', '');
end