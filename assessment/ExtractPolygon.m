function loc = ExtractPolygon(str)
% 提取建筑多边形
% 输出：
% loc - N行，2列; 每一行为[x,y]，一个平面结点的经纬度; 多边形首尾相连

newStr = extractBetween(str,'[[[',']]]');
newStr = split(newStr,'],[');
newStr = replace(newStr,',',' ');
newStr = cell2mat(newStr);
loc = str2num(newStr);

end

