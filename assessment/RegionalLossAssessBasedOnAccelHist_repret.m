function Loss_results = RegionalLossAssessBasedOnAccelHist_repret( ...
    filename,ignoredLabels,IncrLabels,SCFactor, ...
    Bld2ReprBld,ReprBld)

% filename = 'E:\CityResilienceAndResilientStructure\BuildingData\SanFrancisco_buildings_partial.csv';
% ignoredLabels={'id','Latitude','Longitude','YearBuilt','ReplacementCost','Footprint'};
% IncrLabels = '{\"PlanArea\": 100}';


if nargin <= 4
    [Bld2ReprBld,ReprBld]=BldClassify(filename,ignoredLabels,IncrLabels);
end

ReprAnalysis = struct('ReprID',{},'GMfile',{},'T_loss_repr',{});

T = readtable(filename);
Loss_results = cell(1,size(T,1));
for i=1:size(T,1)
    fprintf('%u Analysis ---------------\n',i);
    Scaling = 1;
    GMfile = FindClosestEQ(T{i,'Longitude'},T{i,'Latitude'},1);
    ReprID = Bld2ReprBld{:,'Representative Buildings index'}( ...
        Bld2ReprBld{:,'Original Buildings index'}==(i-1));
    if any((ReprID==[ReprAnalysis.ReprID])& ...
            (strcmp(GMfile{1},{ReprAnalysis.GMfile})))
        ind = (ReprID==[ReprAnalysis.ReprID])& ...
            (strcmp(GMfile{1},{ReprAnalysis.GMfile}));
        T_loss = ReprAnalysis(ind).T_loss_repr;
    else
        T_loss = EQDynamicAnalysis(ReprBld(ReprID+1,:), ...
            GMfile{1},Scaling,SCFactor);
        ReprAnalysis = [ReprAnalysis, ...
            struct('ReprID',ReprID,'GMfile',GMfile{1},'T_loss_repr',T_loss)];
    end
    
    Loss_results(i) = {T_loss};
    fprintf('\n');
end

end

