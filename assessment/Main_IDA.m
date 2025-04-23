% IDA for each building

%% parameters
IM_D_list = [0.1, 0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0, 5, 10]; % Unit: times of Sa(T1) with 475-year return period
SelfCenteringEnhancingFactor = 0.25;
OutputDir = 'IDA_results/IDA_results_SC025';
currentFolder = pwd;
OutputDir = fullfile(currentFolder,OutputDir);
[status,msg] = mkdir(OutputDir);
listing = dir('EQData\FEMA_P-695_far-field_ground_motions\MetaData_part10.txt');
EQMetaDataFile = fullfile(listing.folder,listing.name);
% parameters about classification of buildings
ignoredLabels={'id','Latitude','Longitude','YearBuilt','ReplacementCost','Footprint'};
IncrLabels = '{"PlanArea": 100}';

%% classify buildings
if exist('ReprBld.mat','file')
    load('ReprBld.mat');
else
    [Bld2ReprBld,ReprBld]=BldClassify(filename,ignoredLabels,IncrLabels);
    save('ReprBld.mat','Bld2ReprBld','ReprBld');
end

%% IDA
f = waitbar(0,'Please wait...');
for i=1:size(ReprBld,1) 
    waitbar(i/size(ReprBld,1),f,'Please wait...');
    NumofStories = ReprBld{i,'NumberOfStories'};
    FloorArea = ReprBld{i,'PlanArea'};
    StructuralType = ReprBld{i,'StructureType'}{1};
    DesignLevel = ReprBld{i,'DesignLevel'}{1};
    OutputCSVFile = fullfile(OutputDir, ...
        ['IDA_result_ReprBldID_',num2str(i-1),'.csv']);
    IDA(IM_D_list,NumofStories,FloorArea,StructuralType, ...
        DesignLevel, EQMetaDataFile, OutputCSVFile, ...
        SelfCenteringEnhancingFactor);
end
close(f);

