function Loss_results = RegionalLossAssessBasedOnAccelHist(filename,SCFactor)

diary log.txt
T = readtable(filename);
Loss_results = cell(1,size(T,1));
for i=1:size(T,1)
    fprintf('%u Analysis ---------------\n',i);
    Scaling = 1;
    GMfile = FindClosestEQ(T{i,'Longitude'},T{i,'Latitude'},1);
    T_loss = EQDynamicAnalysis(T(i,:),GMfile{1},Scaling,SCFactor);
    Loss_results(i) = {T_loss};
    fprintf('\n');
end
diary off

end

