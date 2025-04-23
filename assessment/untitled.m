f = waitbar(0,'Please wait...');
for i=1:size(ReprBld,1) 
    waitbar(i/size(ReprBld,1),f,'Please wait...');
    NumofStories = ReprBld{i,'NumberOfStories'};
    FloorArea = ReprBld{i,'PlanArea'};
    StructuralType = ReprBld{i,'StructureType'}{1};
    DesignLevel = ReprBld{i,'DesignLevel'}{1};
    OutputCSVFile = fullfile(OutputDir, ...
        ['IDA_result_ReprBldID_',num2str(i-1),'.csv']);
    IDA(IM_D_list,NumofStories,FloorArea,StructuralType, ...
        DesignLevel, EQMetaDataFile, OutputCSVFile, ...
        SelfCenteringEnhancingFactor)
end
close(f);