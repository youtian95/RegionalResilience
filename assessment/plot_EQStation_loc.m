function plot_EQStation_loc(filename,EQGridFile)

addpath('..\matlab lib\WebMercator2LongLat');

plot_bld(filename,[0 0.4470 0.7410]);
xl = xlim;
scale = 1.8;
xl = (xl-(xl(2)+xl(1))/2).*scale+(xl(2)+xl(1))/2;
yl = ylim;
yl = (yl-(yl(2)+yl(1))/2).*scale+(yl(2)+yl(1))/2;


T_bld = readtable(filename,'Range','1:2');
[x0,y0] = LngLat2webMercator(T_bld.('Longitude')(1),T_bld.('Latitude')(1));
costheta = cos(T_bld.('Latitude')(1)/180*pi);


T = readtable(EQGridFile);
[x,y] = LngLat2webMercator(T.('Longitude'),T.('Latitude'));
x = (x - x0).*costheta;
y = (y - y0).*costheta;
hold on
scatter(x,y,20,'r','*','LineWidth',1);
xlim(xl);
ylim(yl);


end