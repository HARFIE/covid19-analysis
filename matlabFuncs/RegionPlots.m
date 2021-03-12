function RegionPlots(Table, POP, columns, figNo)
addpath(genpath('RegionPlots/'));

figure(figNo)
labels = [];

counter = 0;
for i = 1:width(Table)
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'confirmados') & (count( columns{i},....
            '_') == 1) & ~contains(columns{i}, 'desconhecidos') & (counter <7)
        
        label = split(columns{i},'_');
                
        subplot(2,2,1);
        title1 = Relative(Table, columns{i}, POP, label);
        
        subplot(2,2,2);
        title2 = Nominal(Table, columns{i}, label);
        
        subplot(2,2,3)
        title3 = ObitosRelative(Table, columns{i}, label);
        
        subplot(2,2,4)
        title4 = RecuperadosRelative(Table, columns{i}, label);
        
        
        labels = [labels, string(label{2})];
        
        counter =counter +1;
    end
end
subplot(2,2,1);
title(title1)
legend(labels')
hold on;

subplot(2,2,2);
title(title2);
legend(labels');
hold on;

subplot(2,2,3);
title(title3);
legend(labels');
hold on;

subplot(2,2,4);
title(title4);
legend(labels');
hold on;


suptitle('Region Plots')

xlim([datetime('Jan-2020'), datetime('10-Mar-2021')])
end