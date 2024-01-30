%% define EQ source and site info

M = 7; % EQ magitudes
ifmedian = 0; % use median intensity or not
N_sim = 500; % number of simulations
EQSourceFile = 'EQSource.txt';
seed = 2;
lon_0 = -122.136650; lat_0 = 37.727984;
W = 13;
length = 77;
RuptureNormal_x = 0.318; RuptureNormal_y = 0.214; 
RuptureNormal_z = 0.1395; % dip angle = 70
lambda = 0; % strike-slip
Fhw = 1;
Zhyp = 10;
region = 3;
nPCs = 10;
writecell({ifmedian;M;N_sim;seed;[lon_0,lat_0]; ...
    W;length;[RuptureNormal_x,RuptureNormal_y,RuptureNormal_z]; ...
    lambda;Fhw;Zhyp;region;nPCs},EQSourceFile,'Delimiter',' ');

SiteFile = 'SiteFile.txt';

% GenerateSiteFile(SiteFile,filename);

SiteDist = 0.1;
GenerateSiteFile_Grid(SiteFile,filename,SiteDist);
DataSiteFile = readmatrix(SiteFile);
SiteID = DataSiteFile(:,1);
SiteLong = DataSiteFile(:,2);
SiteLat = DataSiteFile(:,3);

%% IM field simulation
status = system(['IMSim ',EQSourceFile,' ',SiteFile]);
IM_sim = ReadIMSim(filename,SiteLong,SiteLat);
%% plot IMs for each building
i_sim = 1; % indicate the one that is plotted
plot_bld_IM_sim(filename,IM_sim,i_sim);
%% plot x-x IM
i_sim = 1;
plot_IM_X(0.5,SiteID,SiteLong,SiteLat,i_sim);

%% seismic losses simulation
N_sim = 500;
load('ReprBld.mat');
IDA_result_dir = 'IDA_results/IDA_results_SC025';
OutputDir = 'RegionalLossSimulations/RegionalLossSimulations_SC025_RES1';
currentFolder = pwd;
OutputDir = fullfile(currentFolder,OutputDir);
[status,msg] = mkdir(OutputDir);
BetaM = 0.25;
SimulateLossesBasedonIM_repr(Bld2ReprBld,ReprBld, ...
    IM_sim(:,1:(N_sim+1)),filename,IDA_result_dir,BetaM,OutputDir);
[AllLossSimResults,InvalidBldID]  = ReadLossSimResults(filename,OutputDir);

%% plot CDF of losses 
N_sim = 500;
samples = plot_cdf_regional(AllLossSimResults(1:N_sim,:), ...
    {'RepairTime','RecoveryTime','FunctionLossTime'}); 
% 'RepairCost_Total','RepairCost_Struct','RepairCost_NonStruct_DriftSen', 'RepairCost_NonStruct_AccelSen'
% or
% 'RepairTime','RecoveryTime','FunctionLossTime'

%% plot irreparable probability due to residual drift
DataDir = 'RegionalLossSimulations/RegionalLossSimulations_SC025_RES1';
P_irr_all = bld_irreparable_probability(filename,DataDir,0.01,0.3);
plot_bld_irreparable_probability(filename,P_irr_all);

%% compare CDFs of losses
N_sim = 500;
AllLosses = {'AllLossSimResults_SC0_RES1.mat', ...
    'AllLossSimResults_SC05_RES1.mat', ...
    'AllLossSimResults_SC075_RES1.mat'};
Median = plot_Compare_cdf_regional(AllLosses, ...
    {'RepairTime','RecoveryTime','FunctionLossTime'});

%%
exportgraphics(gca,'Figures/Recovery_SC05_RES1.pdf', ...
    'ContentType','vector');