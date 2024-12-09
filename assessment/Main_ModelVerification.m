% ========================================================
% Prototype Steel MRF buildings (Gupta 1999) =============
% ========================================================
% 
% Seismic weight (kips-sec2/ft)：
% (1 kips = 4448.2216 N; 1 ft = 0.3048 m; 1 kips-sec2/ft = 14594 kg)
% 
% 3-story
% Roof:  70.90
% F2-F3: 65.53 
% Totoal: (70.90+65.53*2)*14594 = 2.95e+06 kg
% 
% 9-story
% Roof: 73.10
% F3-F9: 67.86
% F2: 69.04
% Totoal: (73.10+67.86*7+69.04)*14594 = 9.01e+06 kg
% 
% Plan area:
% 3MRF: 36.6*54.9 m2
% 9MRF: 45.75*45.75 m2
%
% ========================================================
% MDOF shear model =======================================
% ========================================================
% 
% Structural type
% 3MRF: S1L
% 9MRF: S1H
% 
% seismic design code:
% high-code. (LA and San Franscisco are in the same earhtquake zoon area)
%% global parameters
pylibDir = '../python小程序/MDOFModel';
Bldheight_MDOF9 = 3.6*9;
Bldheight_MDOF3 = 3.6*3;
Bldheight_MRF3 = 11.88;
Bldheight_MRF9 = 37.17;
Weight_MRF3 = 2*2.95e+06; % 2 frame
Weight_MRF9 = 2*9.01e+06; % 2 frame

%% Read MDOF pushover
[Fbase,RoofDrift] = ReadPushover(pylibDir,Bldheight_MDOF9);

%% plot and compare
MDOF9 = load('Pushover_MDOF9.mat');
MDOF3 = load('Pushover_MDOF3.mat');
SC3 = load('Pushover_SC3.mat');
SC9 = load('Pushover_SC9.mat');

Plot_ComparePushover_PrototypeVSMDOF([MDOF3,MDOF9],[SC3,SC9], ...
    [Weight_MRF3,Weight_MRF9]);

%%
exportgraphics(gca,'图/MDOFvsPrototype.pdf','ContentType','vector');

