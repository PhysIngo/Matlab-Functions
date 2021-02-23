function varargout = calculateROI(varargin)
% CalculateROI by Ingo Hermann 2020-10-08
% This is calculates mask from an opened Figure with different options
% shown below
% --------------------------------
% This scripts needs the user functions:
% regiongrowing.m
% --------------------------------
% 'circle',radi ... segment a circle with given radii.
% 'Multi',num ... segment several times and increments the value for each new segment 
% 'points' ... segment a single point until you repeat one position
% 'limits',[lo up] ... bounderies for segmented area
% 'save' ... saves the segmentation in .mat

h = gcf;
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children');

imNo = 0;
% imgObj = dataObjs(2+imNo,1);
% if max(strcmp(varargin,'3D')) == 1
%     element = length(axesObjs);
% else
    element = length(dataObjs);
% end
imgObj = dataObjs(element,1);
graph = imgObj(end,1);
celler = graph(1,1);
nop = 0;
try
    img = celler{end,1};
catch
    warning('Problem using function.  Assigning a value of 0.');
    nop = 1;
end
if nop == 1
    mat = celler.CData;
else
    img = celler{end,1};
    mat = img.CData;
end
    
if isempty(varargin)
    varargin = 'empty';
end
[logic, index] = max(strcmp(varargin,'circle'));
if max(strcmp(varargin,'3D')) == 1
    element = length(axesObjs);
end

if max(strcmp(varargin,'Multi'))
    idx = 1 + find(strcmp(varargin,'Multi'));
    maskValue = varargin{1,idx};
else
    maskValue = 1;
end
multiMask = zeros(size(mat));
for multiCount = 1:1:maskValue
    if max(strcmp(varargin,'circle')) == 0 && max(strcmp(varargin,'points')) == 0
        polyH = impoly(axesObjs(element,1));
        position = wait(polyH);
        col_pos = (1:size(mat,1))';
        row_pos = 1:size(mat,2);
        xp = repmat(col_pos,size(mat,2),1);
        yp = repmat(row_pos,size(mat,1),1);
        yp = reshape(yp,size(mat,1)*size(mat,2),1);
        [in, on] = inpolygon(xp,yp,position(:,2),position(:,1));
        in = reshape(in,size(mat,1),size(mat,2));
        on = reshape(on,size(mat,1),size(mat,2));
        mask = in+on;
        mask(mask>0) = multiCount;
        delete(polyH);
%         if max(strcmp(varargin,'Poly'))
%             mask = position;
%         end
    elseif max(strcmp(varargin,'points')) == 1
        mask = zeros(size(mat));
        repeat = 0;
        oldpos = [0, 0];
        ccount = 1;
        while 1==1
            dcm_obj = datacursormode;
            set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
                'off','Enable','on')
            while(isempty(getCursorInfo(dcm_obj)))
                pause on
                pause(1);
            end
            obj = getCursorInfo(dcm_obj);
            pos = obj.Position;
            pos = round(pos);
            polyPos(ccount,:) = pos;
            ccount = ccount+1;
            set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
                'off','Enable','off')
            delete(findall(gcf,'Type','hggroup'));
            mask(pos(2),pos(1)) = multiCount;
            if oldpos(1)-pos(1) == 0 && oldpos(2)-pos(2) == 0
                break;
            else
                oldpos = pos;
            end
        end
        polyPos(end,:) = [];
        if max(strcmp(varargin,'Poly')) == 1
            mask = polyPos;
            multiMask = 0.*mask;
        end
    else
        dcm_obj = datacursormode;
        set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
            'off','Enable','on')
        while(isempty(getCursorInfo(dcm_obj)))
            pause on
            pause(1);
        end
        obj = getCursorInfo(dcm_obj);
        pos = obj.Position;
        set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
            'off','Enable','off')
        mask = zeros(size(mat));
        [logic, index] = max(strcmp(varargin,'circle'));
        radi = varargin{index+1};
        if radi<0
            radi = 0;
        end
        if radi>0
            mse = strel('sphere',radi).getnhood;
        %     se = strel('disk',radi,5);
            mmm = squeeze(mse(:,:,(size(mse,3)+1)/2));
        end
        mask(pos(2),pos(1)) = multiCount;
        if radi>0
            mask = imdilate(mask, mmm);
        end
        clf;
        imagesc(mat);
    end
    [logic, index] = max(strcmp(varargin,'limits'));
    if ~isempty(max(strcmp(varargin,'limits')))
        upperBound = inf;
        % here I changed it because it is easier :D
        lowerBound = -inf;
    else
        limits = varargin{index+1};
        lowerBound = limits(1);
        upperBound = limits(2);
    end
    multiMask = multiMask+mask;
    if max(strcmp(varargin,'Multi')) && max(strcmp(varargin,'Poly'))
        hold all;
        ps = position;ps(end+1,:) = position(1,:);
        plot(ps(:,1),ps(:,2),'linewidth',1.5);
    end
    
end
mask = multiMask;
str = '';
if (max(strcmp(varargin,'Poly')))==0 && max(strcmp(varargin,'Multi'))
    region = mat.*mask;
    region_vec = reshape(region(region~=0),[],1);

    mean_roi = mean(region_vec(region_vec>lowerBound & region_vec<upperBound) );
    std_roi = std(region_vec(region_vec>lowerBound & region_vec<upperBound) );
    str = sprintf('std: %0.3f \n mean: %0.3f',std_roi,mean_roi);
end
hold all;

if (max(strcmp(varargin,'circle')))==0 && (max(strcmp(varargin,'points')))==0 ...
        && (max(strcmp(varargin,'Multi')))==0 && (max(strcmp(varargin,'Poly')))==0
    imagesc(mat.*(mask+0.5)+mask*100000);
    plot([position(:,1)' position(1,1)],[position(:,2)' position(1,2)],...
        'LineWidth',1.5,'Color',[0.8 0.1 0.2]);
    if (max(strcmp(varargin,'Poly')))==0 && max(strcmp(varargin,'Multi'))
        text(position(end,1),position(end,2),str,'Color',[0.8 0.1 0.2]);
    end
elseif max(strcmp(varargin,'Poly'))
    if max(strcmp(varargin,'Multi'))
        
    else
        plot(multiMask(:,1),multiMask(:,2),'linewidth',1.5);
    end
elseif max(strcmp(varargin,'Multi'))
    imagesc(multiMask,[0 maskValue]);
else
    imagesc(mat.*(mask./2+0.5));
    text(pos(2),pos(1),str,'Color',[0.8 0.1 0.2]);
end
    

% choice = questdlg('Do you wanna save the roi?', ...
% 'Really', ...
% 'Yes','No','No');
% switch choice
%     case 'Yes'
%         [SaveName,currentfolder] = uiputfile('mask.mat','Save file name');
%         save(strcat(currentfolder,filesep,sprintf('%s',SaveName)),'-struct','Mask');
%     case 'No'
% end
mask_aorta.mask = mask;
if max(strcmp(varargin,'save'))
    [SaveName,currentfolder] = uiputfile('mask.mat','Save file name');
    save(strcat(currentfolder,filesep,sprintf('%s',SaveName)),'-struct','mask_aorta');
end
varargout{1} = mask;
end