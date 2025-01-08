function scatthemALL(x, data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% 'o'	Circle
% '+'	Plus sign
% '*'	Asterisk
% '.'	Point
% 'x'	Cross
% 'square' or 's'	Square
% 'diamond' or 'd'	Diamond
% '^'	Upward-pointing triangle
% 'v'	Downward-pointing triangle
% '>'	Right-pointing triangle
% '<'	Left-pointing triangle
% 'pentagram' or 'p'	Five-pointed star (pentagram)
% 'hexagram' or 'h'	Six-pointed star (hexagram)
% 'none'


[w,~] = size(data);
marks = {'o', '<', 'v', 'o', 'd', 's', 'd', '^', '>', 'p', 'h'};
 cor = {'b','r','g','y', 'm', 'c', 'b', 'b', 'r', 'g', 'k'};
for i=1:w
    scatter(x, data(i, :), 75, 'filled', marks{i}, 'MarkerFaceColor', cor{i});
    hold on;
end

end

