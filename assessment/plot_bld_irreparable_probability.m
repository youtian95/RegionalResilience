function plot_bld_irreparable_probability(filename,P_irr_all)

addpath('..\matlab lib\WebMercator2LongLat');
T = readtable(filename);

% green blue  yellow  ...
Color_vec = [0.4660 0.6740 0.1880; 0 0.4470 0.7410; ...
    0.9290 0.6940 0.1250; 0.8500 0.3250 0.0980; ...
    0.4940 0.1840 0.5560; 0.6350 0.0780 0.1840];
facecolor = Color_vec(1:4,:);

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
    
    P_irr = P_irr_all(i);
    
    if P_irr<0.1
        C = facecolor(1,:); 
    elseif P_irr<0.3
        C = facecolor(2,:); 
    elseif P_irr<0.5
        C = facecolor(3,:); 
    else
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
label = {'<0.1','0.1~0.3','0.3~0.5','\geq0.5'};
lgd = legend(hl,label);
lgd.Title.String = 'Irreparable probability';
lgd.Title.FontSize = 10;
lgd.Box = 'off';
lgd.FontName = 'Times New Roman';

end

