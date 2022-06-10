function varargout = transparent_background(varargin)
% transparent_background by Ingo Hermann 2020-10-08
% This is a GUI function which makes the background of images transparent
% or simple reducesspecific colors from the image.
% this is good for presentations where you want nicer images...
% --------------------------------
% This scripts needs the user functions:
% - none -

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @transparent_background_OpeningFcn, ...
                   'gui_OutputFcn',  @transparent_background_OutputFcn, ...
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


% --- Executes just before transparent_background is made visible.
function transparent_background_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transparent_background (see VARARGIN)

% Choose default command line output for transparent_background
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axis(handles.fig2,'off');
axis(handles.fig3,'off');
axis(handles.fig1,'off');


% UIWAIT makes transparent_background wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = transparent_background_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in open_img.
function open_img_Callback(hObject, eventdata, handles)
clearvars background counter slider;
global old_pathname;
global rgb;
global img_2;
old_pathname = pwd;

[filename, pathname] = uigetfile({'*.JPG';'*.jpg';'*.gif';...
    '*.png';'*.*'},'File Selector');

cd(pathname);
%set(handles.filename,'String',filename);
global img;
global img_trans;
[img, map] = imread(filename);

if(isempty(map)) % image is RGB or grayscale
    img = im2double(img);
    if(size(img, 3) == 1) % image is grayscale
        img2 = cat(3, img, img, img);
        clear img;
        img = img2;
        clear img2;
    end

else % image is indexed
    img = ind2rgb(img, map);
end
sz = size(img);
rgb = zeros(sz);

img_trans = zeros(sz(1),sz(2));
do_Callback(hObject, eventdata, handles)
cd(old_pathname);
img = im2uint8(img);

img_2 = img;


% --- Executes on button press in save_img.
function save_img_Callback(hObject, eventdata, handles)
global background;
global img_2;
% hObject    handle to save_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = pwd;
[filename, pathname] = uiputfile({'*.png'},'Save as');
str = strcat(filename);
img_2 = double(img_2);
cd(pathname)
c = double([background(1,1)/255 background(1,2)/255 background(1,3)/255]);

b1 = str2double(get(handles.b1,'String'));
b2 = str2double(get(handles.b2,'String'));
b3 = str2double(get(handles.b3,'String'));

c = [b1 b2 b3];
% if get(handles.check_ref,'Value')
%     c = double([0 0 0]);
% end
imwrite(img_2./255,str,'png', 'Transparency',c./255);
cd(path)


% --- Executes on button press in save_img.
%shows the images
function do_Callback(hObject, eventdata, handles)
global img;
global rgb;
global img_2;
check = get(handles.check_ref,'Value');
% check = 1;
axis(handles.fig1);
imshow(img,'parent',handles.fig1);
guidata(hObject,handles); 

%show transparent or normal image
axis(handles.fig2);
if check==1
    imshow(img_2, 'parent',handles.fig2);
else
    imshow(rgb, 'parent',handles.fig2);
end
guidata(hObject,handles); 


% --- Executes on button press in choose_bg.
function choose_bg_Callback(hObject, eventdata, handles)
global background;
global counter;
global img;
global img_trans;
global rgb;
global rgb_all;

sz = size(img);
img_trans = zeros(sz(1),sz(2));
rgb = zeros(sz(1),sz(2));
rgb_all = rgb;
%set(handles.input_bg, 'String', '');

% skip this part

if handles.checkbox4.Value==0
    counter = 1;
    pos1 = [];
    fig(1) = figure(1);imshow(img);
    dcm_obj = datacursormode(fig(1));
    set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
            'off','Enable','on')
    while isempty(pos1)
        disp('Choose a background pixel')
        pos1 = getCursorInfo(dcm_obj);
        pause(1);
    end
    pos = pos1.Position;
    close(fig(1));
    %whos img;
    %define the background as chosen point
    background(counter,1) = img(pos(2), pos(1),1);
    background(counter,2) = img(pos(2), pos(1),2);
    background(counter,3) = img(pos(2), pos(1),3);
