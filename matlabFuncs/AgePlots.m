function FigName = AgePlots(Table, IDADES, columns, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Age Plots';

figure(figNo)
labels = [];
counter = 0;
vals = [];
for i = 1:width(Table)
    
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'confirmados') & (count( columns{i},....
            '_') == 3)
        
        label = split(columns{i},'_');
        label = [label{4},'_',label{2},'_',label{3}];
        labels = [labels, string(label)];
        counter =counter +1;
        
        val = 100*Table.(columns{i})/IDADES.(label);
        vals = [vals,val(length(val))];
    end
end
counter = 0;

aux_table = table(labels',vals', 'VariableName', {'labels', 'vals'});
aux_table = sortrows(aux_table, 'vals', 'descend');
labels = [];
for i = 1:width(Table)
    
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'confirmados') & (count( columns{i},....
            '_') == 3)
        label = split(columns{i},'_');
        field = [label{4},'_',label{2},'_',label{3}];
        
        label = [label{4},' ',label{2},'-',label{3}];
        label = string(label);
                
        for j = 1:6
            
            if contains(aux_table.('labels'){j}, string(field))
                
                subplot(2,2,1);
                title1 = Relative(Table, columns{i}, IDADES, field);
                
                subplot(2,2,2);
                title2 = Nominal(Table, columns{i});
                
                subplot(2,1,2);
                title3 = ObitosRelative(Table, columns{i});
                
                labels = [labels, label];
            end
        end
        
        counter =counter +1;
    end
end
subplot(2,2,1)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
title(title1)

subplot(2,2,2)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
title(title2)

subplot(2,1,2)
lgd = legend(labels, 'Location', 'best', 'FontSize', 14);
title(title3);


suptitle(figName);

FigName = strrep(figName, ' ', '');
end