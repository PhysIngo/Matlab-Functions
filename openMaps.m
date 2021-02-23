function [imageData, varargout] = openMaps(name, varargin)
% openMaps by Ingo Hermann 2020-10-08
% This functions opens everything from Dicoms to Niftis with very nice
% options so its is easy to load entire folders or specific files
% --------------------------------
% This scripts needs the user functions:
% MosaicOnOff.m
%
% function [imageData, varargout] = openMaps(name, varargin)
% imageData ... output matrix data
% varargout ... the tmpHeader with all header informations
% name ... folder and file name as one string
% 'num' ... position of file in the folder to open
% 'all' ... will load all files in the folder in an array
% 'show' ... will show the loaded image but just if it's not 'all'
% '3D' ... makes 3D data 2D.
% 'Column',Column ... if data is not rectangular you have to giv ethe
% column dimension
% this function need the function MosaicOnOff();
if isempty(varargin)
    varargin{1} = '';
end
if contains(name,'*')
    [logic, index] = max(strcmp(varargin,'num'));
    folder = char(name);
    folder(end) = [];
    substr = dir(folder);
    cc = 1;
    for i=1:length(substr)
        idx(i) = substr(i).isdir;
        if idx(i)==0
            names{cc} = strcat(folder,substr(i).name);
            name = strcat(folder,substr(i).name);
            cc = cc+1;
        end
    end
    if logic 
        names = [];
        if ~isempty(varargin{index+1})
            names{1,1} = strcat(folder,substr((varargin{index+1})+2).name);
        elseif length(substr) > 1
            names{1,1} = strcat(folder,substr(3).name);
        else
            names{1,1} = strcat(folder,substr(1).name);
        end
            
    end
end
if exist(name) == 0
   error('Folder or file not existing!')
   return;
end

stte = 'false';
try
    tmpHeader = dicominfo(name);
    dicomIMA = fileread([name]);
    delimiters = strfind(dicomIMA,'###');
    theIMA = dicomIMA(delimiters(2)+4:delimiters(3)-2);
    if contains(theIMA(1:7),'ASCCONV')
        dicomIMA = dicomIMA(delimiters(3)+4:delimiters(4)-2);
    else
        if contains(theIMA,'<ParamBool')
            theIMA = dicomIMA(delimiters(4)+4:delimiters(5)-2);
            dicomIMA = theIMA;
        else
            dicomIMA = theIMA;
        end
    end
        
    adout{1} = imaTimes(dicomIMA);
    dicomIMAs{1} = dicomIMA;
catch ME
    if (strcmp(ME.identifier,'images:dicominfo:notDICOM')) %|| (strcmp(ME.identifier,'MATLAB:badsubscript'))
        msg = ['No Dicom file!'];
        causeException = MException('images:dicominfo:fileNotFound',msg);
        ME = addCause(ME,causeException);
        stte = 'true';
    else
        stte = 'false';
    end
%     rethrow(ME);
end
if contains(name,'.jpg') || contains(name,'.fig')
    stte = 'normal';
elseif contains(name,'.mat')
    stte = 'matrix';
elseif contains(name,'.nii')
    stte = 'nifti';
end 
% if ~isempty(tmpHeader)
%     stte = 'false';
% end 
fid = fopen(name, 'r');
tmpHeader.SeriesDescription = 'not found!'; 
if strcmp(stte,'true')
    if max(strcmp(varargin,'all'))
        elements = length(substr)-2;
    else
        elements = 1;
    end
    for i=1:1:elements
        if exist('names')
            fid = fopen(names{i}, 'r');
        else
            fid = fopen(name, 'r');
        end
        rawColumn = fread(fid, 'uint16');
        fclose(fid);
        dimLen = int64(sqrt(size(rawColumn,1)));
        
        [logic, index] = max(strcmp(varargin,'Column'));
        
        if dimLen^2~=size(rawColumn,1) && logic~= 1
           error('Your image is not rectangular, please give the column number as ''Column'',Columnumber')
           return;
        end
        
        if logic==1
            dimLen = varargin{index+1};
        end
        rawImage = reshape(rawColumn, dimLen, []);
        imageData(:,:,i) = double(transpose(rawImage));
        
        try
            tmpHeader(i,1) = dicominfo(names{i});
            imageData(:,:,i) = dicomread(dinfo);
        catch
            tmpHeader(i,1).SeriesDescription = 'not found!';
            try
                tmpHeader(i,1).Names = names{i};
            catch
                tmpHeader(i,1).Names = 'noName';
            end
        end
    end
    squeeze(imageData);
