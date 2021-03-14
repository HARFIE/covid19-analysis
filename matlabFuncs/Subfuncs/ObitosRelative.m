function [ title] = ObitosRelative(Table, colname)
    title = 'Percentage of Deaths from confirmed cases';
    
    obit_name = strrep(colname, 'confirmados', 'obitos');
    
    vals = 100 *Table.(obit_name)./Table.(colname);
    plot(Table.('data'),vals, 'x-');
    
    hold on;
end