function [RemainingRepairTime,RemainingFunctionalRepairTime] = ...
    ReadRecoveryData(filename,SimLossDir,N_sim)
    T = readtable(filename);
    
    RemainingRepairTime = zeros(N_sim,size(T,1));
    RemainingFunctionalRepairTime = zeros(N_sim,size(T,1));
    
    f = waitbar(0,'Please wait...');
    ValidBldID = {};
    for i=1:size(T,1)
        waitbar(i/size(T,1),f,'reading post-earthquake results...');
        T_loss = readtable(fullfile(SimLossDir, ...
            ['BldLoss_bldID_',num2str(T{i,'id'}),'.csv']));
        if any(strcmp(T_loss{:,'DS_Struct'},'UNKNOWN'))
            ValidBldID = [ValidBldID,T{i,'id'}];
            continue
        end
        RemainingRepairTime(:,i) = T_loss{:,'RepairTime'};
        RemainingFunctionalRepairTime(:,i) = T_loss{:,'FunctionLossTime'};
    end
    save('RemainingRepairTime.mat','RemainingRepairTime');
    save('RemainingFunctionalRepairTime.mat','RemainingFunctionalRepairTime');
    
    close(f);
end

