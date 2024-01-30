function [Bld2ReprBld,ReprBld] = BldClassify(BldDirtFile,ignoredLabels,IncrLabels)

% BldDirtFile = 'E:\CityResilienceAndResilientStructure\BuildingData\SanFrancisco_buildings_partial.csv'
% ignoredLabels={'id','Latitude','Longitude','YearBuilt','ReplacementCost','Footprint'}
% IncrLabels = '{\"PlanArea\": 100}'

current_folder = cd;
cd('..\python lib\BldCluster');

command = ['python Tool.py --BldDirtFile ',BldDirtFile, ...
    ' --IgnoredLabels ', cell2mat(append(ignoredLabels,' ')), ...
    ' --IncrLabels "',IncrLabels,'"'];
status = system(command);

Bld2ReprBld = readtable('Bld2ReprBld.csv','Range',[1 2], ...
    'PreserveVariableNames',true);
ReprBld = readtable('Representative Buildings.csv','Range',[1 2], ...
    'PreserveVariableNames',true);

cd(current_folder);

end

