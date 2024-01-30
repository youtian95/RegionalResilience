function [FunctionRecovery,DSState] = SimulateRecovery( ...
    BldFile,SimLossDir,RadiusFactor,HeightLowerBound,TimeSim, ...
    RemainingRepairTime,RemainingFunctionalRepairTime, DaysStep,N_sim)
% FunctionRecovery: [i_time,i_bld,i_sim]

T = readtable(BldFile);
BldHeightAll = zeros(1,size(T,1));

T_height = readtable('HazusData Table 5.1.csv', ...
    'PreserveVariableNames',true);

f = waitbar(0,'Please wait...');

for i=1:size(T,1)
    waitbar(i/size(T,1),f,'reading building height...');
    ind = startsWith(T_height{:,'building type'}, ...
        T{i,'StructureType'},'IgnoreCase',true);
    StoryHeight = T_height{ind,'typical height to roof (feet)'}./ ...
        T_height{ind,'typical stories'}.*0.3048;
    StoryHeight = StoryHeight(1,1);
    N = T{i,'NumberOfStories'};
    BldHeightAll(i) = StoryHeight*N;
end

DistMat = zeros(size(T,1));
% distance matrix
addpath('..\matlab lib\WebMercator2LongLat');
for i=1:size(T,1)
    waitbar(i/size(T,1),f,'calculating building distances...');
    DistMat(i,:) = LngLat_Small_Distance( ...
        T{i,'Longitude'},T{i,'Latitude'},T{:,'Longitude'},T{:,'Latitude'});
end

% cordons impact matrix. whether i_row is impacted by j_col
CordonMat = (DistMat<repmat(BldHeightAll.*RadiusFactor,size(T,1),1));
CordonMat(logical(diag(ones(1,size(T,1)))))=false;
CordonMat(:,BldHeightAll<HeightLowerBound)=false;

% 读取震后数据
% T_loss_1 = readtable(fullfile(SimLossDir,'BldLoss_bldID_0.csv'));
% N_sim = size(T_loss_1,1);

if nargin<=5
    RemainingRepairTime = zeros(N_sim,size(T,1));
    RemainingFunctionalRepairTime = zeros(N_sim,size(T,1));
    for i=1:size(T,1)
        waitbar(i/size(T,1),f,'reading post-earthquake results...');
        T_loss = readtable(fullfile(SimLossDir, ...
            ['BldLoss_bldID_',num2str(T{i,'id'}),'.csv']));
        RemainingRepairTime(:,i) = T_loss{:,'RepairTime'};
        RemainingFunctionalRepairTime(:,i) = T_loss{:,'FunctionLossTime'};
    end
    save('RemainingRepairTime.mat','RemainingRepairTime');
    save('RemainingFunctionalRepairTime.mat','RemainingFunctionalRepairTime');
end

% 模拟恢复
TotalSteps = floor(TimeSim/DaysStep);
FunctionRecovery = false(TotalSteps+1,size(T,1),N_sim);
DSState = false(TotalSteps+1,size(T,1),N_sim);

for i_sim = 1:N_sim
    waitbar(i_sim/N_sim,f,'post-earthquake recovery simulation...');
    
    RemainingRepairTime_new = RemainingRepairTime(i_sim,:);
    RemainingFunctionalRepairTime_new = RemainingFunctionalRepairTime(i_sim,:);
    
    % 更新 cordons impact matrix
    CordonMat_New = UpdateNewCordonMat(CordonMat, ...
            RemainingRepairTime_new);
    Ifforward = (~any(CordonMat_New,2))';
    
    % 初始状态
    FunctionRecovery(1,:,i_sim) = (RemainingFunctionalRepairTime_new<0.1) ...
        & Ifforward;
    DSState(1,:,i_sim) = (RemainingRepairTime_new<0.1);
    for i = 1:TotalSteps
        % 维修
        RemainingRepairTime_new(Ifforward) = RemainingRepairTime_new(Ifforward) ...
            -DaysStep;
        RemainingFunctionalRepairTime_new(Ifforward) = ...
            RemainingFunctionalRepairTime_new(Ifforward) - DaysStep;
        RemainingRepairTime_new(RemainingRepairTime_new<0)=0;
        RemainingFunctionalRepairTime_new(RemainingFunctionalRepairTime_new<0)=0;
        % 更新 cordons impact matrix
        CordonMat_New = UpdateNewCordonMat(CordonMat, ...
            RemainingRepairTime_new);
        Ifforward = (~any(CordonMat_New,2))';
        % 保存
        FunctionRecovery(i+1,:,i_sim) = ...
            (RemainingFunctionalRepairTime_new<0.1) & Ifforward;
        DSState(i+1,:,i_sim) = (RemainingRepairTime_new<0.1);
    end
end


close(f);
end

function CordonMat_New = UpdateNewCordonMat(CordonMat, ...
    RemainingRepairTime_new)
    CordonMat_New = CordonMat;
    CordonMat_New(CordonMat_New & ...
        repmat(RemainingRepairTime_new>0.1,size(CordonMat,1),1)) = true;
end
