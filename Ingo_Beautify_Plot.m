function Ingo_Beautify_Plot(varargin)
% Ingo_Beautify_Plot by Ingo Hermann, 2021-05-18
% This functions makes pretty plots with subplots and everything. Increases
% the text size and so on ...
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp:. Ingo_Beautify_Plot('LineWidth',1.5,'Arrow');
%
% --- optional input arguments ---
% Ingo_Beautify_Plot(varargin)
% 'Size',SizeVec ... gives the size of the figure in relative units
% (Default: [0.1 0.1 0.8 0.8])
% 'Scale',fac ... scales the text size by a factor (Default: 1)
% 'Grid' ... activates the grid of the plot (Default: off)
% 'Box' ... activates the box of the plot (Default: off)
% 'LineWidth',LineWidth ... set the LineWidth of all lines by LineWidth
% (Default: no changes)
% 'MarkerSize',MarkerSize ... set the MarkerSize of all Markers by
% MarkerSize (Default: no changes)
% 'Arrow' ... plots an arrow at the figure axes (Default: off)
% 'LegendColor,'LegendColor ... sets the color of the legend by the color
% vector LegendColor (Default: [1 1 1 0.7])
%


hFig = gcf;

if max(strcmp(varargin,'Size'))
    idx = 1 + find(strcmp(varargin,'Size'));
    SizeVec = varargin{1,idx};
else
    SizeVec = [0.1 0.1 0.7 0.7];
end
set(hFig, 'Color', [1 1 1], 'Units', 'normalized', 'Position', SizeVec)
% set(hFig, 'Color', [1 1 1], 'Units', 'inches', 'Position', [1 1 9 6])

AxesChildren = get(hFig, 'Children');


if max(strcmp(varargin,'Scale'))
    idx = 1 + find(strcmp(varargin,'Scale'));    
    fac = varargin{1,idx};
else
    fac = 1;
end

if max(strcmp(varargin,'LineWidth'))
    idx = 1 + find(strcmp(varargin,'LineWidth'));
	LineWidth = varargin{1,idx};
end
if max(strcmp(varargin,'MarkerSize'))
    idx = 1 + find(strcmp(varargin,'MarkerSize'));
	MarkerSize = varargin{1,idx};
end

if max(strcmp(varargin,'LegendColor'))
    idx = 1 + find(strcmp(varargin,'LegendColor'));
    LegendColor = varargin{1,idx};
else
    LegendColor = [1 1 1 0.7];
end

if max(strcmp(varargin,'FontName'))
    idx = 1 + find(strcmp(varargin,'FontName'));
    FontName = varargin{1,idx};
else
    FontName = 'Calibri';
end

for counter = 1 : 1 : length(AxesChildren)
    if(strcmp(get(AxesChildren(counter), 'Type'), 'axes'))
        set(AxesChildren(counter),'FontSize',round(18*fac));
%         set(AxesChildren(counter),'TickDir','out');
        set(AxesChildren(counter),'TickLength',[.015 .015]);
        set(AxesChildren(counter),'ZColor',[0 0 0]);
        set(AxesChildren(counter),'GridColor',[0.15 0.15 0.15]);
        set(AxesChildren(counter),'GridAlpha',0.15);
        set(AxesChildren(counter),'GridLineStyle','-');
        set(AxesChildren(counter),'XColor',[.0 .0 .0]);
        set(AxesChildren(counter),'YColor',[.0 .0 .0]);
        set(AxesChildren(counter),'LineWidth',1.5);
        set(AxesChildren(counter),'FontName',FontName);
        set(get(AxesChildren(counter),'XLabel'),'FontSize',round(18*fac));
        set(get(AxesChildren(counter),'YLabel'),'FontSize',round(18*fac));
        set(get(AxesChildren(counter),'Title'),'FontSize',round(18*fac));
        set(get(AxesChildren(counter),'Title'),'FontWeight','bold');
        set(get(AxesChildren(counter),'XLabel'),'FontSize',round(18*fac));
        set(AxesChildren(counter),'Color','none');
        set(AxesChildren(counter),'XMinorTick','off');
        set(AxesChildren(counter),'YMinorTick','off');
        if max(strcmp(varargin,'LineWidth'))
            Children = AxesChildren(counter).Children;
            for cc=1:1:size(Children,1)
                Children(cc,1).LineWidth = LineWidth;%Children(cc,1).LineWidth*
            end
        end
           
        if max(strcmp(varargin,'MarkerSize'))
            Children = AxesChildren(counter).Children;
            for cc=1:1:size(Children,1)
                Children(cc,1).MarkerSize = MarkerSize;%Children(cc,1).LineWidth*
            end
        end     
    
        if max(strcmp(varargin,'Box'))
            set(AxesChildren(counter),'Box','on');
        else
            set(AxesChildren(counter),'Box','off');
