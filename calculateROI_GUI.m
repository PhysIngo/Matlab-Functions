function varargout = calculateROI_GUI(varargin)
% calculateROI_GUI by Ingo Hermann 2021-05-18
% This is a GUI function with that it is very easy to segment stuff and so
% on. Several options are implemented and this is a addon to the function
% calculateROI.m which only is doing it on an opened Figure
% --------------------------------
% This script needs the user functions:
% openMaps.m
% MosaicOnOff.m
% myColorMap.m
% regiongrowing.m
% 
% open the GUI function with:
% calculateROI_GUI
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calculateROI_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @calculateROI_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before calculateROI_GUI is made visible.
function calculateROI_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calculateROI_GUI (see VARARGIN)

% Choose default command line output for calculateROI_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using calculateROI_GUI.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

set(gcf,'CurrentAxes',handles.figAx);
imagesc(0);
myMap = gray(200);
colormap(handles.figAx,myMap);
axis off;
axis image;

set(gcf,'CurrentAxes',handles.figAx2);
imagesc(0);
colormap(handles.figAx2,myMap);
axis off;
axis image;


% UIWAIT makes calculateROI_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calculateROI_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)




% --- Executes on selection change in Method.
function Method_Callback(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Method


% --- Executes during object creation, after setting all properties.
function Method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function minVal_Callback(hObject, eventdata, handles)

showImages(handles)

% --- Executes during object creation, after setting all properties.
function minVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxVal_Callback(hObject, eventdata, handles)

showImages(handles)

% --- Executes during object creation, after setting all properties.
function maxVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SegmentNumber_Callback(hObject, eventdata, handles)

    SegmentNumber = str2double(get(handles.SegmentNumber,'String'));
    ROINumber = str2double(get(handles.ROINumber,'String'));
    Map = handles.Map;
    allMasks = handles.allMasks; 
    actualSlice = get(handles.MultipleSlices,'Value')+1;
    SaveMask = allMasks(:,:,actualSlice);        
    
    tmpImg = Map(SaveMask==SegmentNumber);
    MeanVal = round(mean(tmpImg(:)),1);
    StdVal = round(std(tmpImg(:)),1);
    
    set(handles.MeanVal,'String',num2str(MeanVal) );
    set(handles.StdVal,'String',num2str(StdVal) );

% --- Executes during object creation, after setting all properties.
function SegmentNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SegmentNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Delete.
function Delete_Callback(hObject, eventdata, handles)





function ROINumber_Callback(hObject, eventdata, handles)
% hObject    handle to ROINumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROINumber as text
%        str2double(get(hObject,'String')) returns contents of ROINumber as a double


% --- Executes during object creation, after setting all properties.
function ROINumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROINumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)

    persistent lastPath pathName
    % If this is the first time running the function this session,
    % Initialize lastPath to 0
    if isempty(lastPath) 
        lastPath = 0;
    end
    % First time calling 'uigetfile', use the pwd
    if lastPath == 0
        [FileName,pathName,FilterIndex] = uigetfile(...
        '*.*',  'All Files (*.*)', ...
        'Pick a file', ...
        'MultiSelect', 'on');

    % All subsequent calls, use the path to the last selected file
    else
        [FileName,pathName,FilterIndex] = uigetfile(...
        {'*.*',  'All Files (*.*)'}, ...
        'Pick a file', ...
        lastPath, 'MultiSelect', 'on' );
    end
    % Use the path to the last selected file
    % If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
    if pathName ~= 0
        lastPath = pathName;
    end
    
    PathName = pathName;

    

%     if isnumeric(folder)
%         return;
%     end
    set(handles.SegmentNumber,'String','1');
    set(handles.ActualSliceNumber,'String','1');
    set(handles.resizeFac,'String',1);
    set(handles.MultipleSlices,'Max',1)
    set(handles.MultipleSlices,'Min',0)
    set(handles.MapFolder,'String',[PathName,FileName]);
    actualSlice = 1;
    if iscell(FileName)
        Slices = length(FileName);
        set(handles.MultipleSlices,'Max',Slices-1)
        set(handles.MultipleSlices,'Min',0)
        set(handles.ActualSliceNumber,'String','1');
        set(handles.MultipleSlices,'SliderStep',[1/(Slices-1) 1/(Slices-1)])
        set(handles.MaxSlices,'String',['/ ',num2str(Slices)]);
        [allMaps, heads] = openMaps([PathName,'\*'],'all');
        allMasks = zeros(size(allMaps));
