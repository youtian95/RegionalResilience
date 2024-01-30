function SimulateLossesBasedonIM_repr(Bld2ReprBld,ReprBld, ...
    IM_sim,filename,IDA_result_dir,BetaM,OutputDir)

listing = dir(filename);
filename = fullfile(listing.folder,listing.name);

listing = dir(IDA_result_dir);
IDA_result_dir = listing(1).folder;

listing = dir(OutputDir);
OutputDir = listing(1).folder;

current_folder = cd;

cd('..\python lib\MDOFModel');
insert(py.sys.path,int32(0),'');


T = readtable(filename);
f = waitbar(0,'Please wait...');
for i=1:size(T,1)
    waitbar(i/size(T,1),f,'Please wait...');
    ID_repr = Bld2ReprBld{Bld2ReprBld{:,'Original Buildings index'}==(i-1), ...
        'Representative Buildings index'};
    IDA_result = fullfile(IDA_result_dir,['IDA_result_ReprBldID_', ...
        num2str(ID_repr),'.csv']);
    IDA_result = py.str(replace(IDA_result,'\','/'));
    IM_list = IM_sim(IM_sim(:,1)==T{i,'id'},2:end);
    IM_list = py.list(single(IM_list));
    N_Sim = py.list({int8(1)});
    NumofStories = py.int(ReprBld{ID_repr+1,'NumberOfStories'});
    FloorArea = py.float(ReprBld{ID_repr+1,'PlanArea'});
    StructuralType = py.str(ReprBld{ID_repr+1,'StructureType'}{1});
    DesignLevel = py.str(ReprBld{ID_repr+1,'DesignLevel'}{1});
    OccupancyClass = py.str(ReprBld{ID_repr+1,'OccupancyClass'}{1});
    
    py.Tool_LossAssess.Simulate_losses_given_IM_basedon_IDA( ...
        IDA_result,IM_list,N_Sim,py.float(BetaM), ...
        py.str(replace(OutputDir,'\','/')), ...
        NumofStories,FloorArea,StructuralType,DesignLevel,OccupancyClass);
    status = movefile(fullfile(OutputDir,'BldLoss.csv'), ...
        fullfile(OutputDir,['BldLoss_bldID_',num2str(T{i,'id'}),'.csv']));
    status = movefile(fullfile(OutputDir,'SimEDP.csv'), ...
        fullfile(OutputDir,['SimEDP_bldID_',num2str(T{i,'id'}),'.csv']));

end
close(f);

cd(current_folder);

end

