function FigName = VaccinesPlots(Table, columns, POP, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Vaccines Plots';

figure(figNo)
labels = [];
labels1 = [];
counter = 4;
countr = 0;
axes = []

%% Line Plots
for i = 1:width(Table)
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'doses') & (count( columns{i},'_') == 0) 
        
        label = string(columns{i});
        
        ax = subplot(1,2,1);
        
        if countr ==0
            axes = [axes, ax];
        end
        
        vals = 100 *  Table.(columns{i})./POP.('total');
        
        [title1, line] = Relative2(Table,columns{i}, POP, 'total');
        
        title1(end) = ' ';
        title1 = [title1, 'population '''];
        color = line.Color;
        
        % Extrapolation Variables X and Y (vq1)
        xq = [Table.('data')(1): days(1) : Table.('data')(end)+years(3)];
        yq = interp1(Table.('data'),vals,xq,'linear', 'extrap');
        
        % Get Markers position
        xinterc = Interception(xq, yq, xq, ones(size(xq))*70);
        
        % Plot Interception
        plot(xq, yq, '--', 'Color', color)
        
        % Plot Markers and Text
        if isa(xinterc, 'datetime')
            plot(xinterc, 70, 'o','Color',color,'MarkerSize',12,'LineWidth',2);
            text(xinterc,70+counter-2,string(xinterc),'VerticalAlignment',...
                'bottom','HorizontalAlignment','right',...
                'FontSize', 20, 'Color', color);
            counter = counter *  -1;
        end
        
        % Build label list for this axis
        labelq = sprintf('%s %s',label, 'extrapolation');
        labelp = sprintf('%s %s',label, '- Date achieving 70%');
        labels1 = [labels1, label, labelq, labelp];
        
        
        
        ax=subplot(1,2,2);
        if countr ==0
            axes = [axes, ax];
        end
        
        [title2, lineN] = Nominal2(Table,columns{i});
        
        % Ensure color coherence
        lineN.Color = color;

        % Build labels for this axis
        labels = [labels, label];
        
        countr = countr +1;
    end
end


%% Configure Axis 1
subplot(1,2,1);

% Plot Objective
objx= [xq(1),xq(end)];
plot(objx,[70,70], 'Color','green','LineStyle','--');


title1 = regexprep(title1,'[1-9]','');
title(title1);


ylim([0,100]);
labels1 = [labels1, 'Objective'];
lgd = legend(labels1', 'Location', 'best', 'FontSize', 14);

%% Configure Axis2
subplot(1,2,2);
title(title2);
lgd = legend(labels', 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;

%% Figure Title
suptitle(figName);

FigName = strrep(figName, ' ', '');
end