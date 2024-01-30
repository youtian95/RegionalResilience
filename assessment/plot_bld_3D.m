function plot_bld_3D(filename,LongRange,LatRange,facecolor)

addpath('..\matlab lib\WebMercator2LongLat');
T = readtable(filename);
T = T( T{:,'Latitude'}<LatRange(2) & T{:,'Latitude'}>LatRange(1)  ...
    & T{:,'Longitude'}<LongRange(2) & T{:,'Longitude'}>LongRange(1),:);


[x0,y0] = LngLat2webMercator(T.('Longitude')(1),T.('Latitude')(1));
costheta = cos(T.('Latitude')(1)/180*pi);
% f = waitbar(0,'Please wait...');
XY_all = {};
for i=1:height(T)
%     waitbar(i/height(T),f,'Loading your data');
    Footprint=jsondecode(T.('Footprint'){i});
    loc = Footprint.geometry.coordinates;
    [x,y] = LngLat2webMercator(loc(1,:,1),loc(1,:,2));
    x = (x - x0).*costheta;
    y = (y - y0).*costheta;
    for j=1:numel(XY_all)
        if size(XY_all{j},1)==numel(x)
            if all([x;y]'==XY_all{j},'all')
                continue
            end
        end
    end
    XY_all = [XY_all,{[x;y]'}];
    Height = T{i,'NumberOfStories'}*3;
    CreateBld([x;y]',Height,facecolor,1);
end
% close(f);
axis off

end

