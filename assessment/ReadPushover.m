function [Fbase,RoofDrift] = ReadPushover(pylibDir,Bldheight)

T_disp = readtable(fullfile(pylibDir,'URP0_NodeDispHistory.txt'));
RoofDrift = abs(T_disp{:,end}./Bldheight);
T_force = readtable(fullfile(pylibDir,'URP0_ForceHistory.txt'));
Fbase = abs(T_force{:,2});

end

