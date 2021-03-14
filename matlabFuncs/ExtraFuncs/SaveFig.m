function SaveFig(FigHandle, FigName)
FigHandle.Position = get(0, 'Screensize');
figPath = [FigName, '.png'];

saveas(FigHandle, figPath,'png');

msg = sprintf('%s saved', string(figPath));
disp(msg)
    
end