%         Map = openMaps([PathName,'\*'],'number',actualSlice);
        handles.Slices = Slices;
        handles.actualSlice = actualSlice;
        for i=1:1:length(heads)
            sliceLoc(i) = heads(i).SliceLocation;
        end
        [~, idx] = sort(sliceLoc,'ascend');
        handles.allMaps = allMaps(:,:,idx);
        allMaps = handles.allMaps;
        Map = allMaps(:,:,actualSlice);
        handles.allMasks = allMasks;
    else
        Slices = 1;
        set(handles.MaxSlices,'String','/ 1');
        try
            struc = openMaps([PathName,'\',FileName]);
        catch
            prompt = {'Enter the Column Size of the image'};
            dlgtitle = 'Column Size';
            definput = {'192'};
            opts.Interpreter = 'tex';
            answer = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
        	struc = openMaps([PathName,'\',FileName],'Column',str2double(answer{1,1}));
%             struc = [];
        end
        if isstruct(struc)
            ss = fieldnames(struc);structNames = sprintf('Fieldnames: \n');
            for jj = 1:1:numel(ss)
                structNames = sprintf('%s \n %s',structNames,ss{jj});
            end
            structNames = sprintf('%s \n\n Please enter the Struct:',structNames);
            nm = inputdlg(structNames,'Choose the Struct');
            
            name = nm{1};
            Slices = struc.Slice;
            eval(['allMaps = MosaicOnOff(struc.',name,',',num2str(Slices),');']);
            set(handles.MultipleSlices,'Max',Slices-1)
            set(handles.MultipleSlices,'Min',0)
            set(handles.ActualSliceNumber,'String','1');
            set(handles.MultipleSlices,'SliderStep',[1/(Slices-1) 1/(Slices-1)])
            set(handles.MaxSlices,'String',['/ ',num2str(Slices)]);
            handles.Slices = Slices;
            handles.actualSlice = 1;
            Map = allMaps(:,:,actualSlice);
            handles.allMaps = allMaps;
        else
            Map = struc;
            handles.allMaps = Map;
            allMaps = Map;
            handles.Slices = 1;
        end
        allMasks = zeros(size(allMaps));
        handles.actualSlice = 1;
        handles.allMasks = allMasks;
    end
    
    set(handles.MultipleSlices,'Value',0);
    Mask = zeros(size(Map));
    Reg = zeros(size(Map));
    SaveMask = zeros(size(Map));
    allRegs = zeros(size(allMasks));
    oldRegs = zeros(size(allMasks));
%     SaveMask = zeros(size(Mask));
    
    handles.allRegs=allRegs;
    handles.Reg=Reg;
    handles.oldRegs=oldRegs;
    handles.Map=Map;
    handles.Mask=Mask;
    handles.SaveMask=SaveMask;
    handles.PosZoom=[1 1 size(Map,2) size(Map,1)];
    guidata(hObject,handles)
    
    cla(handles.figAx,'reset');
    cla(handles.figAx2,'reset');
    
    showImages(handles);
    
    
function showImages(handles)
    minVal = str2double(get(handles.minVal,'String'));
    maxVal = str2double(get(handles.maxVal,'String'));
%     Map = handles.Map;
    
    allMaps = handles.allMaps;
    actualSlice = str2double(get(handles.ActualSliceNumber,'String'));
    Map = allMaps(:,:,actualSlice);
    
    Reg = handles.Reg;
    Mask = handles.Mask;
    SaveMask = handles.SaveMask;
    PosZoom = handles.PosZoom;
    cla(handles.figAx,'reset');
    cla(handles.figAx2,'reset');
    
    selected = get(handles.cMaps,'Value');
    temptxt = get(handles.cMaps,'String');
    seltext = temptxt{selected};
    if contains(seltext,'HSV')
    	tmpHsv = hsv(232);
        myMap = tmpHsv(16:216,:);myMap(1:2,:) = myMap(1:2,:).*0;
    elseif contains(seltext,'Hot')
        myMap = hot(200);
    elseif contains(seltext,'MyColorMap')
        myMap = myColorMap('',200);
    elseif contains(seltext,'Gray')
        myMap = gray(200);
    elseif contains(seltext,'Jet')
        myMap = jet(200);
    elseif contains(seltext,'Scanner')
        myMap = myColorMap('T1Scanner',200);
    else
        myMap = gray(200);
    end
        
    tmpMap = Map(PosZoom(2):PosZoom(4), PosZoom(1):PosZoom(3));
    
    resizeFac = str2double(get(handles.resizeFac,'String'));
    if resizeFac>1
        tmpMap = imresize(tmpMap,resizeFac);
    end
    
    imagesc(tmpMap, ...
        'parent',handles.figAx,[minVal maxVal]);
    colormap(handles.figAx,myMap);axis(handles.figAx,'off');
    
    
%     maxVal = max(Reg(SaveMask>0));
%     minVal = min(Reg(SaveMask>0));
%     minVal = minVal - (maxVal-minVal);minVal(minVal<0) = 0;
%     maxVal = maxVal + (maxVal-minVal);
%     if isempty(minVal) || maxVal == minVal
%         minVal = 0;
%         maxVal = 1;
%     end
    minVal = str2double(get(handles.MinReg,'String'));
    maxVal = str2double(get(handles.MaxReg,'String'));
    if length(unique(Reg(:)))==1
        Reg = Map;
    end
    if ~get(handles.ShowReg,'value')
        Reg = Reg.*0;
    end
    imagesc(Reg, 'parent',handles.figAx2,[minVal maxVal]);
    myMap = gray(200);colormap(handles.figAx2,myMap);
    myMap2 = lines(200);myMap2(1,:) = myMap2(1,:).*0;
    hold(handles.figAx2,'on')
    if length(unique(SaveMask(:))) > 1
        looper = unique(SaveMask(SaveMask>0));
        for i=1:1:length(looper)
            v = looper(i);
            overlay = cat(3, myMap2(v+1,1).*ones(size(SaveMask)),myMap2(v+1,2)*ones(size(SaveMask)), ...
                myMap2(v+1,3)*ones(size(SaveMask)));
            newMask = SaveMask;
            newMask(newMask~=v) = 0;
            if ~get(handles.ShowReg,'value')
                newMask(newMask>0) = 1;
            else
                newMask(newMask>0) = 0.6;
            end
            h(i) = imshow(overlay,'Parent',handles.figAx2); 
            set(h(i), 'AlphaData', newMask) 
%             set(h(i), 'CData', [0 5]) 
            hold(handles.figAx2,'on')
        end
    end
    
%     SaveMask(1,1) = 200;    
%     imagesc(SaveMask, 'parent',handles.figAx2,[min(SaveMask(:)) max(1,max(SaveMask(:)) )]);
%     myMap = lines(200);myMap(1,:) = myMap(1,:).*0;colormap(handles.figAx2,myMap);
    hold(handles.figAx2,'on')
    if get(handles.Delete,'value')
        green = cat(3, ones(size(Mask)),zeros(size(Mask)), zeros(size(Mask)));
    else
        green = cat(3, zeros(size(Mask)), ones(size(Mask)),zeros(size(Mask)));
    end
    newMask = Mask;
    newMask(newMask>0) = 1;
    h = imshow(green,'Parent',handles.figAx2); 
    set(h, 'AlphaData', newMask) 
    axis(handles.figAx2,'off');
    
    handles.minVal=minVal;
    handles.maxVal=maxVal;
    
    
    


% --- Executes on button press in CalculateROI.
function CalculateROI_Callback(hObject, eventdata, handles)

    
    selected = get(handles.Method,'Value');
    temptxt = get(handles.Method,'String');
    seltext = temptxt{selected};
    SegmentNumber = str2double(get(handles.SegmentNumber,'String'));
    ROINumber = str2double(get(handles.ROINumber,'String'));
    position = handles.PosZoom;
    Map = handles.Map;
    
    if contains(seltext,'Smooth')
        Mask = handles.Mask;
        Mask(Mask>0) = 1;
        se = strel('disk',1);
        newMask = imerode(Mask,se);
    else
        Mask = zeros(size(Map));    
    end
    
    resizeFac = str2double(get(handles.resizeFac,'String'));
    
    Slices = handles.Slices;

    if Slices>1
        allMasks = handles.allMasks;
        allMaps = handles.allMaps;
        actualSlice = get(handles.MultipleSlices,'Value')+1;
        Map = allMaps(:,:,actualSlice);
        SaveMask = allMasks(:,:,actualSlice);
        handles.SaveMask = SaveMask;
        handles.Map = Map;
    end
    
    if contains(seltext,'Pixel') || contains(seltext,'Circle') ...
            || contains(seltext,'Region Growing')
        dcm_obj = datacursormode;
        set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
            'off','Enable','on')
        while(isempty(getCursorInfo(dcm_obj)))
            pause on
            pause(1);
        end
        obj = getCursorInfo(dcm_obj);
        pos = obj.Position;
        if resizeFac>1
            pos = round(pos./resizeFac);
        end
        pos(1) = pos(1)-1+position(1);
        pos(2) = pos(2)-1+position(2);
        set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
            'off','Enable','off')
        delete(findall(gcf,'Type','hggroup'));
        
        Mask(pos(2),pos(1)) = SegmentNumber;
        newMask = zeros(size(Mask));
        newMask(pos(2),pos(1)) = 1;
        
        if contains(seltext,'Circle')
            radi = ROINumber;
            if radi<1
                radi = 2;
            end
            mse = strel('sphere',radi).getnhood;
            mmm = squeeze(mse(:,:,(size(mse,3)+1)/2));
            newMask = zeros(size(Mask));
            newMask(pos(2),pos(1)) = 1;
            newMask = imdilate(newMask, mmm);
            Mask(newMask==1) = SegmentNumber;
        elseif contains(seltext,'Region Growing')
            newMask = zeros(size(Mask));
            newMask=regiongrowing(Map,pos(2),pos(1),ROINumber);
            Mask(newMask==1) = SegmentNumber;
        end
        
    elseif contains(seltext,'Polygon')
        polyH = impoly;
        pos = wait(polyH);
        if resizeFac>1
            pos = round(pos./resizeFac);
        end
        pos(:,2) = pos(:,2)-1+position(2);
        pos(:,1) = pos(:,1)-1+position(1);
        col_pos = (1:size(Mask,1))';
        row_pos = 1:size(Mask,2);
        xp = repmat(col_pos,size(Mask,2),1);
        yp = repmat(row_pos,size(Mask,1),1);
        yp = reshape(yp,size(Mask,1)*size(Mask,2),1);
        [in, on] = inpolygon(xp,yp,pos(:,2),pos(:,1));
        in = reshape(in,size(Mask,1),size(Mask,2));
        on = reshape(on,size(Mask,1),size(Mask,2));
        newMask = zeros(size(Mask));
        newMask = in+on;
        newMask(newMask>1) = 1;
        Mask(newMask==1) = SegmentNumber;
        delete(polyH);   
    elseif contains(seltext,'Clear')
        Mask = SegmentNumber.*ones(size(Mask));
        newMask = Mask;
    end
    
    
    SaveMask = handles.SaveMask;        
    
    if strcmp(seltext,'Clear All')
        Mask = Mask.*0;
        SaveMask = SaveMask.*0;
        handles.SaveMask = SaveMask; 
    end
    if strcmp(seltext,'Smooth')
        Mask = Mask.*0;
        Mask(newMask==1) = SegmentNumber;
    else
        Smoothness = str2double(get(handles.Smoothness,'String'));
        if Smoothness>0
            se = strel('disk',Smoothness);
            newMask = imclose(newMask,se);
            Mask(newMask==1) = SegmentNumber;
        elseif Smoothness<0
            se = strel('disk',-Smoothness);
            newMask = imopen(newMask,se);
            Mask(newMask==1) = SegmentNumber;
        end
    end
    
    tmpImg = Map(SaveMask==SegmentNumber | Mask==SegmentNumber);
    MeanVal = round(mean(tmpImg(:)),1);
    StdVal = round(std(tmpImg(:)),1);
    
    set(handles.MeanVal,'String',num2str(MeanVal) );
    set(handles.StdVal,'String',num2str(StdVal) );

%     handles.SaveMask = SaveMask;
    handles.Mask = Mask;
    guidata(hObject,handles)
    
    showImages(handles);
    if strcmp(seltext,'Clear All') || strcmp(seltext,'Clear')
        set(handles.Delete,'value',1);
        Update_Callback(hObject, eventdata, handles)
    end


% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
% hObject    handle to Update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mask = handles.Mask;
SaveMask = handles.SaveMask;
allMasks = handles.allMasks;
SegmentNumber = str2double(get(handles.SegmentNumber,'String'));

if get(handles.Delete,'value')
    tmpMask = SaveMask;
    tmpMask(tmpMask==SegmentNumber) = 0;
    SaveMask(SaveMask~=SegmentNumber) = 0;
    SaveMask(Mask>0) = 0;
    SaveMask = SaveMask + tmpMask;
else
    if ~get(handles.OverWrite,'value')
        SaveMask(SaveMask==0) = Mask(SaveMask==0);
    else
        SaveMask(Mask~=0) = Mask(Mask~=0);
    end
end

handles.SaveMask = SaveMask;
handles.Mask = Mask.*0;
actualSlice = get(handles.MultipleSlices,'Value')+1;
allMasks(:,:,actualSlice) = SaveMask;

handles.allMasks = allMasks;
guidata(hObject,handles)

set(handles.Delete,'value',0);
    
SegmentNumber_Callback(hObject, eventdata, handles)
showImages(handles);


% --- Executes on button press in Zoom.
function Zoom_Callback(hObject, eventdata, handles)
    

    allMaps = handles.allMaps;
    actualSlice = str2double(get(handles.ActualSliceNumber,'String'));
    Map = allMaps(:,:,actualSlice);
%     Map = handles.Map;
    PosZoom = handles.PosZoom;
    handles.PosZoom = [1 1 size(Map,2) size(Map,1)];
    showImages(handles);
    if PosZoom(3)==size(Map,2) && PosZoom(4)==size(Map,1) && ...
            PosZoom(1)==1 && PosZoom(2)==1
        h = imrect(handles.figAx);
        position = round(wait(h),0);
        position(3) = position(3) + position(1);
        position(4) = position(4) + position(2);
        handles.PosZoom = position;
        delete(h);
        showImages(handles);
    end
    guidata(hObject,handles)
    


% --- Executes on button press in Smooth.
function Smooth_Callback(hObject, eventdata, handles)

    
    SegmentNumber = str2double(get(handles.SegmentNumber,'String'));
    Mask = handles.Mask;
    Mask(Mask>0) = 1;
    se = strel('disk',1);
    newMask = imerode(Mask,se);
    Mask = Mask.*0;
    Mask(newMask==1) = SegmentNumber;
    handles.Mask = Mask;
    showImages(handles);
    guidata(hObject,handles)


% --- Executes on button press in DeleteAll.
function DeleteAll_Callback(hObject, eventdata, handles)
answer = questdlg('Do you really want to delete the whole mask?', ...
	'Sure','Yes', ...
	'No','No');
% w = waitforbuttonpress;
% while isempty(answer)
%     
% end
% Handle response
switch answer
    case 'Yes'
        
    case 'No'
        return;
end
Slices = handles.Slices;
Map = handles.Map;
Mask = zeros(size(Map));
SaveMask = zeros(size(Map));
allMasks = zeros(size(Map,1),size(Map,2),Slices);

handles.Mask = Mask;
handles.SaveMask = SaveMask;
handles.allMasks = allMasks;
handles.PosZoom = [1 1 size(Map,2) size(Map,1)];

% showImages(handles);
Update_Callback(hObject, eventdata, handles);

set(handles.MeanVal,'String','');
set(handles.StdVal,'String','');

guidata(hObject,handles)

function Save_Callback(hObject, eventdata, handles)
    allMasks = handles.allMasks;
%     SaveMask = handles.SaveMask;
    [SaveName,currentfolder] = uiputfile('SaveMask.mat','Save file name');
    save(strcat(currentfolder,sprintf('%s',SaveName)),...
        'allMasks');
    set(handles.MaskFolder,'String',[currentfolder,SaveName]);

function MeanVal_Callback(hObject, eventdata, handles)
% hObject    handle to MeanVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MeanVal as text
%        str2double(get(hObject,'String')) returns contents of MeanVal as a double


% --- Executes during object creation, after setting all properties.
function MeanVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeanVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StdVal_Callback(hObject, eventdata, handles)
% hObject    handle to StdVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StdVal as text
%        str2double(get(hObject,'String')) returns contents of StdVal as a double


% --- Executes during object creation, after setting all properties.
function StdVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StdVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function MultipleSlices_Callback(hObject, eventdata, handles)
    actualSlice = round(get(handles.MultipleSlices,'Value'),0)+1;
    set(handles.MultipleSlices,'Value',actualSlice-1);
    set(handles.ActualSliceNumber,'String',num2str(actualSlice));
    
    Mask = handles.Mask;
    Mask = zeros(size(Mask));
    handles.Mask = Mask;
%     showSlice(handles)
    
% function showSlice(handles)
    allMaps = handles.allMaps;
    allMasks = handles.allMasks;
    allRegs = handles.allRegs;
    Slices = handles.Slices;
    if Slices>1
        actualSlice = get(handles.MultipleSlices,'Value')+1;
        set(handles.ActualSliceNumber,'String',num2str(actualSlice));
        Map = allMaps(:,:,actualSlice);
        Reg = allRegs(:,:,actualSlice);
        SaveMask = allMasks(:,:,actualSlice);
        handles.Map = Map;
        handles.Reg = Reg;
        handles.SaveMask = SaveMask;
        handles.allMasks = allMasks;
        handles.actualSlice = actualSlice;
        showImages(handles);
    end
    
    SegmentNumber_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function MultipleSlices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MultipleSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ActualSliceNumber_Callback(hObject, eventdata, handles)

    set(handles.MultipleSlices,'Value',-1+str2double(get(handles.ActualSliceNumber,'String')));
    % showSlice(handles)
    MultipleSlices_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ActualSliceNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ActualSliceNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadMask.
function loadMask_Callback(hObject, eventdata, handles)

    actualSlice = get(handles.MultipleSlices,'Value')+1;

    [FileName,PathName,FilterIndex] = uigetfile(...
   '*.*',  'All Files (*.*)', ...
   'Pick a file', ...
   'MultiSelect', 'on');
    set(handles.MaskFolder,'String',[PathName,FileName]);
    tmpMask = load([PathName,FileName]);
    allMasks = tmpMask.allMasks;
    SaveMask = allMasks(:,:,actualSlice);
    handles.allMasks = allMasks;
    handles.SaveMask = SaveMask;
%     showImages(handles);
    Update_Callback(hObject, eventdata, handles);

    guidata(hObject,handles)



function Smoothness_Callback(hObject, eventdata, handles)
% hObject    handle to Smoothness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Smoothness as text
%        str2double(get(hObject,'String')) returns contents of Smoothness as a double


% --- Executes during object creation, after setting all properties.
function Smoothness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Smoothness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)

    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
    else
        Reg = allRegs;
    end
    Reg(1:end-1,:) = Reg(2:end,:);
    Reg(end,:) = Reg(end,:).*0;
    
    allMasks = handles.allMasks;
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        Map = handles.allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        allRegs = Reg;
        Map = handles.allMaps;
        SaveMask = handles.allMasks;
    end
    handles.SaveMask = SaveMask;
    
    handles.Map = Map;
    handles.actualSlice = actualSlice;
    
    handles.allRegs = allRegs;
    handles.Reg = Reg;    
    showImages(handles);
    guidata(hObject,handles)


% --- Executes on button press in Move_Right.
function Move_Right_Callback(hObject, eventdata, handles)

    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
    else
        Reg = allRegs;
    end
    Reg(:,2:end) = Reg(:,1:end-1);
    Reg(:,end) = Reg(:,end).*0;
    
    allMasks = handles.allMasks;
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        Map = handles.allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        allRegs = Reg;
        Map = handles.allMaps;
        SaveMask = handles.allMasks;
    end
    handles.SaveMask = SaveMask;
    
    handles.Map = Map;
    handles.actualSlice = actualSlice;
    handles.allRegs = allRegs;
    handles.Reg = Reg;    
    showImages(handles);
    guidata(hObject,handles)



% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)

    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
    else
        Reg = allRegs;
    end
    Reg(2:end,:) = Reg(1:end-1,:);
    Reg(end,:) = Reg(end,:).*0;
    
    allMasks = handles.allMasks;
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        Map = handles.allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        allRegs = Reg;
        Map = handles.allMaps;
        SaveMask = handles.allMasks;
    end
    handles.SaveMask = SaveMask;
    
    handles.Map = Map;
    handles.actualSlice = actualSlice;
    handles.allRegs = allRegs;
    handles.Reg = Reg;    
    showImages(handles);
    guidata(hObject,handles)


