function plot_bld_Repairtime(filename,Loss_results,Type)

% Type: RepairTime/RecoveryTime/FunctionLossTime

addpath('..\matlab lib\WebMercator2LongLat');
T = readtable(filename);

% green blue yellow red
facecolor = [0.4660 0.6740 0.1880; ... %green
    0.3010 0.7450 0.9330; ... % light blue
    0 0.4470 0.7410; ... %blue 
    0.9290 0.6940 0.1250; ... % yellow
    0.6350 0.0780 0.1840; ... % red
    0 0 0]; 

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
    RT = Loss_results{i}{1,Type};
    if RT<10
        C = facecolor(1,:); 
    elseif RT<50
        C = facecolor(2,:); 
    elseif RT<100
        C = facecolor(3,:); 
    elseif RT<300
        C = facecolor(4,:); 
    elseif RT<500
        C = facecolor(5,:); 
    else
        C = facecolor(6,:); 
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
label = {'0~10','10~50','50~100','100~300','300~500','500+'};
lgd = legend(hl,label);
lgd.Title.String = 'Repair time (days)';
lgd.Title.FontSize = 10;
lgd.Box = 'off';
lgd.FontName = 'Times New Roman';

end

