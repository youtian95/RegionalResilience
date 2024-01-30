function [SiteID,SiteLong,SiteLat] = GenerateSiteFile_Grid( ...
    SiteFile,filename,SiteDist)
% 生成场地文件
%
% 输入：
% SiteFile - 文件名'SiteFile.txt'
% filename - building inventory file
% SiteDist - km
%
% 输出：

fp=fopen(SiteFile,'w');
fclose(fp);
SiteFile = which(SiteFile);

T = readtable(filename);
Maxlong = max(T{:,'Longitude'});
Minlong = min(T{:,'Longitude'});
Maxlat = max(T{:,'Latitude'});
Minlat = min(T{:,'Latitude'});

R = 6370;

SiteID = [];
SiteLong = [];
SiteLat = [];
ID = 0;
for long = Minlong:(SiteDist/cos(Minlat/180*pi)/R/pi*180):Maxlong
    for lat = Minlat:(SiteDist/R/pi*180):Maxlat
        period = 0.5;
        ID = ID +1 ;
        SiteID = [SiteID,ID];
        SiteLong = [SiteLong,long];
        SiteLat = [SiteLat,lat];
        elevation_km = 0;
        Vs30_mpers = 800;
        Z25_km = 999;
        writematrix([ID,long,lat,elevation_km,period, ...
            Vs30_mpers,Z25_km], ...
            SiteFile,'WriteMode','append','Delimiter',' ');
    end
end

end