% --- Executes on button press in Move_Left.
function Move_Left_Callback(hObject, eventdata, handles)

    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
    else
        Reg = allRegs;
    end
    Reg(:,1:end-1) = Reg(:,2:end);
    Reg(:,end) = Reg(:,end).*0;
    
    allMasks = handles.allMasks;
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        Map = handles.allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        allRegs = Reg;
        Map = handles.allMaps;
        SaveMask = handles.allMasks;
    end
    handles.SaveMask = SaveMask;
    
    handles.Map = Map;
    handles.actualSlice = actualSlice;
    
    handles.allRegs = allRegs;
    handles.Reg = Reg;    
    showImages(handles);
    guidata(hObject,handles)

% --- Executes on button press in Move_Reset.
function Move_Reset_Callback(hObject, eventdata, handles)

allRegs = handles.allRegs;
oldRegs = handles.oldRegs;
allMaps = handles.allMaps;
allMasks = handles.allMasks;
% allRegs = oldRegs;
actualSlice = get(handles.MultipleSlices,'Value')+1;
Slices = handles.Slices;
if Slices>1
    Reg = oldRegs(:,:,actualSlice);
    allRegs(:,:,actualSlice) = oldRegs(:,:,actualSlice);
    Map = handles.allMaps(:,:,actualSlice);
    SaveMask = handles.allMasks(:,:,actualSlice);
