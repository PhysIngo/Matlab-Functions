function arrow3D(startVec,stopVec,varargin)
% Input arguments:
% startVec ... input vector of the beginning of the point in [x,y,z]
% stopVec ... input vector of the ending of the point in [x,y,z]
%
% Optional input argument (varargin):
% 'Color',color ... define the color of the arrow/point
% 'Thickness',thick ... thickness of the arrow
% 'Length',length ... Length of the arrow
% 'Axes',ax ... Input axes

    if isempty(varargin)
        varargin{1} = '';
    end
    
    [x] = startVec(1); 
    [y] = startVec(2); 
    [z] = startVec(3); 
    x2 = stopVec(1);
    y2 = stopVec(2);
    z2 = stopVec(3);
    
    [logic, index] = max(strcmp(varargin,'Length'));
    if logic
        length = varargin{index+1};
    else
        length = mean(abs(stopVec-startVec))/10;
    end
    
    [logic, index] = max(strcmp(varargin,'Axes'));
    if logic
        ax = varargin{index+1};
    else
        ax = gca;
    end
    
    [logic, index] = max(strcmp(varargin,'Thickness'));
    if logic
        thick = varargin{index+1};
    else
        thick = mean(abs(stopVec-startVec))/10;
    end
    
    [logic, index] = max(strcmp(varargin,'Color'));
    if logic
        color = varargin{index+1};
    else
        color = [0 0 0];
    end
    
    vector2=[x2;y2;z2];
    vector1=[x;y;z];
    vector21=[x2-x;y2-y;z2-z];

    u1=[x2-x;y2-y;z2-z];
    u1=1/norm(u1)*u1;
    u2=[1;0;0];
    val=u1(1,1);
    abstand=u1-val*u2;
    if abstand==zeros(3,1)
        u2=[0;1;0];
    end
    
    %Kreuzprodukt
    u3(1,1)=u1(2,1)*u2(3,1)-u1(3,1)*u2(2,1);
    u3(2,1)=u1(3,1)*u2(1,1)-u1(1,1)*u2(3,1);
    u3(3,1)=u1(1,1)*u2(2,1)-u1(2,1)*u2(1,1);
    u3=1/norm(u3)*u3;
    %
    u2(1,1)=u1(2,1)*u3(3,1)-u1(3,1)*u3(2,1);
    u2(2,1)=u1(3,1)*u3(1,1)-u1(1,1)*u3(3,1);
    u2(3,1)=u1(1,1)*u3(2,1)-u1(2,1)*u3(1,1);
    u2=1/norm(u2)*u2;
    %orthnormale vektoren
    v1=u2;
    v2=u3;
    step=pi/50;
    a = step:step:2*pi;
    er=vector2;
    Er=repmat(er,1,numel(a));
    zerx=(Er(1,:))';
    zery=(Er(2,:))';
    zerz=(Er(3,:))';

    vectorscale=(1-length)*vector21;
    grund=(v1*sin(a)+v2*cos(a))*norm(vector2'-vector1')/3*thick;
    VS=repmat(vectorscale+vector1,1,numel(a));
    grund=grund+VS;

    xspitz=[zerx';grund(1,:)];
    yspitz=[zery';grund(2,:)];
    zspitz=[zerz';grund(3,:)];

    xrep=reshape(xspitz,1,2*numel(a))';
    yrep=reshape(yspitz,1,2*numel(a))';
    zrep=reshape(zspitz,1,2*numel(a))';

    plot3(ax, xrep, yrep, zrep, 'Color', color);
end