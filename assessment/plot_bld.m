function plot_bld(filename,facecolor)

addpath('..\matlab lib\WebMercator2LongLat');
T = readtable(filename);

[x0,y0] = LngLat2webMercator(T.('Longitude')(1),T.('Latitude')(1));
costheta = cos(T.('Latitude')(1)/180*pi);
% f = waitbar(0,'Please wait...');
for i=1:height(T)
%     waitbar(i/height(T),f,'Loading your data');
    Footprint=jsondecode(T.('Footprint'){i});
    loc = Footprint.geometry.coordinates;
    [x,y] = LngLat2webMercator(loc(1,:,1),loc(1,:,2));
    x = (x - x0).*costheta;
    y = (y - y0).*costheta;
    patch(x,y,facecolor);
end
% close(f);
axis off

end

