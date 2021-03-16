function FigName = HospitalizedPlots(Table, columns, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Hospitalized Plots';


figure(figNo)
labels = [];
labels3 = []
for i = 1:width(Table)
    
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'internados') 
        
        label = string(strrep(columns{i}, '_', ' '));
        
          
        subplot(2,2,1);
        title1 = Relative(Table, columns{i}, Table, 'ativos');
        title1 = strrep(title1, 'max population', 'active cases');
        
        subplot(2,2,2);
        title2 = Nominal(Table, columns{i});
        
        if (count( columns{i},'_') == 1)
            subplot(2,1,2);
            title3 = Relative(Table, columns{i}, Table, 'internados');
            title3 = strrep(title3, 'max population', 'Total hospitalized');
            
            labels3 = [labels3, label];
        end
        labels = [labels, label];
    end
end

subplot(2,2,1)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
title(title1)

subplot(2,2,2)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
title(title2)

subplot(2,1,2)
lgd = legend(labels3, 'Location', 'best', 'FontSize', 14);
title(title3)



suptitle(figName);
FigName = strrep(figName, ' ','');
end