function plot_bld_IM_sim(filename,IM_sim,i_sim)

addpath('..\matlab lib\WebMercator2LongLat');
T = readtable(filename);

% green blue yellow red
facecolor = [0.4660 0.6740 0.1880; 0 0.4470 0.7410; ...
    0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840];

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
    
    IM = IM_sim(i,i_sim+1);
    if IM<0.1
        C = facecolor(1,:); 
    elseif IM<0.3
        C = facecolor(2,:); 
    elseif IM<0.6
        C = facecolor(3,:); 
    elseif IM>=0.6
        C = facecolor(4,:); 
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
label = {'<0.1 g','0.1~0.3 g','0.3~0.6 g', '>0.6 g'};
lgd = legend(hl,label,'Location','eastoutside');
lgd.Title.String = 'Spectral Acceleration';
lgd.Title.FontSize = 10;
lgd.Box = 'off';
lgd.FontName = 'Times New Roman';

end

