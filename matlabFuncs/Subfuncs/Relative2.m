function [title, line]=Relative2(Table, colname, POP, popField)
title = ['Percentage of ''',strrep(colname,'_', ' '),''' from ''', popField, ''''];

vals = 100 *Table.(colname)./POP.(popField);
line = plot(Table.('data'),vals, 'x-');

hold on;
end