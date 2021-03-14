function [ title] = Nominal(Table, colname)
title = 'Nominal Values';

plot(Table.('data'),Table.(colname), 'x-');
hold on;

end