else
    b1 = str2double(get(handles.edit_r,'String'));
    b2 = str2double(get(handles.edit_g,'String'));
    b3 = str2double(get(handles.edit_b,'String'));
    background(counter,1) = uint8(b1);
    background(counter,2) = uint8(str2double(get(handles.edit_g,'String')));
    background(counter,3) = uint8(str2double(get(handles.edit_b,'String')));
end


%background 

input_bg_Callback(hObject, eventdata, handles)

% --- Executes on button press in next_bg.
function next_bg_Callback(hObject, eventdata, handles)
global counter;
global background;
global img;
global rgb;
global rgb_all;
rgb_all = rgb;
set(handles.slider,'Value',0)
slider = 0;
% if slider~=0
%     warndlg('You cannot have backgrounds with variable values!!!')
% end
counter = counter + 1;
fig(1) = figure(1);imshow(img);
dcm_obj = datacursormode(fig(1));
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex',...
    'off','Enable','on')
disp('Choose a background pixel')
pause 
pos1 = getCursorInfo(dcm_obj);
pos = pos1.Position;

close(fig(1));
background(counter,1) = img(pos(2), pos(1),1);
background(counter,2) = img(pos(2), pos(1),2);
background(counter,3) = img(pos(2), pos(1),3);

input_bg_Callback(hObject, eventdata, handles)

% --- Executes on selection change in color_box.
function color_box_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function color_box_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bg_val_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function bg_val_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in input_bg.

%the function where everything is happening!!!!!!!
function input_bg_Callback(hObject, eventdata, handles)
opengl('save', 'software')

global background;
global counter;
global prev_list;
global img_miss;
global img;
global img_trans;
global rgb;
global img_2;
global slider_list;
global rgb_all;
%connect the background of all chosen points

slider = get(handles.slider,'Value');
% slider2 = round(256*slider);
% slider22 = slider2;

slider2 = round(slider*256);
slider_list(counter) = slider2;
axis(handles.fig3);


prev_list = strcat( '[',mat2str(background(1,1)),',',...
        mat2str(background(1,2)),',',...
        mat2str(background(1,3)),']', ',  slider: ',mat2str(slider_list(1)));
new_list = prev_list;
for i=2:1:counter
    vars = strcat( '[',mat2str(background(i,1)),',',...
        mat2str(background(i,2)),',',...
        mat2str(background(i,3)),']', ',  slider: ',mat2str(slider_list(i)));
    new_list = strcat(prev_list,'|',vars);
    prev_list = new_list;
end


%generate new list
set(handles.color_box,'string',new_list)

%stop condition!!!
stoper = 1;
if slider2 ~= 0
    choice = questdlg('It could take some time! Continue?', ...
	'Really?', ...
	'Stop','Yes','Really?');
    switch choice
        case ' Stop'
            disp('Stop!')
            stoper = 1;
        case 'Yes'
            disp('Continue!')
            stoper = 0;
    end
end
%plot the continous distribution of color with slider
if stoper == 0 || slider2 == 0
        
        jmin = max(0,abs(background(counter,1)-slider_list(counter)) );
        jmax = min(255,abs(background(counter,1)+slider_list(counter)) );
        
        kmin = max(0,abs(background(counter,2)-slider_list(counter)) );
        kmax = min(255,abs(background(counter,2)+slider_list(counter)) );
       
        lmin = max(0,abs(background(counter,3)-slider_list(counter)) );
        lmax = min(255,abs(background(counter,3)+slider_list(counter)) );
        
        steps = 1;
        numb = (3 + jmax-jmin + kmax-kmin + lmax-lmin);
        numb_c = 0;
        
        for j=jmin:steps:jmax
            for k=kmin:steps:kmax
                for l=lmin:steps:lmax
