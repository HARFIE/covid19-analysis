function [title]=Relative(Table, colname, POP, popField)
title = 'Relative to Max population';

vals = 100 *Table.(colname)./POP.(popField);
plot(Table.('data'),vals, 'x-');

hold on;
end