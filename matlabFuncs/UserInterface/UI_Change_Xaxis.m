function UI_Change_Xaxis(figs)
msg = 'Do you want to change the X-axis of any figure?(y/n)';
answer = input(msg, 's');
if lower(answer) == 'y'
    msg = 'which one?(number)';
    fig_i = input(msg);
    
    msg = 'Specify Xmin.(Example: March-2020)';
    Xmin = input(msg,'s');
    
    msg = 'Specify Xman.(Example: March-2021)';
    Xmax = input(msg,'s');
    
    limitX(figs(fig_i), Xmin, Xmax);
end
end