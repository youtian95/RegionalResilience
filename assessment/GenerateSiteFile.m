function GenerateSiteFile(SiteFile,filename)
% 生成场地文件
%
% 输入：
% SiteFile - 文件名'SiteFile.txt'
% filename - building inventory file
%
% 输出：

fp=fopen(SiteFile,'w');
fclose(fp);
SiteFile = which(SiteFile);

T = readtable(filename);

current_folder = cd;

cd('..\python lib\MDOFModel');
insert(py.sys.path,int32(0),'');

f = waitbar(0,'Please wait...');
for row=1:size(T,1)
    waitbar(row/size(T,1),f,'Please wait...');
    bld = py.MDOF_LU.MDOF_LU(py.int(T{row,'NumberOfStories'}), ...
        py.float(T{row,'PlanArea'}), py.str(T{row,'StructureType'}{1}));
    bld.set_DesignLevel(py.str(T{row,'DesignLevel'}{1}));
    period1 = bld.T1;
    ID = T{row,'id'};
    lon = T{row,'Longitude'};
    lat = T{row,'Latitude'};
    elevation_km = 0;
    Vs30_mpers = 500;
    Z25_km = 999;
    writematrix([ID,lon,lat,elevation_km,period1,Vs30_mpers,Z25_km], ...
       SiteFile,'WriteMode','append','Delimiter',' ');
end
close(f);

cd(current_folder);

end

