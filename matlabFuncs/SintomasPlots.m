function FigName = Sintomas(Table,  columns, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Symptom Plots';

figure(figNo)
labels = [];


for i = 1:width(Table)
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'sintomas')
        
        label = string(strrep(strrep(columns{i}, 'sintomas_', ''), '_', ' '));
        
        subplot(1,1,1);
        title1 = Nominal(Table,columns{i});
        
        labels = [labels, label];
        
    end
end

subplot(1,1,1);

title(figName);
lgd = legend(labels', 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;

FigName = strrep(figName, ' ', '');
end