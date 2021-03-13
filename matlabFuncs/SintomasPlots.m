function Sintomas(Table,  columns, figNo)

figure(figNo)
labels = [];


for i = 1:width(Table)
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'sintomas')
        
        label = string(strrep(strrep(columns{i}, 'sintomas_', ''), '_', ' '))
        
        
        subplot(1,1,1);
        plot(Table.('data'), Table.(columns{i}), 'x-');
        hold on;
        
        labels = [labels, label];
        
    end
end

subplot(1,1,1);
title('Sintomas');
lgd = legend(labels');
lgd.FontSize = 14;

end