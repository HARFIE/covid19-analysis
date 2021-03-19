function FigName = ActivePlots(Table, columns, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Active Plots';

figure(figNo)
labels = [];
counter = 2;

label= 'ativos';


subplot(2,2,1);
title1 = Nominal(Table, label);


subplot(2,2,2);
title2 = 'Daily Active Cases';
d_Activos = diff(Table.(label));
d_Activos = [0 ; d_Activos];

plot(Table.('data'), d_Activos,'x', 'Color', 'red', 'LineWidth', 2); 
hold on;
plot(Table.('data'), smooth(d_Activos,7), 'Color', 'green', 'LineWidth', 4);
labels2 = ['Day Difference', 'Smooth Weekly Diff'];

subplot(2,1,2)

title3 = 'Active cases prevision'
line = plot(Table.('data'), Table.('ativos'), 'LineWidth', 2);
hold on;

xq = [Table.('data')(1): days(1) : Table.('data')(end)+days(30)];
vals = Table.('ativos');
yq = interp1(Table.('data'),vals,xq,'linear', 'extrap');
plot(xq, yq, '--', 'Color', line.Color);

plot([xq(1),xq(end)], [0,0], '--','Color', 'green');

xinterc = Interception(xq(100:end), yq(100:end), xq(100:end), ones(size(xq(100:end)))*0)
if isa(xinterc, 'datetime')
    plot(xinterc, 0, 'o','Color','red','MarkerSize',12,'LineWidth',2);
    text(xinterc+days(4),0,string(xinterc),'VerticalAlignment',...
        'bottom','HorizontalAlignment','left',...
        'FontSize', 20, 'Color', 'red');
    counter = counter *  -1;
end

labels3 = [ string(label), "Ative cases estimation", 'Objective'];

subplot(2,2,1)
title(title1)

subplot(2,2,2)
title(title2)
lgd = legend(labels2, 'Location', 'best')

subplot(2,1,2)
title(title3)
lgd = legend(labels3, 'Location', 'best')


suptitle(figName)
FigName = strrep(figName, ' ', '');
end