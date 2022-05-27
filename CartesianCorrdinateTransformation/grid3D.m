function varargout = grid3D(startVec,stopVec,varargin)
% Input arguments:
% startVec ... input vector of the beginning of the point in [x,y,z]
% stopVec ... input vector of the ending of the point in [x,y,z]
%
% Optional input argument (varargin):
% 'Arrow' ... plots an arrow to the axes
% 'Axes',ax ... define the axes where it should be plotted.
% 'Amount',amout ... a vector that defines the amount of grids per axes
% 'AxLabels',axlabels ... defines the labels of the axes
% 'AxTicks',axticks ... defines the ticks of the axes
% 'Offset',offset ... defines the offset of the axis labels and ticks
% (Default:15)
% 'Rotate',rotateAng ... defines the angles in x, y and z for the rotation
%
% Optional output argument:
% rotate ... Corresponding Rotation Matrix [RotateMat]

    if isempty(varargin)
        varargin{1} = '';
    end
    
    [x] = stopVec(1); 
    [y] = stopVec(2); 
    [z] = stopVec(3); 
    x2 = startVec(1);
    y2 = startVec(2);
    z2 = startVec(3);
    
    [logic, index] = max(strcmp(varargin,'Rotate'));
    if logic
        rotateAngles = varargin{index+1};
        phix = rotateAngles(1)/180*pi;phiy = rotateAngles(2)/180*pi;phiz = rotateAngles(3)/180*pi;
    else
        phix = 0;phiy = 0;phiz = 0;
    end
    % turn the signs for saving
%     Rx = [1 0 0; 0 cos(phix) -sin(phix); 0 sin(phix) cos(phix)];
%     Ry = [cos(-phiy) 0 sin(-phiy); 0 1 0; -sin(-phiy) 0 cos(-phiy)];
%     Rz = [cos(-phiz) -sin(-phiz) 0; sin(-phiz) cos(-phiz) 0; 0 0 1];
    
    Rx = [1 0 0; 0 cos(phix) -sin(phix); 0 sin(phix) cos(phix)];
    Ry = [cos(phiy) 0 sin(phiy); 0 1 0; -sin(phiy) 0 cos(phiy)];
    Rz = [cos(phiz) -sin(phiz) 0; sin(phiz) cos(phiz) 0; 0 0 1];
    varargout{1} = Rx;
    varargout{2} = Ry;
    varargout{3} = Rz;

    RotateMat = Rx*Ry*Rz;
    GridMat = [x-x2 0 0;0 y-y2 0;0 0 z-z2];
    RotGridMat = RotateMat * GridMat;
    RotGridMat = RotGridMat';
    
    [logic, index] = max(strcmp(varargin,'Offset'));
    if logic
        offset = varargin{index+1};
    else
        offset = 15;
    end
    [logic, index] = max(strcmp(varargin,'Amount'));
    if logic
        amount = varargin{index+1};
        amountx = amount(1);
        amounty = amount(2);
        amountz = amount(3);
    else
        amountx = 1;
        amounty = 1;
        amountz = 1;
    end
    
    xrange = x-x2;
    yrange = y-y2;
    zrange = z-z2;
    dx = xrange/offset;
    dy = yrange/offset;
    dz = zrange/offset;


    [logic, index] = max(strcmp(varargin,'Axes'));
    if logic 
        ax = varargin{index+1};
