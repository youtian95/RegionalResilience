function plot_functionalLoss_recovery(RemainingFunctionalRepairTime,beta)

RandomFunction = RemainingFunctionalRepairTime;
ind = (RemainingFunctionalRepairTime==0);
umat = randn(size(RemainingFunctionalRepairTime));
RandomFunction(~ind) = exp(log(RemainingFunctionalRepairTime(~ind))+ ...
    umat(~ind).*beta);

hold on;
gradcolor = [0.6 0.6 0.6];
for i_sim=1:100 %size(RandomFunction,1)
    samples = RandomFunction(i_sim,:);
    p = plot(sort(samples),(1:numel(samples))./numel(samples));
    p.LineWidth = 0.2;
    p.Color = gradcolor;
end

x = 1:max(RandomFunction,[],'all');
y = zeros(size(x));
for i=1:max(RandomFunction,[],'all')
    y(i) = sum(RandomFunction<=i,'all')/numel(RandomFunction);
end
p = plot(x,y);
p.LineWidth = 2;
redcolor = [0.6350 0.0780 0.1840];
p.Color = redcolor;

p1 = plot(0,0,'LineWidth',0.2,'Color',gradcolor);
p2 = plot(0,0,'LineWidth',2,'Color',redcolor);
legend([p1,p2],{'Individual','Mean'});

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

