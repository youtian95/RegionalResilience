function Median = plot_Compare_cdf_regional(AllLosses,DV)
% DS: {'RepairCost_Total', ...
% 	'RepairCost_Struct','RepairCost_NonStruct_DriftSen',  ...
% 	'RepairCost_NonStruct_AccelSen','RepairTime','RecoveryTime',...
% 	'FunctionLossTime'};

AllLossSimResults_all = {};
InvalidBldID_all = {};
for i=1:numel(AllLosses)
    load(AllLosses{i});
    AllLossSimResults_all{i} = AllLossSimResults;
    InvalidBldID_all{i} = InvalidBldID;
end

LineStyle_vec = {'-','--',':','-.'};
Color_vec = [0.4660 0.6740 0.1880; 0 0.4470 0.7410; ...
    0.9290 0.6940 0.1250; 0.8500 0.3250 0.0980; ...
    0.4940 0.1840 0.5560; 0.6350 0.0780 0.1840];
hold on;
Median = zeros(numel(AllLossSimResults_all),numel(DV));
for j=1:numel(AllLossSimResults_all)
    AllLossSimResults = AllLossSimResults_all{j};
    Samples_all = AllLossSimResults{:,DV};
    for i=1:size(Samples_all,2)
        samples = Samples_all(:,i);
        plot(sort(samples),(1:numel(samples))./numel(samples), ...
            'LineWidth', 1.5,'LineStyle',LineStyle_vec{j}, ...
            'Color',Color_vec(size(Samples_all,2)-i+1,:));
        Median(j,i) = median(samples);
    end
end

% 图例
legend_p = [];
legend_label = DV;
for j=1:numel(AllLossSimResults_all)
    if j~=1
        legend_label = [legend_label,num2str(j)];
    end
    for i=1:numel(DV)
        p = plot([0],[0], ...
            'LineWidth', 1,'LineStyle',LineStyle_vec{j}, ...
            'Color',Color_vec(size(Samples_all,2)-i+1,:));
        legend_p = [legend_p,p];
    end
end
l = legend(legend_p([1:numel(DV), ...
    (numel(DV)+1):numel(DV):(numel(AllLossSimResults_all)*numel(DV))]), ...
    legend_label());
l.Interpreter = 'none';

box on;
% grid on;
xlabel('$\mathrm{DV}$','Interpreter','latex');
ylabel('$\mathrm{CDF}$','Interpreter','latex');
% title(['$S_{a,y}=',num2str(IM_1),'\ \mathrm{g},\ T=', , ...
%     '$'],'Interpreter','latex');
ax = gca; 
ax.FontSize = 14;
ax.FontName = 'Times New Roman';
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 10 8]);

end