else
    Reg = oldRegs;
    allRegs(:,:,actualSlice) = oldRegs(:,:,actualSlice);
    Map = handles.allMaps;
    SaveMask = handles.allMasks;
end
handles.SaveMask = SaveMask;
handles.Map = Map;
handles.actualSlice = actualSlice;
handles.allRegs = allRegs; 
handles.Reg = Reg; 
showImages(handles);
guidata(hObject,handles)


% --- Executes on button press in Move_Rotp.
function Move_Rotp_Callback(hObject, eventdata, handles)

    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
    else
        Reg = allRegs;
    end
    Reg = imrotate(Reg,-1,'bilinear','crop');
    
    allMasks = handles.allMasks;
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        Map = handles.allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        allRegs = Reg;
        Map = handles.allMaps;
        SaveMask = handles.allMasks;
    end
    handles.SaveMask = SaveMask;
    
    handles.Map = Map;
    handles.actualSlice = actualSlice;
    
    handles.allRegs = allRegs;
    handles.Reg = Reg;    
    showImages(handles);
    guidata(hObject,handles)
    


% --- Executes on button press in Move_Rotm.
function Move_Rotm_Callback(hObject, eventdata, handles)
    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
    else
        Reg = allRegs;
    end
    Reg = imrotate(Reg,1,'bilinear','crop');
    
    allMasks = handles.allMasks;
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        Map = handles.allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        allRegs = Reg;
        Map = handles.allMaps;
        SaveMask = handles.allMasks;
    end
    handles.SaveMask = SaveMask;
    
    handles.Map = Map;
    handles.actualSlice = actualSlice;
    
    handles.allRegs = allRegs;
    handles.Reg = Reg;    
    showImages(handles);
    guidata(hObject,handles)


