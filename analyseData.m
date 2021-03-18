%% Clean workspace
clc
clear
close all

addpath(genpath('matlabFuncs/'));
addpath(genpath('matlabFuncs/ExtraFuncs/'));
addpath(genpath('matlabFuncs/UserInterface/'));

%%  Read table
Table = readtable('datasets/data.csv');
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
%figName = RegionPlots(Table, POP, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];

%% Sex Plots
figNo = 2;
figName = 'Nofig';
%figName = SexPlots(Table, POP, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% Age Plots
figNo = 3;
figName = 'Nofig';
%figName = AgePlots(Table, IDADES, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% Sintoms Plots
figNo=4;
figName = 'Nofig';
%figName = SintomasPlots(Table, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];
%% General Plots
figNo=5;
figName = 'Nofig';
%figName = GeneralPlots(Table, columns, figNo, POP);
figs = [figs, gcf];
fignames = [fignames, string(figName)];

%% Hospitalized Plots
figNo=6;
figName = 'Nofig';
%figName = HospitalizedPlots(Table, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];

%% Active Plots
figNo=5;
figName = 'Nofig';
figName = ActivePlots(Table, columns, figNo);
figs = [figs, gcf];
fignames = [fignames, string(figName)];


%% User Interface

UI_Change_Xaxis(figs);

UI_Save_Figures(figs, fignames);

UI_Close_All();