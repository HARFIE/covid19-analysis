function [title]=Relative(Table, colname, POP, popField)
title = ['Percentage of ''',strrep(colname,'_', ' '),''' from ''', popField, ''''];

vals = 100 *Table.(colname)./POP.(popField);
plot(Table.('data'),vals, 'x-');

hold on;
end