% --- Executes on button press in LoadSecond.
function LoadSecond_Callback(hObject, eventdata, handles)

 [FileName,PathName,FilterIndex] = uigetfile(...
   '*.*',  'All Files (*.*)', ...
   'Pick a file', ...
   'MultiSelect', 'on');

    allRegs = handles.allRegs;
    oldRegs = handles.oldRegs;
    Slices = handles.Slices;
    actualSlice = get(handles.MultipleSlices,'Value')+1;
    
    if length(FileName) == Slices
        [allRegs, heads] = openMaps([PathName,'\*'],'all');
        for i=1:1:length(heads)
            sliceLoc(i) = heads(i).SliceLocation;
        end
        [~, idx] = sort(sliceLoc,'ascend');
        handles.allRegs = allRegs(:,:,idx);
        handles.oldRegs = allRegs(:,:,idx);
        handles.Reg = allRegs(:,:,actualSlice);
    else
        handles.allRegs = allRegs;
        handles.oldRegs = allRegs;
        fprintf('Your loaded images to register has not the same slice number\n');
        return;
    end
    
    showImages(handles);
    guidata(hObject,handles)
    
    


% --- Executes on button press in SaveSecond.
function SaveSecond_Callback(hObject, eventdata, handles)
    allRegs = handles.allRegs;
