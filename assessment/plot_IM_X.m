function plot_IM_X(Period,SiteID,SiteLong,SiteLat,i_sim)

current_folder = cd;

addpath('..\matlab lib\WebMercator2LongLat');

if rem(Period,1)==0
    sufix = '..txt';
else
    sufix = '.txt';
end

IMsimprefix = 'IM sim with period ';
IMMedianPlusBRprefix = 'IM median plus Between-event residual with period ';
IMMedianprefix = 'IM median with period ';

IMsimT = readmatrix(fullfile(current_folder, ...
    [IMsimprefix,num2str(Period,'%g'),sufix]));
IMMedianPlusBR = readmatrix(fullfile(current_folder, ...
    [IMMedianPlusBRprefix,num2str(Period,'%g'),sufix]));
IMMedian = readmatrix(fullfile(current_folder, ...
    [IMMedianprefix,num2str(Period,'%g'),sufix]));

USiteLong = unique(SiteLong);
USiteLat = unique(SiteLat);
MidLat = USiteLat(ceil(numel(USiteLat)/2));

locID = zeros(size(USiteLong));
for i=1:numel(USiteLong)
    locID(i) = SiteID(SiteLong==USiteLong(i) & SiteLat==MidLat);
end
Y = zeros(size(USiteLong));
Y_median = zeros(size(USiteLong));
Y_MedianPlusBR = zeros(size(USiteLong));
for i=1:numel(USiteLong)
    Y(i) = IMsimT(IMsimT(:,1)==locID(i),i_sim+1);
    Y_median(i) = IMMedian(IMMedian(:,1)==locID(i),2);
    Y_MedianPlusBR(i) = IMMedianPlusBR(IMMedianPlusBR(:,1)==locID(i),i_sim+1);
end

X = LngLat_Small_Distance(USiteLong(1),MidLat, ...
    USiteLong,repmat(MidLat,size(USiteLong)));
X = X./1000;

X_line = min(X):0.01:max(X);

% scatter(X,Y,25,'filled')
semilogy(X_line,interp1(X,Y_median,X_line,'pchip'), ...
    'LineWidth',2.0,'Color','k');
hold on;
semilogy(X_line,interp1(X,Y_MedianPlusBR,X_line,'pchip'), ...
    'LineWidth',1.5,'LineStyle','--');
semilogy(X_line,interp1(X,Y,X_line,'pchip'), ...
    'LineWidth',1.5,'Color',[0 0.4470 0.7410]);

legend({'Median','Median + Between-event residual','Simulated intensity'}, ...
    'Location','northoutside');

box on;
% grid on;
xlabel('$\mathrm{Distance\ (km)}$','Interpreter','latex');
ylabel(['$S_{a}(T=\ ',num2str(Period,'%g'), ...
    's)(\mathrm{g})$'],'Interpreter','latex');
% title(['$S_{a,y}=',num2str(IM_1),'\ \mathrm{g},\ T=', , ...
%     '$'],'Interpreter','latex');
ylim([0.05 1.3]);
ax = gca; 
ax.FontSize = 14;
ax.FontName = 'Times New Roman';
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 10 10]);

end