%                     rectangle('Position',[counter+numb_c/numb 0 counter+(numb_c+1)/numb 2],...
%                         'FaceColor',[j/256 k/256 l/256],'EdgeColor','none',...
%                         'parent',handles.fig3);
                    numb_c = numb_c + steps;                    
                end
            end
        end
%     end
    set(handles.fig3,'XLim',[1 counter+1]);
    set(handles.fig3,'YLim',[0 2]);
    set(handles.fig3,'XTickLabel','','YTickLabel','');
    guidata(hObject,handles);

    red = img(:,:,1);
    green = img(:,:,2);
    blue = img(:,:,3);

    r = rgb_all;
    g = rgb_all;
    b = rgb_all;
    % define the background diff matrix 
    back_mat = zeros(size(img));
    back_mat(:,:,1) = background(counter,1);
    back_mat(:,:,2) = background(counter,2);
    back_mat(:,:,3) = background(counter,3);
    % define difference matri
    double_img = round(255*im2double(img));
    diff_mat = abs(double_img-back_mat);
%     diff_mat(double_img==0) = 1;

    
    r(diff_mat(:,:,1)<=slider_list(counter)) = 1;
    g(diff_mat(:,:,2)<=slider_list(counter)) = 1;
    b(diff_mat(:,:,3)<=slider_list(counter)) = 1;
    rgb = r.*g.*b;
    img_trans(rgb == 1) = 1;
    
    b1 = str2double(get(handles.b1,'String'));
    b2 = str2double(get(handles.b2,'String'));
    b3 = str2double(get(handles.b3,'String'));

    bet(:,:) = img(:,:,1);
    bet(rgb==1) = b1;%background(1,1);
    img_2(:,:,1) = bet;
    bet(:,:) = img(:,:,2);
    bet(rgb==1) = b2;%background(1,2);
    img_2(:,:,2) = bet;
    bet(:,:) = img(:,:,3);
    bet(rgb==1) = b3;%background(1,3);
    img_2(:,:,3) = bet;



    fprintf(['Finished with this counter: ',num2str(counter),'\n']);
    do_Callback(hObject, eventdata, handles)
%stopper end
end


%imwrite(img_trans, 'transparent.png', 'png', 'transparency', background);


% --- Executes on button press in check_ref.
function check_ref_Callback(hObject, eventdata, handles)
do_Callback(hObject, eventdata, handles)


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
slider = get(handles.slider,'Value');
slider = round(slider*256);
set(handles.val,'String', slider);

% global background;
% if ~isempty(background)
    input_bg_Callback(hObject, eventdata, handles)
% end


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function val_Callback(hObject, eventdata, handles)
slider = str2num( get(hObject,'String') );
slider = double(slider)/256;
set(handles.slider,'Value',slider);

global background;
if ~isempty(background)
    input_bg_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function val_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b2_Callback(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b2 as text
%        str2double(get(hObject,'String')) returns contents of b2 as a double


% --- Executes during object creation, after setting all properties.
function b2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b3_Callback(hObject, eventdata, handles)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b3 as text
%        str2double(get(hObject,'String')) returns contents of b3 as a double


% --- Executes during object creation, after setting all properties.
function b3_CreateFcn(hObject, eventdata, ~)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b1_Callback(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b1 as text
%        str2double(get(hObject,'String')) returns contents of b1 as a double


% --- Executes during object creation, after setting all properties.
function b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_r_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r as text
%        str2double(get(hObject,'String')) returns contents of edit_r as a double


% --- Executes during object creation, after setting all properties.
function edit_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_g_Callback(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_g as text
%        str2double(get(hObject,'String')) returns contents of edit_g as a double


% --- Executes during object creation, after setting all properties.
function edit_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_b_Callback(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_b as text
%        str2double(get(hObject,'String')) returns contents of edit_b as a double


% --- Executes during object creation, after setting all properties.
function edit_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