%             set(AxesChildren(counter),'XMinorTick','on');
%             set(AxesChildren(counter),'YMinorTick','on');
%             set(AxesChildren(counter),'MinorGridColor',[0.15 0.15 0.15]);
%             set(AxesChildren(counter),'MinorGridAlpha',0.15);
        end
        
        if max(strcmp(varargin,'Grid'))
            set(AxesChildren(counter),'XGrid','on');
            set(AxesChildren(counter),'YGrid','on');
        else
            set(AxesChildren(counter),'XGrid','off');
            set(AxesChildren(counter),'YGrid','off');
        end
        
        
        if max(strcmp(varargin,'Arrow'))
            set(AxesChildren(counter),'XAxisLocation','origin');
            set(AxesChildren(counter),'YAxisLocation','origin');
            
            ax = AxesChildren(counter);
            axp = get(AxesChildren(counter),'Position');
            
            x = get(AxesChildren(counter),'XLim');
            y = get(AxesChildren(counter),'YLim');
            xlim = x;
            ylim = y;
            
            Start = [x(2), 0]; % x, y
            End   = [x(1), 0];  % x , y
            nx1 = [(End(1) + abs(min(xlim)))/diff(xlim) * axp(3) + axp(1),...
            (Start(1) + abs(min(xlim)))/diff(xlim) * axp(3) + axp(1) ];
            ny1 = [(End(2) - min(ylim))/diff(ylim) * axp(4) + axp(2),...
            (Start(2) - min(ylim))/diff(ylim) * axp(4) + axp(2)];

            Start2 = [-x(1), y(2)]; % x, y
            End2   = [-x(1), y(1)];  % x , y
            nx2 = [(End2(1) + abs(min(xlim)))/diff(xlim) * axp(3) + axp(1),...
            (Start2(1) + abs(min(xlim)))/diff(xlim) * axp(3) + axp(1) ];
            ny2 = [(End2(2) - min(ylim))/diff(ylim) * axp(4) + axp(2),...
            (Start2(2) - min(ylim))/diff(ylim) * axp(4) + axp(2)];
            
            if xlim(1) >0
                nx1 = nx1 - (nx1(1)-nx2(1));
            end
            if ylim(1) > 0
                ny1 = ny1 - (ny1(1)-ny2(1));
            end
            
            a1   = annotation('arrow',nx1,ny1);
            a1.LineWidth=1.2;
            
            a2   = annotation('arrow',nx2,ny2);
            a2.LineWidth=1.2;
            
%             set(AxesChildren(counter),'XLim',[x(1) x(2)-(x(2)-x(1))/15]);
%             set(AxesChildren(counter),'YLim',[y(1) y(2)+(y(2)-y(1))/15]);
        end
    
        hold(AxesChildren(counter), 'off');
    end
    
    if(strcmp(get(AxesChildren(counter), 'Tag'), 'suptitle'))
        ax1 = AxesChildren(counter);
        ax1.Children.FontSize = round(18*fac);
        ax1.Children.FontWeight = 'bold';
        ax1.Children.FontName = FontName;
        AxesChildren(counter) = ax1;
    end
    
        
    if(strcmp(get(AxesChildren(counter), 'Tag'), 'Colorbar'))
        ax1 = AxesChildren(counter);
        ax1.FontSize = round(18*fac);
        %ax1.FontWeight = 'bold';
        ax1.FontName = FontName;
        ax1.Color = [0 0 0];
        AxesChildren(counter) = ax1;
    end
    
    if(strcmp(get(AxesChildren(counter), 'Type'), 'legend'))
        set(AxesChildren(counter),'FontSize',round(16*fac));
        set(AxesChildren(counter),'EdgeColor', [0 0 0]);
        set(AxesChildren(counter),'FontName', FontName);
        lgnd = AxesChildren(counter);
        try 
            lgnd.BoxColor = [0 0 0];
        end
        lgnd.BoxFace.ColorType='truecoloralpha';
        lgnd.BoxFace.ColorData=uint8(255*LegendColor');
        AxesChildren(counter) = lgnd;
    end
    
    

    
end

end
%-------------------------------------------------------------------------------