%% plot post-earthquake recovery
SimLossDir = 'RegionalLossSimulations/RegionalLossSimulations_SC075_RES1';
N_sim = 500;
beta = 0.2;
[RemainingRepairTime,RemainingFunctionalRepairTime] = ...
    ReadRecoveryData(filename,SimLossDir,N_sim);

%%
plot_functionalLoss_recovery(RemainingFunctionalRepairTime,beta);
plot_compare_recovery( ...
    {'RemainingRepairTime_SC0_RES1.mat', ...
    'RemainingRepairTime_SC05_RES1.mat', ...
    'RemainingRepairTime_SC075_RES1.mat'},beta);


%% simulate post-earthquake recovery considering cordons
% ** not finshied
SimLossDir = 'RegionalLossSimulations/RegionalLossSimulations_SC05_RES0';
RadiusFactor = 1.5;
HeightLowerBound = 20;
TimeSim = 1000;
DaysStep = 25;
N_sim = 30;
[FunctionRecovery,DSState] = SimulateRecovery( ...
    filename,SimLossDir,RadiusFactor,HeightLowerBound,TimeSim, ...
    RemainingRepairTime,RemainingFunctionalRepairTime,DaysStep,N_sim);
plot_function_recovery(FunctionRecovery,DaysStep);
