function [ title] = ObitosRelative(Table, colname, label)
    title = 'Percentage of obits from confirmed';
    
    obit_name = strrep(colname, 'confirmados', 'obitos');
    
    vals = 100 *Table.(obit_name)/Table.(colname);
    plot(Table.('data'),vals, 'x-');
    
    hold on;
end