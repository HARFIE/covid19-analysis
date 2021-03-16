function [ title, line] = Nominal2(Table, colname)
title = 'Nominal Values';

line = plot(Table.('data'),Table.(colname), 'x-');
hold on;

end