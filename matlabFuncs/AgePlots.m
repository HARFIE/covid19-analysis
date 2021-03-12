function AgePlots(Table, IDADES, columns, figNo)
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
        label = [label{4},'_',label{2},'_',label{3}];
        label = string(label);
        
        for j = 1:6
            
            if contains(aux_table.('labels'){j}, label)
                
                subplot(1,2,1);
                
                labels = [labels, label];
                plot(Table.('data'),100*Table.(columns{i})/IDADES.(char(label)), 'x-');
                hold on;
                
                subplot(1,2,2);
                plot(Table.('data'),Table.(columns{i}), 'x-');
                hold on;
                
            end
        end
        
        counter =counter +1;
    end
end
subplot(1,2,1)
legend(labels)
title('Relative')

subplot(1,2,2)
legend(labels)
title('Nominal')

suptitle('Age Plots')
end