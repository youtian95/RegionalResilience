function Plot_ComparePushover_PrototypeVSMDOF(MDOF,SC,Weight)

CData = [0 0.4470 0.7410; ...
    0.8500 0.3250 0.0980];

hold on;

plot(MDOF(1).RoofDrift.*100, MDOF(1).Fbase./10^6, ...
    'LineStyle', '--', 'Color',CData(1,:), 'LineWidth', 1.5);
plot(MDOF(2).RoofDrift.*100, MDOF(2).Fbase./10^6, ...
    'LineStyle', '--', 'Color',CData(2,:), 'LineWidth', 1.5);

plot(SC(1).F_D(:,1).*100, SC(1).F_D(:,2).*Weight(1).*9.8./10^6, ...
    'LineStyle', '-', 'Color',CData(1,:), 'LineWidth', 1.5);
plot(SC(2).F_D(:,1).*100, SC(2).F_D(:,2).*Weight(2).*9.8./10^6, ...
    'LineStyle', '-', 'Color',CData(2,:), 'LineWidth', 1.5);


legend({'Simplified, 3-story','Simplified, 9-story', ...
    'Prototype, 3-story','Prototype, 9-story'});

box on;
% grid on;
xlabel('$\mathrm{Roof\ drift\ ratio\ (\%)}$','Interpreter','latex');
ylabel('$\mathrm{Base\ shear\ (10^{6}\ N)}$','Interpreter','latex');
% title(['$S_{a,y}=',num2str(IM_1),'\ \mathrm{g},\ T=', , ...
%     '$'],'Interpreter','latex');
ax = gca; 
ax.FontSize = 14;
ax.FontName = 'Times New Roman';
xlim([0 8]);
ylim([0 50]);
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 10 8]);

end

