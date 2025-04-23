% Global Parameters for all main.m files
filename = 'BuildingData/SanFrancisco_buildings_Test10.csv';
listing = dir(filename);
filename = fullfile(listing.folder,listing.name);
global MatlabLibPath PythonLibPath
MatlabLibPath = '../matlab lib';
PythonLibPath = '../python lib';
addpath(fullfile('./src'));
% set your python environment
pyenv(Version="F:\anaconda3\python.exe");
if count(py.sys.path,fullfile(pwd,PythonLibPath)) == 0
    insert(py.sys.path,int32(0),fullfile(pwd,PythonLibPath));
end


%% 
% if seismic design level is missing, run this section to
% add seismic design level column
T = readtable(filename);
if ~ismember('DesignLevel', T.Properties.VariableNames)
    T=readtable(filename);
    SDL = cell(size(T,1),1);
    SDL(T.YearBuilt<1940)={'pre-code'}; 
    SDL(T.YearBuilt>=1940)={'moderate-code'}; 
    SDL(T.YearBuilt>=1973)={'high-code'}; 
    T.DesignLevel = SDL;
    writetable(T,filename);
end