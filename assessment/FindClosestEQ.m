function GMfile = FindClosestEQ(long,lat,N)
% find N closest station in 'EQData/SW4_2019', and generate
% *.at record file

datadir = 'D:\CityResilienceAndResilientStructure\EQData\SW4_2019\SW4';
T = readtable(fullfile(datadir,'EventGrid.csv'));

Dist_vec = [T{:,'Longitude'},T{:,'Latitude'}]-[long,lat];
Dist_vec(:,1) = Dist_vec(:,1).*cos(lat/180*pi);
Dist = vecnorm(Dist_vec');
[~,I] = sort(Dist);

GMfile_csv = T{I(1:N),'GP_file'};
GMfile_json = replace(GMfile_csv,'.csv','.json');
GMfile_at = replace(GMfile_csv,'.csv','.AT2');

for i=1:numel(GMfile_at)
    if ~isfile(fullfile(datadir,GMfile_at{i}))
        % generate *.at file
        C = fileread(fullfile(datadir,GMfile_json{i}));
        jsondata = jsondecode(C);
        GenerateEQATFile(jsondata.dT,numel(jsondata.data_x), ...
            jsondata.data_x./9.8,fullfile(datadir,GMfile_at{i}));
    end
end

GMfile = replace(GMfile_csv,'.csv','');
GMfile = replace(fullfile(datadir,GMfile),'\','/');

end

