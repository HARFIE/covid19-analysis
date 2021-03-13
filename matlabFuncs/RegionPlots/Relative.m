function [title]=Relative(Table, colname, POP, label)
title = 'Relative';

vals = 100 *Table.(colname)./POP.(label{2});
plot(Table.('data'),vals, 'x-');

hold on;
end