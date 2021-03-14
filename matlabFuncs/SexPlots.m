function FigName = SexPlots(Table, POP, columns, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Sex Plots';

figure(figNo)
labels = [];
counter = 0;
for i = 1:width(Table)
   if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'confirmados') & (count( columns{i},....
           '_') == 1) & (endsWith(columns{i}, '_m') | endsWith(columns{i}, '_f') )& (counter <7)
        
        if endsWith(columns{i}, 'm')
            label = 'masculino';
        elseif endsWith(columns{i}, 'f')
            label = 'feminino';
        end
        
        subplot(2,2,1);
        title1 = Relative(Table, columns{i}, POP, label);
        
        subplot(2,2,2);
        title2 = Nominal(Table, columns{i});
        
        subplot(2,1,2);
        title3 = ObitosRelative(Table, columns{i});

        labels = [labels, string(label)];
        counter =counter +1;
    end
end
subplot(2,2,1)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;
title(title1)

subplot(2,2,2)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;
title(title2)

subplot(2,1,2)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;
title(title3)

suptitle(figName)
FigName = strrep(figName, ' ', '');
end