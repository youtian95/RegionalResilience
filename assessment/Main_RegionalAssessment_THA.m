%% plot EQ station locations
EQGridFile = 'EQData/SW4_2019/SW4/EventGrid.csv';
plot_EQStation_loc(filename,EQGridFile);

%% Regional loss assessment based on ground motion histories
% directly analyze each building
SCFactor = 0.5;
Loss_results = RegionalLossAssessBasedOnAccelHist(filename,SCFactor);

%% Regional loss assessment based on ground motion histories
% analyze representative buildings
ignoredLabels={'id','Latitude','Longitude','YearBuilt','ReplacementCost','Footprint'};
IncrLabels = '{\"PlanArea\": 100}';
SCFactor = 0;
Loss_results = RegionalLossAssessBasedOnAccelHist_repret( ...
    filename,ignoredLabels,IncrLabels,SCFactor,Bld2ReprBld,ReprBld);

%% Plot Bld loss assessment
plot_bld_DS(filename,Loss_results,'DS_Struct');
plot_bld_Repairtime(filename,Loss_results,'FunctionLossTime')
% exportgraphics(gca,'图/StoryBld.eps','ContentType','vector');

%% total losses
THALossSimResults = Loss_results{1}(1,4:end);
for i=2:numel(Loss_results)
    THALossSimResults{1,:} = THALossSimResults{1,:} + ...
        Loss_results{i}{1,4:end};
end