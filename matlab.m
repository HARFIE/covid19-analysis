%% Clean workspace
clc
clear
close all

addpath(genpath('matlabFuncs/'));
addpath(genpath('matlabFuncs/ExtraFuncs/'));

%%  Read table
Table = readtable('data.csv');
Table.('data') = datetime(Table.('data'),'InputFormat', 'dd-MM-yyyy');

Table.('data_dados') = datetime(Table.('data_dados'),'InputFormat', 'dd-MM-yyyy hh:mm');
Table = sortrows(Table, 'data');

columns = Table.Properties.VariableNames;

%% Constants
[POP, IDADES] = CreateConstants();

figs = [];
fignames = [];

%% Region Plots
figNo = 1;
figName = 'Nofig';
figName = RegionPlots(Table, POP, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];

%% Sex Plots
figNo = 2;
figName = 'Nofig';
figName = SexPlots(Table, POP, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% Age Plots
figNo = 3;
figName = 'Nofig';
figName = AgePlots(Table, IDADES, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% Sintoms Plots
figNo=4;
figName = 'Nofig';
figName = SintomasPlots(Table, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% General Plots
figNo=5;
figName = 'Nofig';
figName = GeneralPlots(Table, columns, figNo, POP);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% Save Plots

msg = 'Do you want to save all figures?(y/n)';
answer = input(msg, 's');
if lower(answer) == 'y'
    

    for fig_i = 1:length(figs)
        figPath = ['Figs/',char(fignames(fig_i))];
        
        SaveFig(figs(fig_i), figPath);
    end
end

%% Close Figs
msg = 'Do you want to close all figures?(y/n)';
answer = input(msg, 's');
if lower(answer) == 'y'
    close all
end
