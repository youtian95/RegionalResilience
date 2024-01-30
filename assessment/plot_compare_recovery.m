function plot_compare_recovery(RFRT,beta)

RemainingFunctionalRepairTime_all = {};
for i=1:numel(RFRT)
    load(RFRT{i});
    RemainingFunctionalRepairTime_all{i} = RemainingFunctionalRepairTime;
end

RandomFunction_all = {};
for i=1:numel(RFRT)
    RemainingFunctionalRepairTime = RemainingFunctionalRepairTime_all{i};
    RandomFunction = RemainingFunctionalRepairTime;
    ind = (RemainingFunctionalRepairTime==0);
    umat = randn(size(RemainingFunctionalRepairTime));
    RandomFunction(~ind) = exp(log(RemainingFunctionalRepairTime(~ind))+ ...
        umat(~ind).*beta);
    RandomFunction_all{i} = RandomFunction;
end

hold on;

p_all = [];
text_legend = {};
for i_case=1:numel(RandomFunction_all)
    text_legend = [text_legend,num2str(i_case)];
    RandomFunction = RandomFunction_all{i_case};
    x = 1:max(RandomFunction,[],'all');
    y = zeros(size(x));
    for i=1:max(RandomFunction,[],'all')
        y(i) = sum(RandomFunction<=i,'all')/numel(RandomFunction);
    end
    p = plot(x,y);
    p.LineWidth = 2;
    p_all = [p_all,p];
end

legend(p_all,text_legend);

box on;
% grid on;
xlabel('$\mathrm{Time\ (days)}$','Interpreter','latex');
ylabel('$\mathrm{Function}$','Interpreter','latex');
% title(['$S_{a,y}=',num2str(IM_1),'\ \mathrm{g},\ T=', , ...
%     '$'],'Interpreter','latex');
ax = gca; 
ax.FontSize = 14;
ax.FontName = 'Times New Roman';
% ylim([0 1]);
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 10 8]);

end

