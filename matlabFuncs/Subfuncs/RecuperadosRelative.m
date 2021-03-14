function [ title] = RecuperadosRelative(Table, colname)
    title = 'Percentage of cured from confirmed cases';
    
    recup_name = strrep(colname, 'confirmados', 'recuperados');
    
    vals = 100 *Table.(recup_name)./Table.(colname);
    plot(Table.('data'),vals, 'x-');
    
    hold on;
end