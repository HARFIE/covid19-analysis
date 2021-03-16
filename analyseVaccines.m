%% Clean workspace
clc
clear
close all

addpath(genpath('matlabFuncs/'));
addpath(genpath('matlabFuncs/ExtraFuncs/'));
addpath(genpath('matlabFuncs/UserInterface/'));

%%  Read table
Table = readtable('datasets/vacinas.csv');

Table.('data') = datetime(Table.('data'),'InputFormat', 'dd-MM-yyyy');
Table = sortrows(Table, 'data');

columns = Table.Properties.VariableNames;

%% Initialize Variables
[POP, IDADES] = CreateConstants();

figs = [];
fignames = [];

%% Vaccines Plots
figNo = 1;
figName = 'Nofig';
figName = VaccinesPlots(Table, columns, POP, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];



%% User Interface

UI_Change_Xaxis(figs);

UI_Save_Figures(figs, fignames);

UI_Close_All();