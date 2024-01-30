function plot_function_recovery(FunctionRecovery,DaysStep)
% FunctionRecovery: [i_time,i_bld,i_sim]

hold on;
x = ((1:size(FunctionRecovery,1))-1).*DaysStep;
for i_sim=1:size(FunctionRecovery,3)
    y = mean(FunctionRecovery(:,:,i_sim),2);
    p = plot(x,y);
    p.LineWidth = 1.5;
end

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

