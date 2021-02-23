function denoiseImg = Denoising_Ingo(inputImg, varargin)
% Denoising_Ingo by Ingo Hermann, 2020-10-08
% This functions has a few different denoising strategies implemented
% --------------------------------
% This scripts needs the user functions:
% MPdenoising.m
%
% 'Gauss', 'Median', 'DeepL', 'MPPCA' ... are the different techniques
% 'Kernel',kernelVal ... gives the Kernel size for the filters
% 'Sigma',sigmaVal ... the Sigma for Gaussian filtering


    denoiseImg = zeros(size(inputImg));
    meas = size(inputImg,3);
    
    if max(strcmp(varargin,'Kernel'))
        idx = 1 + find(strcmp(varargin,'Kernel'));
        kernelVal = varargin{1,idx};
    else
        kernelVal = 3;
    end
    
    if max(strcmp(varargin,'Gauss'))
        if max(strcmp(varargin,'Sigma'))
        	idx = 1 + find(strcmp(varargin,'Sigma'));
        	sigmaVal = varargin{1,idx};
        else
            sigmaVal = 1;
        end
                
        fs = kernelVal;ff = (fs-1)/2;
        G = zeros(fs,fs);
        for i=-ff:1:ff
            for j=-ff:1:ff
                G(i+fs-ff,j+fs-ff) = 1/(2*pi*sigmaVal^2)*exp(-(i^2+j^2)/(2*sigmaVal^2));
            end
        end
        if sigmaVal ~= 0
            for i=1:1:meas
                denoiseImg(:,:,i) = inputImg(:,:,i);
                for ci=1+ff:1:size(inputImg,1)-ff
                    for cj=1+ff:1:size(inputImg,2)-ff
                        denoiseImg(ci,cj,i) = sum(sum(denoiseImg(ci-ff:ci+ff,cj-ff:cj+ff,i).*G(:,:)));
                    end
                end
            end
        else
            denoiseImg = inputImg;
        end
        fprintf('%s Finished with Gaussian Filter \n', datestr(now))
    elseif max(strcmp(varargin,'Median'))
        for i=1:1:meas
            denoiseImg(:,:,i) = medfilt2(squeeze(inputImg(:,:,i)), [kernelVal kernelVal]);
        end
        fprintf('%s Finished with Median Filter way \n', datestr(now))
    elseif max(strcmp(varargin,'DeepL'))
        net = denoisingNetwork('DnCNN');
        for i=1:1:meas
            tmpImg = inputImg(:,:,i);
            maxImg = max(tmpImg(:));
            noisyI = uint8(tmpImg./maxImg.*255);
            denoiseI = denoiseImage(noisyI,net);
            denoiseImg(:,:,i) = double(denoiseI).*maxImg./255;
        end
        fprintf('%s Finished with Deep Learning Filter \n', datestr(now))
    elseif max(strcmp(varargin,'MPPCA'))
        denoiseImg = MPdenoising(inputImg);
    else
        denoiseImg = inputImg;
    end
        
        
    
end

