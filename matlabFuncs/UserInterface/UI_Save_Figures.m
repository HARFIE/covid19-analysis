function UI_Save_Figures(figs, fignames)

msg = 'Do you want to save all figures?(y/n)';
answer = input(msg, 's');
if lower(answer) == 'y'
    for fig_i = 1:length(figs)
        if ~strcmp(fignames(fig_i), "Nofig")
            figPath = ['Figs/',char(fignames(fig_i))];
            SaveFig(figs(fig_i), figPath);
        end
    end
elseif lower(answer) == 'n'
    msg = 'Do you want to save any figures in specific?(y/n)';
    answer = input(msg, 's');
    if lower(answer) == 'y'
        
        msg = 'Which one?(integer)';
        fig_i = input(msg);
        
        if ~strcmp(fignames(fig_i), "Nofig")
            figPath = ['Figs/',char(fignames(fig_i))];
            SaveFig(figs(fig_i), figPath);
        end
        
    end
end

end
