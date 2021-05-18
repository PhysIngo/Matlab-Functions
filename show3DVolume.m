function show3DVolume(input,varargin)
% show3DVolume by Ingo Hermann 2021-05-18
% This functions shows a 3D vloume at a specific cut
% --------------------------------
% This script needs the user functions:
% myColorMap.m
%
% Exp.: show3DVolume(im_true(:,:,:,i),'Treshold',10,'Precision',5,'Max',250);
%
% --- arguments ---
% show3DVolume(image3D,'Treshold',10,'Precision',5,'Max',250);
% image3D ... specifies the 3D input image
%
% --- optional input arguments ---
% show3DVolume(...,varargin)
% 'Treshold',tresh ... for the mask (Default: mean of input)
% 'Center',center ... center of the quarter which is cutted out (Default:
% [150,150,30])
% 'Colormap,cmap ... specify the colormap here (Default: spring(64))
% 'View',dview ... specify the 3D view (Default: [-30,30]);
% 'Precision',prec ... precision of the model, as many slices are shown
% (Default: 1)
% 'Max',maxVal ... max Value to which it is limited (Default: max of input)
% 



% show3DVolume(im_true(:,:,:,i),'Treshold',10,'Precision',5,'Max',250);

    sz = size(input);
    if max(strcmp(varargin,'Center'))
        [~, index] = max(strcmp(varargin,'Center'));
        center = varargin{index+1};
    else
        center = [150,150,30];
    end
    
    if max(strcmp(varargin,'Treshold'))
        [~, index] = max(strcmp(varargin,'Treshold'));
        tresh = varargin{index+1};
    else
        tresh = mean(input(:));
    end
    
    if max(strcmp(varargin,'Colormap'))
        [~, index] = max(strcmp(varargin,'Colormap'));
        cmap = varargin{index+1};
        FaceClr = 'interp';theAlpha = 1;
    else
        cmap = spring(64);
        FaceClr = [0.7 0.7 0.7];theAlpha = 0.1;
    end
    
    if max(strcmp(varargin,'View'))
        [~, index] = max(strcmp(varargin,'View'));
        dview = varargin{index+1};
    else
        dview = [-30,30];
    end
    
    if max(strcmp(varargin,'Precision'))
        [~, index] = max(strcmp(varargin,'Precision'));
        prec = varargin{index+1};
    else
        prec = 1;
    end
    fac = ceil(mean([sz(1) sz(2)])/sz(3));
    if max(strcmp(varargin,'Max'))
        [~, index] = max(strcmp(varargin,'Max'));
        maxVal = varargin{index+1};
    else
        maxVal = max(input(:));
    end
%     linput = input;
%     input(1:center(1),1:center(2),center(3):end) = input(1:center(1),1:center(2),center(3):end).*0;

    v = input;
    [x,y,z] = meshgrid(1:sz(1),1:sz(2),1:sz(3));
    
    [xq,yq,zq] = meshgrid(1:sz(1),1:sz(2),1:sz(3));
    vq = interp3(x,y,z,v,xq,yq,zq);
    vq(vq>maxVal) = maxVal;
    hold all;
    
    vq3=vq;vq3(center(1):end,:,:) = 0;%vq3(:,:,1:center(3)) = 0;
    h3 = slice(xq,yq,zq,vq3,center(1):prec*fac:sz(1),[],[]);
    set(h3,'EdgeColor','none',...
        'FaceColor','interp',...
        'FaceAlpha','interp');
    
    vq2=vq;%vq2(:,:,1:center(3)-1) = 0;
    h2 = slice(xq,yq,zq,vq2,[],center(2):prec*fac:sz(2),[]);
    set(h2,'EdgeColor','none',...
        'FaceColor','interp',...
        'FaceAlpha','interp');
    
    vq1=vq;vq1(:,:,center(3)+1:end) = 0;vq1(center(1):end,:,:) = 0;vq1(:,center(2):end,:) = 0;
    h1 = slice(xq,yq,zq,vq1,[],[],1:prec:center(3));
    set(h1,'EdgeColor','none',...
        'FaceColor','interp',...
        'FaceAlpha','interp');
    
    alpha('color');
    alphamap([0 1 1 1 1 1 1 1 1 1 1 1 1 1]);
%     alphamap('rampup');alphamap('decrease',0.1);
    colormap(myColorMap());axis off;caxis([0 maxVal]);

    view([-35,50]);

    view(dview(1),dview(2))
    daspect([1 1 0.3])                            
    axis tight;
%     camlight(40,40)                                % create two lights 
%     camlight(-20,-10)
%     lighting gouraud

end