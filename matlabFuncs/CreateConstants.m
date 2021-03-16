function [POP, IDADES]=CreateConstants()


% 2011 Census
POP_NORTE = 3818722;
POP_LVT = 2808414;
POP_CENTRO = 2348453;
POP_ALENTEJO = 776339;
POP_ALGARVE = 395208;
POP_MADEIRA = 245012;
POP_ACORES = 244006;
POP_TOTAL = 10636154;

POP_M = 5042000;
POP_F = 5515600;


IDADES = table(492373, 552682, 620270, 817209, 797441, 731668, 634892, 572510, 296533,....
    515361, 577163, 617871, 781041, 745951, 668343, 551550, 404891, 184430,....
    'VariableNames',...
    {'f_0_9','f_10_19','f_20_29', 'f_30_39', 'f_40_49', 'f_50_59', 'f_60_69', 'f_70_79', 'f_80_plus', ...
    'm_0_9','m_10_19','m_20_29', 'm_30_39', 'm_40_49', 'm_50_59', 'm_60_69', 'm_70_79', 'm_80_plus'});

POP = table(POP_NORTE, POP_LVT, POP_CENTRO, POP_ALENTEJO, POP_ALGARVE, POP_MADEIRA, POP_ACORES, POP_TOTAL, POP_M, POP_F, 'VariableNames',...
    {'arsnorte','arscentro','arslvt', 'arsalentejo', 'arsalgarve', 'acores', 'madeira', 'total', 'masculino', 'feminino'});

% Alternatively the matrices can be loaded instead of created:
%load('myMatrices_Census2011/IDADES.mat')
%load('myMatrices_Census2011/POP.mat')

end