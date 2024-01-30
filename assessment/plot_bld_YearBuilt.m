function plot_bld_YearBuilt(filename)

addpath('..\matlab lib\WebMercator2LongLat');
T = readtable(filename);

% yellow  blue  green 
facecolor = [0.9290 0.6940 0.1250; 0 0.4470 0.7410; ...
    0.4660 0.6740 0.1880];

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
    
    YearBuilt = T{i,'YearBuilt'};
    if YearBuilt<1940
        C = facecolor(1,:); % yellow
    elseif YearBuilt<1973
        C = facecolor(2,:); % blue
    elseif YearBuilt>=1973
        C = facecolor(3,:); % green
    end
    patch(x,y,C);
end
% close(f);
axis off

% Placeholder patches
hold on;
for il = 1:size(facecolor,1)
    hl(il) = patch(NaN, NaN, facecolor(il,:));
end
label = {'<1940','1940~1973','\geq1973'};
lgd = legend(hl,label);
lgd.Title.String = 'Year built';
lgd.Title.FontSize = 10;
lgd.Box = 'off';
lgd.FontName = 'Times New Roman';

end

