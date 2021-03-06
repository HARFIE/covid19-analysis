function FigName = VaccinesPlots(Table, columns, POP, figNo)
addpath(genpath('SubFuncs/'));
figName = 'Vaccines Plots';

figure(figNo)
labels = [];
labels1 = [];
counter = 4;
countr = 0;
axes = [];
HAlign = ["right", "left"];

%% Line Plots
for i = 1:width(Table)
    if ~strcmp(columns{i}, 'data') & contains(columns{i}, 'doses') & (count( columns{i},'_') == 0) 
        
        label = string(columns{i});
        
        ax = subplot(2,2,1);
        
        if countr ==0
            axes = [axes, ax];
        end

        [title1, line] = Relative2(Table,columns{i}, POP, 'total');
        
        title1(end) = ' ';
        title1 = [title1, 'population '''];
        color = line.Color;
        
        %Moving Average
        vals = 100 *  Table.(columns{i})./POP.('total');
        

        
        
        % Extrapolation Variables X and Y (vq1)
        xq = [Table.('data')(end): days(1) : Table.('data')(end)+years(3)];
        yq = interp1(Table.('data'),vals,xq,'linear', 'extrap');
        
        % Get Markers position
        xinterc = Interception(xq, yq, xq, ones(size(xq))*70);
        
        % Plot Interception
        plot(xq, yq, '--', 'Color', color)
        
        
        % Build label list for this axis
        labelq = sprintf('%s %s',label, 'extrapolation');
        labels1 = [labels1, label, labelq];
        
        % Plot Markers and Text
        if isa(xinterc, 'datetime')
            plot(xinterc, 70, 'o','Color',color,'MarkerSize',12,'LineWidth',2);
            text(xinterc-counter*2,70+counter-2,string(xinterc),'VerticalAlignment',...
                'bottom','HorizontalAlignment',HAlign(mod(countr,2)+1),...
                'FontSize', 20, 'Color', color);
            counter = counter *  -1.75;
            
            % Build label list for this axis
            labelp = sprintf('%s %s',label, '- Date achieving 70%');
            labels1 = [labels1, labelp]
        end
        
        
        
        
        
        ax=subplot(2,2,2);
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

subplot(2,1,2)

vals = 100 *  Table.('doses1')./POP.('total');
n_nan = find(isnan(vals));
vals(n_nan)= mean([vals(min(n_nan)-1), vals(max(n_nan)+1)])

xq = [Table.('data')(end): days(1) : Table.('data')(end)+years(3)];
yq = interp1(Table.('data'),vals,xq,'linear', 'extrap');
vals_color = 'blue'

W = movmean(vals, 7);
Wq = interp1(Table.('data'),W,xq,'linear', 'extrap');
W_color = 'green'

Q = movmean(vals, 14);
Qq = interp1(Table.('data'),Q,xq,'linear', 'extrap');
Q_color = 'red'

M = movmean(vals, 30);
Mq = interp1(Table.('data'),M,xq,'linear', 'extrap');
M_color = [75 0 130 ]/256 %'purple'
        
vals_interc = Interception(xq, yq, xq, ones(size(xq))*70);
W_interc = Interception(xq, Wq, xq, ones(size(xq))*70);
Q_interc = Interception(xq, Qq, xq, ones(size(xq))*70);
M_interc = Interception(xq, Mq, xq, ones(size(xq))*70);

plot(Table.('data'), vals, 'Color', vals_color)
hold on
plot(Table.('data'), W, 'Color', W_color)
plot(Table.('data'), Q, 'Color', Q_color)
plot(Table.('data'), M, 'Color', M_color)

objx= [xq(1),xq(end)];
plot(objx,[70,70], 'Color','green','LineStyle','--');

plot(xq, yq, '--', 'Color', vals_color)
plot(xq, Wq, '--', 'Color', W_color)
plot(xq, Qq, '--', 'Color', Q_color)
plot(xq, Mq, '--', 'Color', M_color)


if isa(vals_interc, 'datetime')
    plot(vals_interc, 70, 'o','Color',vals_color,'MarkerSize',12,'LineWidth',2);
    text(vals_interc,70+counter-2,string(vals_interc),'VerticalAlignment',...
        'bottom','HorizontalAlignment','right',...
        'FontSize', 20, 'Color', vals_color);
    counter = counter *  -1;
end

if isa(W_interc, 'datetime')
    plot(W_interc, 70, 'o','Color',W_color,'MarkerSize',12,'LineWidth',2);
    text(W_interc,70+counter-2,string(W_interc),'VerticalAlignment',...
        'bottom','HorizontalAlignment','left',...
        'FontSize', 20, 'Color', W_color);
    counter = counter *  -1;
end
if isa(Q_interc, 'datetime')
    plot(Q_interc, 70, 'o','Color',Q_color,'MarkerSize',12,'LineWidth',2);
    text(Q_interc,70+counter-2,string(Q_interc),'VerticalAlignment',...
        'bottom','HorizontalAlignment','right',...
        'FontSize', 20, 'Color', Q_color);
    counter = counter *  -1.5;
end
if isa(M_interc, 'datetime')
    plot(M_interc, 70, 'o','Color',M_color,'MarkerSize',12,'LineWidth',2);
    text(M_interc,70+counter-2,string(M_interc),'VerticalAlignment',...
        'bottom','HorizontalAlignment','right',...
        'FontSize', 20, 'Color', M_color);
    counter = counter *  -1;
end
ylim([0,100])

labels_mean = ["Daily", "Weekly", "Bi-Monthly", "Monthly", "Objective" ]
%% Configure Axis 1
ax1 = subplot(2,2,1);

% Plot Objective

objx= [xq(1),xq(end)];
plot(objx,[70,70], 'Color',[0 0.7 0],'LineStyle','--');


title1 = regexprep(title1,'[1-9]','');
title(title1);


ylim([0,100]);
labels1 = [labels1, 'Objective'];
lgd = legend(labels1', 'Location', 'best', 'FontSize', 14);


%Alongate the axis
set(ax1, 'position', [0.13, 0.5838, 0.4, 0.3412])

%% Configure Axis2
subplot(2,2,2);
title(title2);
lgd = legend(labels', 'Location', 'best', 'FontSize', 14);
lgd.FontSize = 14;


%% Configure Axis2
subplot(2,1,2);
%title(title2);
lgd = legend(labels_mean, 'Location', 'best', 'FontSize', 14);

%% Figure Title
suptitle(figName);

FigName = strrep(figName, ' ', '');
end