%     SaveMask = handles.SaveMask;
    [SaveName,currentfolder] = uiputfile('SaveRegistration.mat','Save file name');
    save(strcat(currentfolder,sprintf('%s',SaveName)),...
        'allRegs');
    set(handles.MaskFolder,'String',[currentfolder,SaveName]);


% --- Executes on button press in ShowReg.
function ShowReg_Callback(hObject, eventdata, handles)

showImages(handles);


% --- Executes on button press in Registration.
function Registration_Callback(hObject, eventdata, handles)

    selected = get(handles.RegChoice,'Value');
    temptxt = get(handles.RegChoice,'String');
    seltext = temptxt{selected};
    
    actualSlice = get(handles.MultipleSlices,'Value')+1;
    Slices = handles.Slices;
    allRegs = handles.allRegs;
    allMaps = handles.allMaps;
    
    if Slices>1
        Reg = allRegs(:,:,actualSlice);
        Map = allMaps(:,:,actualSlice);
        SaveMask = handles.allMasks(:,:,actualSlice);
    else
        Reg = allRegs;
        Map = allMaps;
        SaveMask = handles.allMasks;
    end
    
    moving = Reg;
    fixed = Map;
        
    [optimizer,metric] = imregconfig('multimodal');
    if contains(seltext,'Standard')
        Reg = imregister(moving,fixed,'affine',optimizer,metric);
    elseif contains(seltext,'Advanced')
        optimizer.InitialRadius = optimizer.InitialRadius/3.5;
        optimizer.MaximumIterations = 300;
        Reg = imregister(moving,fixed,'affine',optimizer,metric);
    elseif contains(seltext,'Affine')
        optimizer.InitialRadius = 0.009;
        optimizer.Epsilon = 1.5e-4;
        optimizer.GrowthFactor = 1.01;
        optimizer.MaximumIterations = 300;
        tform = imregtform(moving, fixed, 'affine', optimizer, metric);
        Reg = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));
    elseif contains(seltext,'Rigid')
        optimizer.InitialRadius = 0.009;
        optimizer.Epsilon = 1.5e-4;
        optimizer.GrowthFactor = 1.01;
        optimizer.MaximumIterations = 300;
        tform = imregtform(moving, fixed, 'rigid', optimizer, metric);
        Reg = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));
    elseif contains(seltext,'Similarity')
        optimizer.InitialRadius = 0.009;
        optimizer.Epsilon = 1.5e-4;
        optimizer.GrowthFactor = 1.01;
        optimizer.MaximumIterations = 300;
        tform = imregtform(moving, fixed, 'similarity', optimizer, metric);
        Reg = imwarp(moving,tform,'OutputView',imref2d(size(fixed)));
    end
    
    if Slices>1
        allRegs(:,:,actualSlice) = Reg;
        allMaps(:,:,actualSlice) = Map;
    else
        allRegs = Reg;
        allMaps = Map;
    end   
    
    handles.Reg = Reg;
    handles.allRegs = allRegs;
    handles.allMaps = allMaps; 
    handles.SaveMask = SaveMask; 
    handles.Map = Map;
    handles.actualSlice = actualSlice;

    showImages(handles);
    guidata(hObject,handles)
    

