%% Plot Building Footprints
plot_bld(filename,'g');

LongRange = [-122.448346,-122.397862];
LatRange = [37.780022,37.808717];
LongRange = (LongRange-LongRange(2))./3+LongRange(2);
LatRange = (LatRange-LatRange(1))./3+LatRange(1);
plot_bld_3D(filename,LongRange,LatRange,[190 190 190]./255);

%% Plot Building Story
plot_bld_story(filename);
% exportgraphics(gca,'Figures/StoryBld.eps','ContentType','vector');

%% Plot Building Structural type
plot_bld_StructuralType(filename);
% exportgraphics(gca,'Figures/StructuralType.eps','ContentType','vector');

%% Plot YearBuilt
plot_bld_YearBuilt(filename);

%% histogram of building information
% 'YearBuilt'，'StructureType', 'NumberOfStories', 'PlanArea'
info = 'PlanArea';
plot_histogram_bld(filename,info);
% exportgraphics(gca,['Figures/',info,'.pdf'],'ContentType','vector');
