figure;hold on;axis off;
grid3D([0,0,0], [1,1,1], 'Amount', [4,4,4], 'Axes', gca, 'MinorGrid','Arrow','AxTicks',[{['']},{['']},{['']}],...
    'AxLabels',["";"";""]);

P = [0.5,0.5,1];
Q = [1,0.5,1];
point3D([0,0,0],P,'Marker','arrow','Label','P(0.5|0.5|1)','Color',[0.7 0.5 0]);
point3D([0,0,0],Q,'Marker','arrow','Label','Q(1|0.5|1)','Color',[0.0 0.4 0.74],'Deviation',[0,0,0.1]);

% second grid which is rotate by 45° around x and 90° around y
gridStart = [2,1,1];gridEnd = [3,2,2];
[Rx, Ry, Rz] = grid3D(gridStart, gridEnd, 'Amount', [4,4,4], 'Axes', gca, 'MinorGrid','Arrow','AxTicks',[{['']},{['']},{['']}],...
    'AxLabels',["";"";""],'Rotate',[45, 90, 0]);
rotateMat = Rx*Ry*Rz;

newP = gridStart+[rotateMat*P']';
newQ = gridStart+[rotateMat*Q']';

s = num2str(round(newP,1));
while contains(s, '  ')
    s = strrep(s, '  ', ' ');
end
PLabel = replace(s,' ','|');

s = num2str(round(newQ,1));
while contains(s, '  ')
    s = strrep(s, '  ', ' ');
end
QLabel = replace(s,' ','|');

point3D(gridStart,newP,'Marker','arrow','Label',PLabel,'Color',[0.7 0.5 0]);
point3D(gridStart,newQ,'Marker','arrow','Label',QLabel,'Color',[0.0 0.4 0.74],'Deviation',[0,0,0.1]);

% third grid rotated and stretched, the vectors are not streched...
gridStart = [-1,0,3];gridEnd = [1,1,4];
arg = grid3D(gridStart, gridEnd, 'Amount', [4,4,4], 'Axes', gca, 'MinorGrid','Arrow','AxTicks',[{['']},{['']},{['']}],...
    'AxLabels',["";"";""],'Rotate',[60, 20, -20]);
rotateMat = arg;

newP = gridStart+[rotateMat*P']';
newQ = gridStart+[rotateMat*Q']';

s = num2str(round(newP,1));
while contains(s, '  ')
    s = strrep(s, '  ', ' ');
end
PLabel = replace(s,' ','|');

s = num2str(round(newQ,1));
while contains(s, '  ')
    s = strrep(s, '  ', ' ');
end
QLabel = replace(s,' ','|');

point3D(gridStart,newP,'Marker','arrow','Label',PLabel,'Color',[0.7 0.5 0]);
point3D(gridStart,newQ,'Marker','arrow','Label',QLabel,'Color',[0.0 0.4 0.74],'Deviation',[0,0,0.1]);