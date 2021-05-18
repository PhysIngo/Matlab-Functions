function SuperimposeImagesc(img,mask,colorImg,colorMask,minImg,maxImg,varargin)
% SuperimposeImagesc by Ingo Hermann, 2021-05-18
% This function superimposes to images with colormaps. 
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp.: SuperimposeImagesc(img,mask,hot(64),jet(64),0,10,'Transparency',0.8);
%
% --- arguments ---
% SuperimposeImagesc(img,mask,colorImg,colorMask,minImg,maxImg,...):
% img ... is the input image
% mask ... is the binary input mask
% colorImg ... is the colormap of the image
% colorMask ... is the colormap of the mask
% minImg, maxImg ... are the min and max values of the image for imagesc
%
% --- optional input arguments ---
% SuperimposeImagesc(...,varargin):
% 'Axis', tmpAxis ... specifies the axis where it should be displayed
% 'noColorBar' ... deactivates the appearance of the colorbar
% 'Transparency', alphaFactor ... sepcifies the transparency of the overlay
% 'Title' ... sepcifies the Title of the plot
% 'YLabel' ... sepcifies the colorbar label
%


    if max(strcmp(varargin,'Axis'))
        idx = 1 + find(strcmp(varargin,'Axis'));
        tmpAx = varargin{1,idx};
        a1 = tmpAx(1,1);
    else
        a1 = axes;  
    end
    
    imagesc(a1, img);
    caxis(a1, [minImg maxImg]);
    colormap(a1,colorImg);
    if ~max(strcmp(varargin,'noColorBar'))
    colorbar(a1);
    end
    a1.Visible = 'off';
    axis(a1,'image');
    
    a2 = axes('position', get(a1, 'position'));
    
    mask(mask~=0) = 1;
    mask = abs(mask-1);
    img = img.*mask;
    h1 = imagesc(a2,img);
    caxis(a2, [minImg,maxImg]);
    colormap(a2,colorMask);
    
    if max(strcmp(varargin,'Transparency'))
        idx = 1 + find(strcmp(varargin,'Transparency'));
        alphaFactor = varargin{1,idx};
    else
        alphaFactor = 1;
    end
    alpha(h1, mask.*alphaFactor+(1-alphaFactor));
    axis(a2,'image');
        
    a2.Visible = 'off';
%     c1.Visible = 'off';
    
    
    if max(strcmp(varargin,'Title'))
        idx = 1 + find(strcmp(varargin,'Title'));
        titleString = varargin{1,idx};
        title(a2,titleString');
    end
    
    if max(strcmp(varargin,'YLabel'))
        idx = 1 + find(strcmp(varargin,'YLabel'));
        labelString = varargin{1,idx};
        ylabel(a2,labelString);
    end
    
end