% --- Executes on selection change in RegChoice.
function RegChoice_Callback(hObject, eventdata, handles)
% hObject    handle to RegChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RegChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RegChoice


% --- Executes during object creation, after setting all properties.
function RegChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinReg_Callback(hObject, eventdata, handles)
% hObject    handle to MinReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinReg as text
%        str2double(get(hObject,'String')) returns contents of MinReg as a double

    showImages(handles);

% --- Executes during object creation, after setting all properties.
function MinReg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxReg_Callback(hObject, eventdata, handles)
% hObject    handle to MaxReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxReg as text
%        str2double(get(hObject,'String')) returns contents of MaxReg as a double

    showImages(handles);

% --- Executes during object creation, after setting all properties.
function MaxReg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cMaps.
function cMaps_Callback(hObject, eventdata, handles)
    showImages(handles);


% --- Executes during object creation, after setting all properties.
function cMaps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Dilate.
function Dilate_Callback(hObject, eventdata, handles)
    
    SegmentNumber = str2double(get(handles.SegmentNumber,'String'));
    Mask = handles.Mask;
    Mask(Mask>0) = 1;
    se = strel('disk',1);
    newMask = imdilate(Mask,se);
    Mask = Mask.*0;
    Mask(newMask==1) = SegmentNumber;
    handles.Mask = Mask;
    showImages(handles);
    guidata(hObject,handles)



function resizeFac_Callback(hObject, eventdata, handles)
% hObject    handle to resizeFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resizeFac as text
%        str2double(get(hObject,'String')) returns contents of resizeFac as a double

    Update_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function resizeFac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resizeFac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OverWrite.
function OverWrite_Callback(hObject, eventdata, handles)
% hObject    handle to OverWrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OverWrite
