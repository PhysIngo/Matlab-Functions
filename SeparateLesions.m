function [segment, varargout] = SeparateLesions(Lesions,varargin)
% SeparateLesions by Ingo Hermann 2020-10-08
% This functions separates Lesions or clusters in an image which are
% separated and asign increasing numbers.
% --------------------------------
% This scripts needs the user functions:
% - none -
%
% This is a function, which uses a watershed in 3D to label the single
% lesions in a 3D data set. The input 'Lesions' shoud be a 3D matrix.
% 'Precission' ... how precise the segmentation shoud be
% 'Plot' ... plots the label lesions in a Mosaic manner
% '3D' ... representation of Lesion in 3D
% 'Calculate*' ... calculates the min,max,mean,std and amount of ms lesions
    Mask = Lesions;
    Mask(Mask>0) = 1;
    D = bwdist(~Mask);
    D = -D;
    D(~Mask) = Inf;
    ShedPrec = 1;
    if max(strcmp(varargin,'Precission'))
        idx = 1 + find(strcmp(varargin,'Precission'));
        ShedPrec = varargin{1,idx};
    end
    D1 = imhmin(D,ShedPrec,26);
    L = watershed(D1,26);
    L(~Mask) = 0;
    segment = L;
    LesNum = unique(L(:));
    newCount = 1;
    for diffLes=1:1:numel(LesNum)-1
        tmp = L(L==newCount); 
%         fprintf(['n: ',num2str(newCount),' len: ',num2str(numel(tmp(:))),'\n']);
        if numel(tmp(:))<10
            L(L==newCount) = 0;
            L(L>newCount) = L(L>newCount)-1;
        else
            newCount = newCount + 1;
        end
    end
    LesNum = unique(L(:));
%     for diffLes=1:1:numel(LesNum)-1
%         tmp = L(L==diffLes); 
%     end
    
    for diffLes=1:1:numel(LesNum)-1
        tmp = Lesions(L==LesNum(diffLes));
        t(1) = min(tmp(:));
        t(2) = max(tmp(:));
        [t(3),t(4)] = meanzeros(tmp(:),1);
        t(5) = numel(tmp(:));
        tmpL = L;
        tmpL(tmpL~=LesNum(diffLes)) = 0;
        [~,rows] = find(tmpL);
        
%         slcs = [];
%         for finder=1:1:size(cols,1)
%             [~,slcs(finder)] = find(squeeze(tmpL(cols(finder),rows(finder),:)));
% %             slcs(finder) = tmpslcs;
%         end
        t(6) = mean(mod(rows,60));
        AllLesion(diffLes,1) = t(1);
        AllLesion(diffLes,2) = t(2);
        AllLesion(diffLes,3) = t(3);
        AllLesion(diffLes,4) = t(4);
        AllLesion(diffLes,5) = t(5);
        AllLesion(diffLes,6) = t(6);
        if max(strcmp(varargin,'Calculate*'))
            fprintf('Lesion %d: min: %0.2f, max: %0.2f, mean: %0.2f, std: %0.2f,pixels: %0.2f,slice: %0.2f,\n',...
            diffLes,t(1),t(2),t(3),t(4),t(5),t(6) );
        end
    end
    
    if max(strcmp(varargin,'Plot'))
        myMap = colormap(myColorMap('Matlab','interp',numel(LesNum)) );
        myMap(1,:) = zeros(3,1);
        dim = size(L,3);
        figure;imagesc(MosaicOnOff(L,dim));colormap(myMap);axis off;
    end
    if max(strcmp(varargin,'3D'))
        figure;
        [x,y,z] = meshgrid(1:240,1:240,1:60);
        h = slice(x,y,z,double(L),[],1:240,[]);
        set(h,'EdgeColor','none');
        alpha('color');
        alphamap([0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
        colormap(myColorMap('Matlab','interp',numel(LesNum)) );
        axis off;caxis([0 numel(LesNum)]);

        view([-35,50]);
    end
    if ~exist('AllLesion')
        AllLesion = zeros(1,6);
    end
    varargout{1} = AllLesion;
    segment = L;
end