%         set(ax,'visible','off')
    else
        ax = gca;
        hold on;
        set(ax,'visible','off')
    end

    xvx1 = linspace(0,RotGridMat(1,1),amountx+2)+x2;xvx1 = xvx1';
    xvy1 = linspace(0,RotGridMat(1,2),amountx+2)+y2;xvy1 = xvy1';
    xvz1 = linspace(0,RotGridMat(1,3),amountx+2)+z2;xvz1 = xvz1';
    yvx1 = linspace(0,RotGridMat(2,1),amountx+2)+x2;yvx1 = yvx1';
    yvy1 = linspace(0,RotGridMat(2,2),amountx+2)+y2;yvy1 = yvy1';
    yvz1 = linspace(0,RotGridMat(2,3),amountx+2)+z2;yvz1 = yvz1';
    zvx1 = linspace(0,RotGridMat(3,1),amountx+2)+x2;zvx1 = zvx1';
    zvy1 = linspace(0,RotGridMat(3,2),amountx+2)+y2;zvy1 = zvy1';
    zvz1 = linspace(0,RotGridMat(3,3),amountx+2)+z2;zvz1 = zvz1';
    
    [logic, ~] = max(strcmp(varargin,'MinorGrid'));
    if logic
        view(120,25)
        plot3(ax,[0+yvx1 RotGridMat(1,1)+yvx1]',[0+yvy1 RotGridMat(1,2)+yvy1]',[0+yvz1 RotGridMat(1,3)+yvz1]','Color',[0.8 0.8 0.8]);
        plot3(ax,[0+zvx1 RotGridMat(1,1)+zvx1]',[0+zvy1 RotGridMat(1,2)+zvy1]',[0+zvz1 RotGridMat(1,3)+zvz1]','Color',[0.8 0.8 0.8]);

        plot3(ax,[0+xvx1 RotGridMat(2,1)+xvx1]',[0+xvy1 RotGridMat(2,2)+xvy1]',[0+xvz1 RotGridMat(2,3)+xvz1]','Color',[0.8 0.8 0.8]);
        plot3(ax,[0+zvx1 RotGridMat(2,1)+zvx1]',[0+zvy1 RotGridMat(2,2)+zvy1]',[0+zvz1 RotGridMat(2,3)+zvz1]','Color',[0.8 0.8 0.8]);

        plot3(ax,[0+yvx1 RotGridMat(3,1)+yvx1]',[0+yvy1 RotGridMat(3,2)+yvy1]',[0+yvz1 RotGridMat(3,3)+yvz1]','Color',[0.8 0.8 0.8]);
        plot3(ax,[0+xvx1 RotGridMat(3,1)+xvx1]',[0+xvy1 RotGridMat(3,2)+xvy1]',[0+xvz1 RotGridMat(3,3)+xvz1]','Color',[0.8 0.8 0.8]);
    end
    
    plot3(ax,[0 RotGridMat(1,1)]+x2,[0 RotGridMat(1,2)]+y2,[0 RotGridMat(1,3)]+z2,'k');
    plot3(ax,[0 RotGridMat(2,1)]+x2,[0 RotGridMat(2,2)]+y2,[0 RotGridMat(2,3)]+z2,'k');
    plot3(ax,[0 RotGridMat(3,1)]+x2,[0 RotGridMat(3,2)]+y2,[0 RotGridMat(3,3)]+z2,'k');

    %arrows
    [logic, ~] = max(strcmp(varargin,'Arrow'));
    if logic
        thickx=(yrange+zrange)/(2*xrange);
        thicky=(xrange+zrange)/(2*yrange);
        thickz=(yrange+xrange)/(2*zrange);
        
        arrow3D(startVec+RotGridMat(1,:),startVec+(1+1/offset).*RotGridMat(1,:),'Thickness',thickx,'Color',[0 0 0],'Axes',ax);
        arrow3D(startVec+RotGridMat(2,:),startVec+(1+1/offset).*RotGridMat(2,:),'Thickness',thicky,'Color',[0 0 0],'Axes',ax);
        arrow3D(startVec+RotGridMat(3,:),startVec+(1+1/offset).*RotGridMat(3,:),'Thickness',thickz,'Color',[0 0 0],'Axes',ax);
    end
    
    
    %texte
    [logic, index] = max(strcmp(varargin,'AxLabels'));
    if logic 
        axLabels = varargin{index+1};
    else
        axLabels = ["x_1","x_2","x_3"];
    end
    text(ax,x,y2+dy,z2+dz,axLabels(1))
    text(ax,x2+dx,y,z2+dz,axLabels(2))
    text(ax,x2+dx,y2+dy,z,axLabels(3))

    zq = 0:1:amountz;
    yq = 0:1:amounty;
    xq = 0:1:amountx;
    xv1=x*ones(amountx+1,1)-(xq*xrange/amountx)';
    yv1=y*ones(amounty+1,1)-(yq*yrange/amounty)';
    zv1=z*ones(amountz+1,1)-(zq*zrange/amountz)';
    xv1(sum((xv1==0),2)>0,:)=[];
    yv1(sum((yv1==0),2)>0,:)=[];
    zv1(sum((zv1==0),2)>0,:)=[];
    
    %Ticks
    [logic, index] = max(strcmp(varargin,'AxTicks'));
    if logic 
        axTicks = varargin{index+1};
    else
        axTicks{1} = num2cell(round((xv1-x2)*100)/100);
        axTicks{2} = num2cell(round((yv1-y2)*100)/100);
        axTicks{3} = num2cell(round((zv1-z2)*100)/100);
    end
    text(ax,xv1,  -y/offset*ones(numel(xv1),1)+y2,  -z/offset*ones(numel(xv1),1)+z2,axTicks{1});
    text(ax,-x/offset*ones(numel(yv1),1)+x2,  yv1, -z/offset*ones(numel(yv1),1)+z2, axTicks{2} );
    text(ax,-x/offset*ones(numel(zv1),1)+x2,  -y/offset*ones(numel(zv1),1)+y2,  zv1, axTicks{3});

    %axis
    [logic, ~] = max(strcmp(varargin,'Axes'));
    if ~logic 
        view(120,25);
    end

    [logic, ~] = max(strcmp(varargin,'Axes'));
    if ~logic 
        set(ax,'ylim',[y2 y+dy]);
        set(ax,'xlim',[x2 x+dx]);
        set(ax,'zlim',[z2 z+dz]);
    end
end