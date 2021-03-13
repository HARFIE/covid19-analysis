function SexPlots(Table, POP, columns, figNo)
addpath(genpath('SexPlots/'));
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
        plot(Table.('data'),100*Table.(columns{i})./POP.(label), 'x-');
        hold on;
        
        subplot(2,2,2);
        plot(Table.('data'),Table.(columns{i}), 'x-');
        hold on;
        
        subplot(2,1,2);
        title3 = ObitosRelative(Table, columns{i}, label);
        
        
        
        labels = [labels, string(label)];
        counter =counter +1;
    end
end
subplot(2,2,1)
legend(labels)
title('Relative')

subplot(2,2,2)
legend(labels)
title('Nominal')

subplot(2,1,2)
legend(labels)
title(title3)

suptitle('Sex Plots')
end