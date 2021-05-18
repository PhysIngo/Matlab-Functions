function [output] = predictPatches(net,input,varargin)
% predictPatches by Ingo Hermann, 2021-05-18
% This functions predicts the neuronal net output if it was trained on
% patches as for Ingo's MRF Deep Learning reconstruction study
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp.: outputs = predictPatches(network,inputs,'dim',64);
%
% --- arguments ---
% output = predictPatches(net,input,...):
% net ... the trained network for predicting the patches
% input ... the input data 
% output ... the output data
%
% --- optional input arguments ---
% predictPatches(...,varargin):
% 'is3D' ... for 3D patches
% 'dim',outDim ... the dimension of the output image ([240 240 60 size(out,4)])
% 'slices',slc ... number of slices per patch (default: 16)
% 'patchSize',dim ... size of the patch in the 2D plane (default: 64)
%

if max(strcmp(varargin,'patchSize'))
    idx = 1 + find(strcmp(varargin,'patchSize'));
    dim = varargin{1,idx};
else
    dim = 64;
end


if max(strcmp(varargin,'is3D'))
    if max(strcmp(varargin,'slices'))
        idx = 1 + find(strcmp(varargin,'slices'));
        slc = varargin{1,idx};
    else
        slc = 16;
    end

    out = predict(net, input(1:dim,1:dim,1:slc,:) );
    if max(strcmp(varargin,'dim'))
        idx = 1 + find(strcmp(varargin,'dim'));
        outDim = varargin{1,idx};
    else
        outDim = [240 240 60 size(out,4)];
    end
    dimFac = size(input,1)-dim;
    dimFacSlc = size(input,3)-slc+1;

    cc = 1;offset=2;dimStep = 40;dimStepSlc = 11;offsetSlc=0;
    dimLen = ceil(dimFac/dimStep)+ceil(dimFacSlc/dimStepSlc);

    tmn = zeros(outDim(1),outDim(2),outDim(3),outDim(4),dimLen^2+1);
    for ci=1:dimStep:dimFac
        for cj=1:dimStep:dimFac
            for ck=1:dimStepSlc:dimFacSlc
%             parfor cc=1:ceil(dimFacSlc/dimStepSlc)
%                 ck = 1+(cc-1)*dimStepSlc;
             
                x = [0:dim-1]+ci;
                y = [0:dim-1]+cj;
                z = [0:slc-1]+ck;
                tmp = input(x,y,z,:);
                tmp2 = predict(net, tmp);

%                 tmn(:,:,:,:,cc) = ...
%                     tmp2(offset:end-offset,offset:end-offset,offsetSlc:end-offsetSlc,:);
                tmn(x(1+offset:end-offset),y(1+offset:end-offset),z(1+offsetSlc:end-offsetSlc),:,cc) = ...
                    tmp2(1+offset:end-offset,1+offset:end-offset,1+offsetSlc:end-offsetSlc,:);
                cc = cc+1;
            end

        end
    end
    %         tmp3 = median(tmn,4);
    tmp3 = meanzeros(tmn,5);
    im_pred = tmp3;

    output = im_pred;

    
else
    out = predict(net, input(1:dim,1:dim,:) );
    if max(strcmp(varargin,'dim'))
        idx = 1 + find(strcmp(varargin,'dim'));
        outDim = varargin{1,idx};
    else
        outDim = [240 240 size(out,3)];
    end
    dimFac = size(input,1)-dim;

    cc = 1;offset=10;dimStep = 24;dimLen = ceil(dimFac/dimStep);

    tmn = zeros(outDim(1),outDim(2),outDim(3),dimLen^2+1);
    for ci=1:dimStep:dimFac
        for cj=1:dimStep:dimFac
            x = [1:dim]+ci;
            y = [1:dim]+cj;
            tmp = input(x,y,:);
            tmp2 = predict(net, tmp);

            tmn(x(offset:end-offset),y(offset:end-offset),:,cc) = tmp2(offset:end-offset,offset:end-offset,:);
            cc = cc+1;

        end
    end
    %         tmp3 = median(tmn,4);
    tmp3 = meanzeros(tmn,4);
    im_pred = tmp3;

    output = im_pred;
end
