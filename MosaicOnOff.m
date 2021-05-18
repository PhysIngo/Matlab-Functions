function varargout = MosaicOnOff(img,slices,varargin)
% MosaicOnOff by Ingo Hermann 2021-05-18
% Input has to be either a 2D images as Mosaic or 3D as no Mosaic. This
% function will transform from Mosaic to non Mosaic and the other way
% around. 
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp:. MosaicImg = MosaicOnOff(Image3D,Slices);
%
% --- arguments ---
% MosaicOnOff(img,slices,...):
% img ... input images as 3D (non-mosaic) or 2D (mosaic)
% slices ... input number of how many slices
% 
% --- optional input arguments ---
% MosaicOnOff(...,varargin):
% 'Permute' ... performs [2:2:slices 1:2:slices] permutation
% 'Dimension',dim ... Makes the Mosaic only as a row (dim=1) or col (dim=2)
% 'Rows',MosaicWidth ... Makes the Mosaic with the specific number of rows
%
% --- optional input arguments ---
% mask = MosaicOnOff(...):
% mask ... output mask of the function
%

img = squeeze(img);
sz = size(img);

if numel(sz) == 2
    % make a many single images out of it
    if ~exist('slices')
        warning('Please give the number of slices! Nothing changed');
        newImage = img;
    else
        MosaicWidth = ceil(sqrt(slices));
        colSize = sz(1)/MosaicWidth;
        rowSize = sz(2)/MosaicWidth;
        newImage = zeros(colSize,rowSize,slices);
        if max(strcmp(varargin,'Permute'))
            prmt = [2:2:slices 1:2:slices];
        else
            prmt = 1:slices;
        end
        for col = 1:1:MosaicWidth
            for row = 1:1:MosaicWidth
                slc = row+(col-1)*MosaicWidth;
                if slc>slices
                    continue;
                end
                newImage(:,:,prmt(slc)) = (img(1+colSize*(col-1):colSize*col,...
                    1+rowSize*(row-1):rowSize*row));
            end
        end
    end
elseif numel(sz) == 3
    % make mosaic img
    if ~exist('slices')
        slices = sz(3);
        warning(['You gave no slice number, so we assume: ',num2str(slices),' slices!']);
    else
        varargin = [ { slices }, varargin ];
        slices = sz(3);         
    end
    
    
    [logic, index] = max(strcmp(varargin,'Dimension'));
    if logic
        dim = varargin{index+1};
    else
        dim = 0;		% ms.
    end

    if dim == 1
        newImage = reshape(img,sz(1),[]);
    elseif dim == 2
        newImage = reshape(img,sz(2),[]);
    else
        rowSize = sz(2);
        colSize = sz(1);
        
        [logic, index] = max(strcmp(varargin,'Rows'));
        if logic
            MosaicWidth = varargin{index+1};
            MosaicHeight = slices/MosaicWidth;
            if (MosaicHeight-round(MosaicHeight,0) )~=0
                warning(['The number of rows and cols is not dividable!']);
                MosaicWidth = ceil(sqrt(slices));
                MosaicHeight = MosaicWidth;
            end
        else
            MosaicWidth = ceil(sqrt(slices));
            MosaicHeight = MosaicWidth;
        end  
        newImage = zeros(colSize*MosaicHeight,rowSize*MosaicWidth);
        for col = 1:1:MosaicHeight
            for row = 1:1:MosaicWidth
                slc = row+(col-1)*MosaicWidth;
                if slc>slices
                    continue;
                end
                newImage(1+colSize*(col-1):colSize*col,...
                    1+rowSize*(row-1):rowSize*row) = ...
                    (img(1:colSize,1:rowSize,slc));
            end
        end
    end    
end
varargout{1} = newImage;


end