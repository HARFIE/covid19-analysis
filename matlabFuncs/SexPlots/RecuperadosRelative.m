function [ title] = RecuperadosRelative(Table, colname, label)
    title = 'Permilage of cured from confirmed';
    
    recup_name = strrep(colname, 'confirmados', 'recuperados');
    
    vals = 1000 *Table.(recup_name)./Table.(colname);
    plot(Table.('data'),vals, 'x-');
    
    hold on;
end