%% Clean workspace
clc
clear
close all

addpath(genpath('matlabFuncs/'));
addpath(genpath('matlabFuncs/XLIM/'));

%%  Read table
Table = readtable('data.csv');
Table.('data') = datetime(Table.('data'),'InputFormat', 'dd-MM-yyyy');

Table.('data_dados') = datetime(Table.('data_dados'),'InputFormat', 'dd-MM-yyyy hh:mm');
Table = sortrows(Table, 'data');

columns = Table.Properties.VariableNames;

%% Constants
[POP, IDADES] = CreateConstants()

figs = []
%% Region Plots
figNo = 1;
RegionPlots(Table, POP, columns, figNo);
figs = [figs, gcf]


%% Sex Plots
figNo = 2;
SexPlots(Table, POP, columns, figNo);
figs = [figs, gcf]
%% Age Plots
figNo = 3;
%AgePlots(Table, IDADES, columns, figNo);
figs = [figs, gcf]
%% Sintoms Plots
figNo=4;
%SintomasPlots(Table, columns, figNo)
figs = [figs, gcf]