elseif strcmp(stte,'normal')
    imageData(:,:) = imread(name);
elseif strcmp(stte,'matrix')
    inputStruct = load(name);
    if isfield(inputStruct,'T1Map')
        imageData(:,:) = inputStruct.T1Map;
    elseif isfield(inputStruct,'t1Map')
        imageData(:,:) = inputStruct.t1Map;
    elseif isfield(inputStruct,'a')
        imageData(:,:) = inputStruct.a.T1Map;
    else
        if isstruct(inputStruct)
%             idx = 1 + find(strcmp(varargin,'Struct'));
%             structString = varargin{1,idx};
        prompt = {'Enter the struct name'};
        dlgtitle = 'Struct Name';
        answer = inputdlg(prompt,dlgtitle);
        structString = answer{1,1};
    %         nField = fieldnames(inputStruct);
    %         eval(['imageData(:,:) = inputStruct.',nField{1},';']);
            eval(['imageData(:,:) = inputStruct.',structString,';']);
        else
            imageData(:,:) = inputStruct;
        end
    end
elseif strcmp(stte,'nifti')
    imageData = niftiread(name);
    tmpHeader = struct('PatientSex','X','PatientAge',0);
    try 
        tmpHeader = niftiinfo(name);
    end
%     try
%         is3D = ((size(imageData,3) > 1) && max(strcmp(varargin,'3D')) );
%     catch ME
%         is3D = true;
%         varargin{end+1} = '3D';
%         fprintf('The loaded files are 3D so we Mosaic it\n');
%         
%     end
    if ((size(imageData,3) > 1) && max(strcmp(varargin,'3D')) )
        imageData = MosaicOnOff(imageData,size(imageData,3));
    end
else
%     tmpHeader = dicominfo(name);
%     if isempty(tmpHeader)
%         tmpHeader(i,1).SeriesDescription = 'not found!';
%         tmpHeader(i,1).Names = names{i};
%     end
    clear tmpHeader;
    if max(strcmp(varargin,'all'))
        elements = length(names);
    else
        elements = 1;
    end
    for i=1:1:elements
        if exist('names')
            if ( max(strcmp(varargin,'uint16')) )
                tmpImg = dicomread(names{i} ) ;
            else
                tmpImg = squeeze(double(dicomread(names{i} ))) ;
            end
            if ((size(tmpImg,3) > 1) && max(strcmp(varargin,'3D')) )
                imageData(:,:,i) = MosaicOnOff(tmpImg,size(tmpImg,3));
            else
                if ( max(strcmp(varargin,'uint16')) )
                    imageData(:,:,i) = dicomread(names{i} ) ;
                else
                    imageData(:,:,i) = double(dicomread(names{i} )) ;
                end
            end
            try 
                tmpStruct = dicominfo(names{i});
                if isfield(tmpStruct,'Private_0051_1011')
                    tmpStruct = rmfield(tmpStruct,'Private_0051_1011');
                end
                tmpHeader(i,1) = tmpStruct;
            catch
                tmpHeader = 1;
            end
            
            dicomIMA = fileread([names{i}]);
            delimiters = strfind(dicomIMA,'###');
            try
                theIMA = dicomIMA(delimiters(2)+4:delimiters(3)-2);
                if contains(theIMA(1:7),'ASCCONV')
                    dicomIMA = dicomIMA(delimiters(3)+4:delimiters(4)-2);
                else
                    if contains(theIMA,'<ParamBool')
                        theIMA = dicomIMA(delimiters(4)+4:delimiters(5)-2);
                        dicomIMA = theIMA;
                    else
                        dicomIMA = theIMA;
                    end
                end

                adout{i} = imaTimes(dicomIMA);
                dicomIMAs{i} = dicomIMA;
            catch
                dicomIMA = [];
                adout = [];
                dicomIMAs{i} = dicomIMA;
                warning('Problem using function.  Assigning a value of empty');
            end
        else
            if ( max(strcmp(varargin,'uint16')) )
                tmpImg = dicomread(name) ;
            else
                tmpImg = squeeze(double(dicomread(name))) ;
            end
            if ((size(tmpImg,3) > 1) && max(strcmp(varargin,'3D')) )
                imageData(:,:,i) = MosaicOnOff(tmpImg,size(tmpImg,3));
            elseif (size(tmpImg,3) > 1)
                if ( max(strcmp(varargin,'uint16')) )
                    imageData = dicomread(name); 
                else
                    imageData = double(dicomread(name)) ; 
                end
            else
                if ( max(strcmp(varargin,'uint16')) )
                    imageData(:,:) = dicomread(name) ; 
                else
                    imageData = double(dicomread(name)) ; 
                end
            end
            tmpHeader(1,1) = dicominfo(name);
        end
    end
