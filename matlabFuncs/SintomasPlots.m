function Sintomas(Table,  columns, figNo)

figure(figNo)
labels = [];


for i = 1:width(Table)
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'sintomas')
        
        label = split(columns{i},'_');
        label = string(label{2});
        
        subplot(1,1,1);
        plot(Table.('data'), Table.(columns{i}), 'x-');
        hold on;
        
        labels = [labels, label];
        
    end
end

subplot(1,1,1);
title('Sintomas');
legend(labels');

end