function  IM_sim = ReadIMSim(filename,SiteLong,SiteLat)
% 读取IM生成结果
%
% 输入：
% filename - building inventory file
%
% 输出：
% IM_sim - [col_ID,matrix(i_ID,i_Sim)]

current_folder = cd;

addpath('..\matlab lib\WebMercator2LongLat');

IMsimprefix = 'IM sim with period ';

T = readtable(filename);

% all sim results
listing = dir(fullfile(current_folder,[IMsimprefix,'*.txt']));
TStr = extractBetween({listing.name},IMsimprefix,'.txt');
Tvec = str2double(TStr);
IMsimT = {};
for i=1:numel(listing)
    IMsimT{i} = readmatrix(fullfile(listing(i).folder,listing(i).name));
end

% all bld periods
cd('..\python lib\MDOFModel');
insert(py.sys.path,int32(0),'');

f = waitbar(0,'Please wait...');
IM_sim = [];
for row=1:size(T,1)
    waitbar(row/size(T,1),f,'Please wait...');
    % 最近周期
    bld = py.MDOF_LU.MDOF_LU(py.int(T{row,'NumberOfStories'}), ...
        py.float(T{row,'PlanArea'}), py.str(T{row,'StructureType'}{1}));
    bld.set_DesignLevel(py.str(T{row,'DesignLevel'}{1}));
    period1 = bld.T1;
    [~,I] = sort(abs(Tvec-period1));
    T_1 = Tvec(I(1));
    T_2 = Tvec(I(2));
    IMsimT_1 = IMsimT{I(1)};
    IMsimT_2 = IMsimT{I(2)};
    % 最近距离的四个点
    dist = LngLat_Small_Distance( ...
        T{row,'Longitude'},T{row,'Latitude'},SiteLong,SiteLat);
    [MinDist,I] = sort(dist);
    % 最近4个点模拟的结果
    IMsimT_1_4loc = IMsimT_1(I(1:4),2:end);
    IMsimT_2_4loc = IMsimT_2(I(1:4),2:end);
    % 
    IM_sim_row = interp1([T_1;T_2], ...
        [Mean_withDistWeight(IMsimT_1_4loc,MinDist(1:4)); ...
        Mean_withDistWeight(IMsimT_2_4loc,MinDist(1:4))],period1, ...
        'linear','extrap');
    IM_sim = [IM_sim;[T{row,'id'},IM_sim_row]];
end
close(f);

cd(current_folder);

end

function m = Mean_withDistWeight(Mat,dist)
% size(Mat,1)=numel(dist)

assert(size(Mat,1)==numel(dist));

if any(dist==0)
    m = Mat(dist==0,:);
    return
end

m =0;
for i=1:size(Mat,1)
    m = m + Mat(i,:).*(1/dist(i))./sum(1./dist);
end

end
