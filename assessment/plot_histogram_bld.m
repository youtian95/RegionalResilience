function plot_histogram_bld(filename,info)

T = readtable(filename);
X = T{:,info};
if strcmp(info,'YearBuilt')
    BinWidth = 10;
    histogram(X,'BinWidth',BinWidth);
elseif strcmp(info,'StructureType')
    histogram(categorical(X));
elseif strcmp(info,'NumberOfStories')
    histogram(X,0.5:1:20.5);
elseif strcmp(info,'PlanArea')
    histogram(X,0:1000:30000);
end

box on;
% grid on;
xlabel(['$\mathrm{',info,'}$'],'Interpreter','latex');
ylabel('$\mathrm{Frequency}$','Interpreter','latex');
% title(['$S_{a,y}=',num2str(IM_1),'\ \mathrm{g},\ T=', , ...
%     '$'],'Interpreter','latex');
ax = gca; 
ax.FontSize = 14;
ax.FontName = 'Times New Roman';
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 10 8]);

end

