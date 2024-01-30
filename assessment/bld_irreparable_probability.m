function P_irr_all = bld_irreparable_probability(...
    filename,DataDir,MIDR,beta)

T = readtable(filename);

P_irr_all = zeros(1,height(T));
f = waitbar(0,'Please wait...');
for i=1:height(T)
    waitbar(i/size(T,1),f,'Please wait...');
    T_simEDP = readtable(fullfile(DataDir, ...
        ['SimEDP_bldID_',num2str(T{i,'id'}),'.csv']));
    SimResDrift = T_simEDP{:,'ResDrift'};
    SimResDrift(isnan(SimResDrift)) = [];
    Median_ResDrift = exp(mean(log(SimResDrift)));
    beta_ResDrift = std(log(SimResDrift));
    P_irr = 1-cdf('Normal',0,log(Median_ResDrift/MIDR),sqrt(beta_ResDrift^2+beta^2));
    P_irr_all(i) = P_irr;
end
close(f);


end

