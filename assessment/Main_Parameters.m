% Global Parameters for all main.m files
filename = 'BuildingData/SanFrancisco_buildings_Test10.csv';
listing = dir(filename);
filename = fullfile(listing.folder,listing.name);



%% 
% if seismic design level is missing, run this section to
% add seismic design level column
T=readtable(filename);
SDL = cell(size(T,1),1);
SDL(T.YearBuilt<1940)={'pre-code'}; 
SDL(T.YearBuilt>=1940)={'moderate-code'}; 
SDL(T.YearBuilt>=1973)={'high-code'}; 
T.DesignLevel = SDL;
writetable(T,filename);