end

[logic, index] = max(strcmp(varargin,'Rotate'));
if (size(imageData,3) > 1) && ( max(strcmp(varargin,'Rotate')) )
    for rot = 1:1:size(imageData,3)
        tmpImageData(:,:,rot) = imrotate(imageData(:,:,rot),varargin{index+1});
    end
    imageData = tmpImageData;%MosaicOnOff(tmpImageData,size(imageData,3));
end
[logic, index] = max(strcmp(varargin,'Flip'));
if (size(imageData,3) > 1) && ( max(strcmp(varargin,'Flip')) )
    for flip = 1:1:size(imageData,3)
        tmpImageData(:,:,flip) = imageData(:,end:-1:1,flip);
    end
    imageData = tmpImageData;%MosaicOnOff(tmpImageData,size(imageData,3));
end
if max(strcmp(varargin,'nifti'))
    if (size(imageData,4) > 1)
%         for rot = 1:1:size(imageData,4)
            tmpImageData = imrotate(imageData,90);
%         end
        imageData = tmpImageData;
    elseif (size(imageData,3) > 1)
        for rot = 1:1:size(imageData,3)
            tmpImageData(:,:,rot) = imrotate(imageData(:,:,rot),90);
        end
        imageData = tmpImageData;
    else
        imageData = imrotate(imageData,90);
    end
end

if max(strcmp(varargin,'Mosaic')) 
    imageData = MosaicOnOff(imageData,size(imageData,3));
end

varargout{1} = tmpHeader;
if exist('dicomIMAs','var')
    varargout{2} = dicomIMAs;
    varargout{3} = adout;    
end
if max(strcmp(varargin,'show'))
    h = gcf;
    h = figure;
    imagesc(imageData,[0 3000]);colormap(myColorMap('CMRT1'));colorbar;
    title(tmpHeader.SeriesDescription,'Interpreter','none');
end

end



% --- Executes on button press in ima_times.
function Output = imaTimes(dicomIMA)

ASCCFieldsNew = textscan(dicomIMA,'%s %s %s');
ASCCFields{1,1} = ASCCFieldsNew{1,1};
ASCCFields{1,2} = ASCCFieldsNew{1,3};

    
% Read AlFree
theName = 'sWipMemBlock.alFree';
alFree = zeros( getCellValueByName(ASCCFields, [theName,'.__attribute__.size'], 'numeric') , 1);

[vals,names] = getCellValueByName(ASCCFields, theName, 'numeric');
rmInd = strcmp(names,[theName,'.__attribute__.size']);
vals(rmInd) = [];
names(rmInd) = [];
alFree = vals;
alFreeName = names;


% Read AdFree
theName = 'sWipMemBlock.adFree';
adFree = zeros( getCellValueByName(ASCCFields, [theName,'.__attribute__.size'],'numeric') , 1);

[vals,names] = getCellValueByName(ASCCFields, theName, 'numeric');
rmInd = strcmp(names,[theName,'.__attribute__.size']);
vals(rmInd) = [];
names(rmInd) = [];

adFree = vals;
adFreeName = names;

% Read alTE
theName = 'alTE';
[vals,names] = getCellValueByName(ASCCFields, theName, 'numeric');
alTE = vals;
alTEName = names;

% Read scantime
theName = 'lTotalScanTime';
[vals,names] = getCellValueByName(ASCCFields, theName, 'numeric');
scanTime = vals;

% Read lSegments
theName = 'lSegments';
[vals,names] = getCellValueByName(ASCCFields, theName, 'numeric');
lSegments = vals;


Output.alFree = alFree;
Output.alFreeName = alFreeName;
Output.adFree = adFree;
Output.adFreeName = adFreeName;
Output.alTE = alTE;
Output.alTEName = alTEName;

Output.scanTime = scanTime;
Output.lSegments = lSegments;

end


function [val, names] = getCellValueByName(ASCCFields,fieldName,varargin)

    if ( (nargin >= 3) && strncmpi(varargin{1},'numeric',7) )
        convertFun = @str2double;
    else
        convertFun = @(x) x;
    end

    findInd = ~cellfun(@isempty,strfind(ASCCFields{1},fieldName));
    val = convertFun(ASCCFields{2}( findInd ));
    names = ASCCFields{1}( findInd );
    
end