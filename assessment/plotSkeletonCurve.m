function plotSkeletonCurve(structParafile,storyheight, ...
    Median_IDR_Struct_DS,Beta_IDR_Struct_DS)
hold on;

i_floor = 1;
T = readtable(structParafile,'range',[3,1],'PreserveVariableNames',true);
p = plot([0,T{i_floor,'Yield displacement (m)'}, ...
    T{i_floor,'Ultimage displacement (m)'}, ...
    T{i_floor,'Complete damage displacement (m)'}]./storyheight, ...
    [0,T{i_floor,'Yield shear force (N)'}, ...
    T{i_floor,'Ultimate shear force (N)'}, ...
    T{i_floor,'Ultimate shear force (N)'}]./1000);
p.LineWidth = 1.5;

CData = [0.4660 0.6740 0.1880; ...
    0.9290 0.6940 0.1250; ...
    0.8500 0.3250 0.0980; ...
    0.6350 0.0780 0.1840];

if ~isempty(Median_IDR_Struct_DS)
    for i=1:numel(Median_IDR_Struct_DS)
        stem(Median_IDR_Struct_DS(i),2.*T{i_floor,'Ultimate shear force (N)'}./1000, ...
            'Marker','none', 'LineWidth',1.5,'LineStyle','--', ...
            'Color', CData(i,:));
    end
    legend({'Capacity curve','Slight','Moderate','Extensive','Complete'}, ...
        'Location','northeastoutside');
else
    legend({'Capacity curve'}, ...
        'Location','northeastoutside');
end

box on;
% grid on;
xlabel('$\mathrm{Drift\ ratio}$','Interpreter','latex');
ylabel('$\mathrm{Shear\ force\ (kN)}$','Interpreter','latex');
% title(['$S_{a,y}=',num2str(IM_1),'\ \mathrm{g},\ T=', , ...
%     '$'],'Interpreter','latex');
ax = gca; 
ax.FontSize = 14;
ax.FontName = 'Times New Roman';
ylim([0 1.1*T{i_floor,'Ultimate shear force (N)'}/1000]);
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 10 8]);

end