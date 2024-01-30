% IDA for each building

%% parameters
IM_list = [0.1,0.2,0.4,0.6,0.8,1.0,1.5,2.0];
OutputDir = 'IDA_results/IDA_results_SC025';
currentFolder = pwd;
OutputDir = fullfile(currentFolder,OutputDir);
[status,msg] = mkdir(OutputDir);
listing = dir('EQData\FEMA_P-695_far-field_ground_motions\MetaData_part10.txt');
EQMetaDataFile = fullfile(listing.folder,listing.name);
SelfCenteringEnhancingFactor = 0.25;
% parameters about classification of buildings
ignoredLabels={'id','Latitude','Longitude','YearBuilt','ReplacementCost','Footprint'};
IncrLabels = '{\"PlanArea\": 100}';

%% classify buildings
[Bld2ReprBld,ReprBld]=BldClassify(filename,ignoredLabels,IncrLabels);
save('ReprBld.mat','Bld2ReprBld','ReprBld');

%% IDA
f = waitbar(0,'Please wait...');
for i=1:size(ReprBld,1) 
    waitbar(i/size(ReprBld,1),f,'Please wait...');
    NumofStories = ReprBld{i,'NumberOfStories'};
    FloorArea = ReprBld{i,'PlanArea'};
    StructuralType = ReprBld{i,'StructureType'}{1};
    OccupancyClass = ReprBld{i,'OccupancyClass'}{1};
    DesignLevel = ReprBld{i,'DesignLevel'}{1};
    OutputCSVFile = fullfile(OutputDir, ...
        ['IDA_result_ReprBldID_',num2str(i-1),'.csv']);
    IDA(IM_list,NumofStories,FloorArea,StructuralType, ...
        OccupancyClass, DesignLevel, EQMetaDataFile, OutputCSVFile, ...
        SelfCenteringEnhancingFactor)
end
close(f);

