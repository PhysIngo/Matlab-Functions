function DrawLesions(mask,varargin)
% DrawLesions by Ingo Hermann, 2021-05-18
% This function draws lesions based on the mask given in mask
% --------------------------------
% This script needs the user functions:
% - SeparateLesions.m
% - mask2poly.h 
%
% Exp.: DrawLesions(mask,'Color',[0 0.4 0.74]);
%
% --- arguments ---
% DrawLesions(mask,...):
% mask ... input mask for drawing the lesions
%
% --- optional input arguments ---
% DrawLesions(...,varargin):
% 'Color',clrs ... specifies the color of the polyplot 
% (Default: [0 0.4 0.74]);
% 'Smooth',smoothFac ... smooth factor for smoothing the polygon 
% (Default: 0.1)
%

[logic, index] = max(strcmp(varargin,'Color'));
if logic
    clrs = varargin{index+1};
else
    clrs = [0 0.4 0.74];		% ms.
end

[logic, index] = max(strcmp(varargin,'Smooth'));
if logic
    smoothFac = varargin{index+1};
else
    smoothFac = 0.1;		% ms.
end

hold on;
LesionKE = SeparateLesions(squeeze(mask),'Precission',2);
for k=1:1:max(unique(LesionKE(:)))
    polyLes = (mask2poly(LesionKE==k,'Exact'));
%     polyLes(1,:) = polyLes(end,1);
    polyLes2 = [polyLes; polyLes; polyLes];
    polyLes2(:,1) = smooth(polyLes2(:,1),smoothFac,'rloess');
    polyLes2(:,2) = smooth(polyLes2(:,2),smoothFac,'rloess');
    polyLes(:,:) = polyLes2(1+size(polyLes,1):2*size(polyLes,1),:);
    polyLes(end+1,:) = polyLes(1,:);
    polyLes(end+1,:) = polyLes(2,:);
    plot(polyLes(2:end,1),polyLes(2:end,2),...
        'linewidth',1.0,'Color',clrs);
end
axis off;axis image;%gca.YDir = 'reverse';
legend('hide');
