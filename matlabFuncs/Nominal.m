function [ title] = Nominal(Table, colname, label)
title = 'Nominal';

plot(Table.('data'),Table.(colname), 'x-');
hold on;

end