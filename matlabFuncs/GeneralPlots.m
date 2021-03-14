function FigName = GeneralPlots(Table, columns, figNo, POP)
addpath(genpath('SubFuncs/'));
figName = 'General Plots';

figure(figNo)
labels = [];
counter = 0;
for i = 1:width(Table)
   if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'confirmados') & (count( columns{i},....
           '_') == 0)

       label= columns{i};
       field = 'total';
       
        subplot(2,2,1);
        title1 = Relative(Table, columns{i}, POP, field);
        
        subplot(2,2,2);
        title2 = Nominal(Table, columns{i});
        
        subplot(2,2,3);
        title3 = ObitosRelative(Table, columns{i});
        
        subplot(2,2,4);
        title4 = RecuperadosRelative(Table, columns{i});
        
        
        labels = [labels, string(label)];
        counter =counter +1;
    end
end

subplot(2,2,1)
title(title1)

subplot(2,2,2)
title(title2)

subplot(2,2,3)
title(title3)

subplot(2,2,4)
title(title4)


suptitle(figName)
FigName = strrep(figName, ' ', '');
end