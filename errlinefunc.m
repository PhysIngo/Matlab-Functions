function [varargout] = errlinefunc(x, y,xerr,yerr, varargin)
% errlinefunc by Ingo Hermann, 2021-05-18
% This is a function to plot a maximal and minimal errorline.
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp.: [varargout] = errlinefunc(x, y, xerr, yerr, 'Errorlines');
%
% --- arguments ---
% errlinefunc(x, y, xerr, yerr, ...);
% x, y ... input x and y data to plot and fit
% xerr, yerr ... errors of x and y data. If xerr is 0 then there will be no
% error considered. Both can either be a single number, meaning every data
% point gets the same error, or an array with size of x and individual
% errors.
%
% -- optional input arguments -- 
% errlinefunc(...,varargin)
% without any varargin it won't plot anything!!!
% 'Box' ... Plots a box around min and max errorline (Default: off)
% 'BoxColor',BoxColor ... this changes the color of the box (Default: black)
% 'Errorline' ... Plot the errorlines
% 'LineColor',LineColor ... changes color of error lines (Default: blue)
% 'LineWidth',LineWidth ... changes all line widths (Default: 1.5)
% 'Plot' ... Plots input x and y with errorbar xerr and yerr (Default: off)
% 'PlotColor',PlotColor ... changes the color of the plot (Default: black)
% 'MarkerSize',MarkerSize .... changes size of plot marker (Default: 10)
% 'Marker',Marker .... changes marker of the plot (Default: '.')
% 'Fit' ... draws the fit through x and y (Default: off)
% 'FitColor',FitColor ... colors the fit (Default: green)
% 'FitMarker',PlotMarker ... changes marker of the fit (Default: '-')
% 'UseStd' ... uses the standard deviations of the input instead of the
% xerr and yerr.
% 'Fill' ... fills the box area with the default color
% 'FillColor',FillColor ... colors the fill (Default: light blue)
% 'Legend' ... activates the legend for the chosen plot option
% 'Location',Location ... plots the legend at a certain location (Default:
% NorthWest)
% 'LegendNames',LegendNames ... is a cell array containing the names for
% the legend (Default: {['Data with errorbars','Fit','max error line','min
% error line']})
%
% -- optional output arguments -- 
% varargout = errlinefunc(...)
% varargout ... gives back the slope and intercept for both the min and
% maximal error line [slopeMax,slopeMin,interceptMax,interceptMin]
%

len=numel(x);
if(xerr==0)
   xerr = zeros([len,1]);
end

if numel(xerr)~=len
   xerr = ones([len,1]).*xerr;
end
if numel(yerr)~=len
   yerr = ones([len,1]).*yerr;
end


if max(strcmp(varargin,'UseStd'))
    yerr = ones([len,1]).*std(y);
end
    

ymax=y+yerr;
ymin=y-yerr;

fitmax=fit(x,ymax,'poly1');
fitmin=fit(x,ymin,'poly1');
fitVal=fit(x,y, 'poly1');

%Fit the maximal and the minimal errorlines through the mesured values with
%their deviations.
a=coeffvalues(fitmax);
b=coeffvalues(fitmin);
c=coeffvalues(fitVal);
amax=a(1);
amin=b(1);
bmax=a(2);
bmin=b(2);
% afit=c(1);
% bfit=c(2);

%Declare the 4 corners of the box
[v, idx] = min(x);
xlu=v-xerr(idx);
xld=v-xerr(idx);
[v, idx] = max(x);
xru=v+xerr(idx);
xrd=v+xerr(idx);

ylu=amax*xlu+bmax;
yru=amax*xru+bmax;
yld=amin*xld+bmin;
yrd=amin*xrd+bmin;

%Declare the vectors of the corners.
xcorner=[xlu xru xrd xld xlu];
ycorner=[ylu yru yrd yld ylu];
xcrnmax=[xlu xrd];
xcrnmin=[xld xru];
ycrnmax=[ylu yrd];
ycrnmin=[yld yru];

smax=(yru-yld)/(xru-xld);
smin=(yrd-ylu)/(xrd-xlu);
rmax=yld-xld*smax;
rmin=ylu-xlu*smin;

% f1(x)=rmax+x*smax;
% f2(x)=rmin+x*smin;
%Declare the rises and the y-values
% s1=(yrd-ylu)/(xrd-xlu);
% s2=(yru-yld)/(xru-xld);
% y1=ylu-s1*xlu;
% y2=yld-s2*xld;

yneg = yerr;ypos = yerr;
xneg = xerr;xpos = xerr;

% output the slope s and the x axis cut t from f(x)=r+x*s; where max
% describes the upper errorline
varargout{1} = smax;
varargout{2} = smin;
varargout{3} = rmax;
varargout{4} = rmin;

if max(strcmp(varargin,'LineWidth'))
    idx = 1 + find(strcmp(varargin,'LineWidth'));
    LineWidth = varargin{1,idx};
else
    LineWidth = 1.5;
end
        
        
hold on;
legCount = 1;
myLegend = gobjects(1,1);
myLegNames{1,legCount} = cell(1,1);
% depicts mimal and maximal error line
if max(strcmp(varargin,'LineColor'))
    idx = 1 + find(strcmp(varargin,'LineColor'));
    LineColor = varargin{1,idx};
else
    LineColor = [0 0.4 0.7];
end


% show the plot with errorbars
if max(strcmp(varargin,'Plot'))  
    if max(strcmp(varargin,'Marker'))
        idx = 1 + find(strcmp(varargin,'Marker'));
        Marker = varargin{1,idx};
    else
        Marker = '.';
    end
    
    if max(strcmp(varargin,'MarkerSize'))
        idx = 1 + find(strcmp(varargin,'MarkerSize'));
        MarkerSize = varargin{1,idx};
    else
        MarkerSize = 10;
    end
    
    if max(strcmp(varargin,'PlotMarker'))
        idx = 1 + find(strcmp(varargin,'PlotMarker'));
        PlotColor = varargin{1,idx};
    else
        PlotColor = [0 0 0];
    end
    
    hError = errorbar(x,y,yneg,ypos,xneg,xpos,'.','Color',PlotColor,...
        'LineWidth',LineWidth*0.7);
    plot(x,y,Marker,'Color',PlotColor,...
        'LineWidth',LineWidth,'MarkerSize',MarkerSize);
    myLegend(legCount) = hError;
    myLegNames{1,legCount} = 'Data with errorbars';
    legCount = legCount + 1;
end

% draw the fit through x and y
if max(strcmp(varargin,'Fit'))  
    if max(strcmp(varargin,'FitColor'))
        idx = 1 + find(strcmp(varargin,'FitColor'));
        FitColor = varargin{1,idx};
    else
        FitColor = [0.2 0.7 0.2];
    end
    if max(strcmp(varargin,'FitMarker'))
        idx = 1 + find(strcmp(varargin,'FitMarker'));
        FitMarker = varargin{1,idx};
    else
        FitMarker = '-';
    end
    hFit = plot(fitVal);
    hFit.LineStyle = FitMarker;
    set(hFit,'LineWidth',LineWidth','Color',FitColor);
    myLegend(1,legCount) = hFit;
    myLegNames{1,legCount} = ['Fit: ',num2str(round(c(1),2)),'*x+',...
        num2str(round(c(2),2))];
    legCount = legCount + 1;
end

if max(strcmp(varargin,'Errorline'))  
    hErrLineMax = line(xcrnmax,ycrnmax,'Color',LineColor,'LineWidth',LineWidth);
    hErrLineMin = line(xcrnmin,ycrnmin,'Color',LineColor,'LineWidth',LineWidth);
    myLegend(legCount) = hErrLineMax;
    myLegNames{1,legCount} = ['max error line: ',num2str(round(smax,2)),'*x+',...
            num2str(round(rmax,2))];
    legCount = legCount + 1;
    myLegend(legCount) = hErrLineMin;
    myLegNames{1,legCount} = ['min error line: ',num2str(round(smin,2)),'*x+',...
            num2str(round(rmin,2))];
end

% depict the box of the errorlines
if max(strcmp(varargin,'Box'))
    if max(strcmp(varargin,'BoxColor'))
        idx = 1 + find(strcmp(varargin,'BoxColor'));
        BoxColor = varargin{1,idx};
    else
        BoxColor = [0 0 0];
    end
    plot(xcorner,ycorner,'--','Color',BoxColor,'LineWidth',LineWidth*0.7);
end
% fills the box area: area of std
if max(strcmp(varargin,'Fill'))
    if max(strcmp(varargin,'FillColor'))
        idx = 1 + find(strcmp(varargin,'FillColor'));
        FillColor = varargin{1,idx};
    else
        FillColor = [0.7 0.8 1];
    end
    f1 = fill(xcorner,ycorner,'--','FaceColor',FillColor);
    uistack(f1,'bottom');
end
% add a legend
if max(strcmp(varargin,'Legend'))  
    
    if max(strcmp(varargin,'Location'))
        idx = 1 + find(strcmp(varargin,'Location'));
        Location = varargin{1,idx};
    else
        Location = 'NorthWest';
    end
    
    if max(strcmp(varargin,'LegendNames'))
        idx = 1 + find(strcmp(varargin,'LegendNames'));
        LegendNames = varargin{1,idx};
    else
        LegendNames = myLegNames;
    end
    legend(myLegend,LegendNames,'Location',Location); 
end


end