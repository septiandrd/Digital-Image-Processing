function varargout = PCD(varargin)
% PCD MATLAB code for PCD.fig
%      PCD, by itself, creates a new PCD or raises the existing
%      singleton*.
%
%      H = PCD returns the handle to a new PCD or the handle to
%      the existing singleton*.
%
%      PCD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCD.M with the given input arguments.
%
%      PCD('Property','Value',...) creates a new PCD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PCD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PCD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PCD

% Last Modified by GUIDE v2.5 06-Mar-2018 13:49:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PCD_OpeningFcn, ...
                   'gui_OutputFcn',  @PCD_OutputFcn, ...
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


% --- Executes just before PCD is made visible.
function PCD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PCD (see VARARGIN)

% Choose default command line output for PCD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PCD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PCD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename,Pathname] = uigetfile({'*.jpg';'*.png';'*.bmp'},'Browse Image');
name = strcat(Pathname,Filename);
img = imread(name);
axes(handles.axes1);
handles.imgName.String = name;
imshow(img);
imsize = size(img);
set(handles.w1,'string',num2str(1));
set(handles.w2,'string',num2str(imsize(2)));
set(handles.h1,'string',num2str(1));
set(handles.h2,'string',num2str(imsize(1)));

h = img(:,:,1);
[x,y]=size(h);

tR=1:256;
nR=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tR(z)=count;
    count=0;
end

axes(handles.axHistR);
plot(nR,tR,'r'); 
xlim([1 256]);
% ylim([0 4000]);
title('Red Histogram');

h = img(:,:,2);
[x,y]=size(h);

tG=1:256;
nG=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tG(z)=count;
    count=0;
end

axes(handles.axHistG);
plot(nG,tG,'g'); 
xlim([1 256]);
% ylim([0 4000]);
title('Green Histogram');

h = img(:,:,3);
[x,y]=size(h);

tB=1:256;
nB=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tB(z)=count;
    count=0;
end

axes(handles.axHistB);
plot(nB,tB,'b'); 
xlim([1 256]);
% ylim([0 4000]);
title('Blue Histogram');


% --- Executes on button press in btn_grayscale.
function btn_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to btn_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isempty(get(handles.axes1, 'Children'))) 
    errordlg('Select image first.');
end
img = getimage(handles.axes1);
r = sum(img(:,:,1));
g = sum(img(:,:,2));
b = sum(img(:,:,3));
if (r>g & r>b) 
    grayscale = 0.5*img(:,:,1) + 0.25*img(:,:,2) + 0.25*img(:,:,3);
elseif (g>r & g>b)
    grayscale = 0.25*img(:,:,1) + 0.5*img(:,:,2) + 0.25*img(:,:,3);
else
    grayscale = 0.25*img(:,:,1) + 0.25*img(:,:,2) + 0.5*img(:,:,3);
end
axes(handles.axes1);
imshow(grayscale);

% --- Executes on button press in btn_zoomIn.
function btn_zoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isempty(get(handles.axes1, 'Children'))) 
    errordlg('Select image first.');
end
img = getimage(handles.axes1);
if size(img,3)==1
    img = imread(get(handles.imgName,'String'));
end
imsize = size(img);
[zoomR,zoomG,zoomB] = deal([]);
for i = 1:imsize(1)
    [r,g,b] = deal([]);
    for j = 1:imsize(2)
        r = [r img(i,j,1) img(i,j,1)];
        g = [g img(i,j,2) img(i,j,2)];
        b = [b img(i,j,3) img(i,j,3)];
    end
    zoomR = [zoomR;r;r];
    zoomG = [zoomG;g;g];
    zoomB = [zoomB;b;b];
end 

zoomInImg = cat(3,zoomR,zoomG,zoomB);
axes(handles.axes1);
imshow(zoomInImg((imsize(1)/2):(imsize(1)+imsize(1)/2),(imsize(2)/2):(imsize(2)+imsize(2)/2),:));

% --- Executes on button press in btn_zoomOut.
function btn_zoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isempty(get(handles.axes1, 'Children'))) 
    errordlg('Select image first.');
end
img = getimage(handles.axes1);
if size(img,3)==1 
    img = imread(get(handles.imgName,'String'));
end
imsize = size(img);
height = imsize(1);
width = imsize(2);
[zoomR,zoomG,zoomB] = deal([]);
h = 1;

while h<height
    [r,g,b] = deal([]);
    w = 1;
    while w<width
        r = [r round(mean(mean(img(h:h+1,w:w+1,1))))];
        g = [g round(mean(mean(img(h:h+1,w:w+1,2))))];
        b = [b round(mean(mean(img(h:h+1,w:w+1,3))))];
        w = w+2;
    end
    zoomR = [zoomR;r];
    zoomG = [zoomG;g];
    zoomB = [zoomB;b];
    h = h+2;
end
zoomOutImg = cat(3,zoomR,zoomG,zoomB);
zoomOutImg = uint8(zoomOutImg);
padded = padarray(zoomOutImg,[100 100],255);
axes(handles.axes1);
imshow(padded,'InitialMagnification','fit');

% --- Executes on button press in btn_invers.
function btn_invers_Callback(hObject, eventdata, handles)
% hObject    handle to btn_invers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isempty(get(handles.axes1, 'Children'))) 
    errordlg('Select image first.');
end
img = getimage(handles.axes1);
imginvers = 255 - img;
axes(handles.axes1);
imshow(imginvers);

h = imginvers(:,:,1);
[x,y]=size(h);

tR=1:256;
nR=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tR(z)=count;
    count=0;
end

axes(handles.axHistR);
plot(nR,tR,'r'); 
xlim([1 256]);
% ylim([0 4000]);
title('Red Histogram');

h = imginvers(:,:,2);
[x,y]=size(h);

tG=1:256;
nG=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tG(z)=count;
    count=0;
end

axes(handles.axHistG);
plot(nG,tG,'g'); 
xlim([1 256]);
% ylim([0 4000]);
title('Green Histogram');

h = imginvers(:,:,3);
[x,y]=size(h);

tB=1:256;
nB=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tB(z)=count;
    count=0;
end

axes(handles.axHistB);
plot(nB,tB,'b'); 
xlim([1 256]);
% ylim([0 4000]);
title('Blue Histogram');

% --- Executes on button press in btn_original.
function btn_original_Callback(hObject, eventdata, handles)
% hObject    handle to btn_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.imgName,'String')) 
    img = imread(get(handles.imgName,'String'));
    axes(handles.axes1);
    imshow(img);
    
    h = img(:,:,1);
    [x,y]=size(h);

    tR=1:256;
    nR=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tR(z)=count;
        count=0;
    end

    axes(handles.axHistR);
    plot(nR,tR,'r'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Red Histogram');

    h = img(:,:,2);
    [x,y]=size(h);

    tG=1:256;
    nG=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tG(z)=count;
        count=0;
    end

    axes(handles.axHistG);
    plot(nG,tG,'g'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Green Histogram');

    h = img(:,:,3);
    [x,y]=size(h);

    tB=1:256;
    nB=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tB(z)=count;
        count=0;
    end

    axes(handles.axHistB);
    plot(nB,tB,'b'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Blue Histogram');
end


% --- Executes on button press in btnBrigtnessPlus.
function btnBrigtnessPlus_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrigtnessPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.brightnessVal,'String'));
check = get(handles.brightnessVal,'String')
if isempty(check)    
    errordlg('Enter brigtness value.');
else
   img = getimage(handles.axes1);
   imgBright = img + val;
   axes(handles.axes1);
   imshow(imgBright);
   
   h = imgBright(:,:,1);
    [x,y]=size(h);

    tR=1:256;
    nR=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tR(z)=count;
        count=0;
    end

    axes(handles.axHistR);
    plot(nR,tR,'r'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Red Histogram');

    h = imgBright(:,:,2);
    [x,y]=size(h);

    tG=1:256;
    nG=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tG(z)=count;
        count=0;
    end

    axes(handles.axHistG);
    plot(nG,tG,'g'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Green Histogram');

    h = imgBright(:,:,3);
    [x,y]=size(h);

    tB=1:256;
    nB=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tB(z)=count;
        count=0;
    end

    axes(handles.axHistB);
    plot(nB,tB,'b'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Blue Histogram');

end


% --- Executes on button press in btnBrigtnessMin.
function btnBrigtnessMin_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrigtnessMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.brightnessVal,'String'));
check = get(handles.brightnessVal,'String')
if isempty(check)    
    errordlg('Enter brigtness value.');
else
   img = getimage(handles.axes1);
   imgBright = img - val;
   axes(handles.axes1);
   imshow(imgBright);
   h = imgBright(:,:,1);
    [x,y]=size(h);

    tR=1:256;
    nR=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tR(z)=count;
        count=0;
    end

    axes(handles.axHistR);
    plot(nR,tR,'r'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Red Histogram');

    h = imgBright(:,:,2);
    [x,y]=size(h);

    tG=1:256;
    nG=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tG(z)=count;
        count=0;
    end

    axes(handles.axHistG);
    plot(nG,tG,'g'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Green Histogram');

    h = imgBright(:,:,3);
    [x,y]=size(h);

    tB=1:256;
    nB=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tB(z)=count;
        count=0;
    end

    axes(handles.axHistB);
    plot(nB,tB,'b'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Blue Histogram');

end

% --- Executes on button press in btnBrigtnessMult.
function btnBrigtnessMult_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrigtnessMult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.brightnessVal,'String'));
check = get(handles.brightnessVal,'String')
if isempty(check)    
    errordlg('Enter brigtness value.');
else
   img = getimage(handles.axes1);
   imgBright = img * val;
   axes(handles.axes1);
   imshow(imgBright);
   
   h = imgBright(:,:,1);
    [x,y]=size(h);

    tR=1:256;
    nR=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tR(z)=count;
        count=0;
    end

    axes(handles.axHistR);
    plot(nR,tR,'r'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Red Histogram');

    h = imgBright(:,:,2);
    [x,y]=size(h);

    tG=1:256;
    nG=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tG(z)=count;
        count=0;
    end

    axes(handles.axHistG);
    plot(nG,tG,'g'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Green Histogram');

    h = imgBright(:,:,3);
    [x,y]=size(h);

    tB=1:256;
    nB=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tB(z)=count;
        count=0;
    end

    axes(handles.axHistB);
    plot(nB,tB,'b'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Blue Histogram');

end

% --- Executes on button press in btnBrigtnessDiv.
function btnBrigtnessDiv_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrigtnessDiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.brightnessVal,'String'));
check = get(handles.brightnessVal,'String')
if isempty(check)    
    errordlg('Enter brigtness value.');
else
    img = getimage(handles.axes1);
    imgBright = img / val;
    axes(handles.axes1);
    imshow(imgBright);

    h = imgBright(:,:,1);
    [x,y]=size(h);

    tR=1:256;
    nR=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tR(z)=count;
        count=0;
    end

    axes(handles.axHistR);
    plot(nR,tR,'r'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Red Histogram');

    h = imgBright(:,:,2);
    [x,y]=size(h);

    tG=1:256;
    nG=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tG(z)=count;
        count=0;
    end

    axes(handles.axHistG);
    plot(nG,tG,'g'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Green Histogram');

    h = imgBright(:,:,3);
    [x,y]=size(h);

    tB=1:256;
    nB=0:255;
    count=0;

    for z=1:256
        for i=1:x
            for j=1:y
                if h(i,j)==z-1
                    count=count+1;
                end
            end
        end
        tB(z)=count;
        count=0;
    end

    axes(handles.axHistB);
    plot(nB,tB,'b'); 
    xlim([1 256]);
    % ylim([0 4000]);
    title('Blue Histogram');
end

% --- Executes on button press in btnHorizontalFlip.
function btnHorizontalFlip_Callback(hObject, eventdata, handles)
% hObject    handle to btnHorizontalFlip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
imsize = size(img)
width = imsize(2);
[flipR,flipG,flipB] = deal([]);
for i=width:-1:1
    flipR = [flipR img(:,i,1)];
    flipG = [flipG img(:,i,2)];
    flipB = [flipB img(:,i,3)];
end
imgFlip = cat(3,flipR,flipG,flipB);
axes(handles.axes1);
imshow(imgFlip);

% --- Executes on button press in btnVerticalFlip.
function btnVerticalFlip_Callback(hObject, eventdata, handles)
% hObject    handle to btnVerticalFlip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
imsize = size(img)
height = imsize(2);
[flipR,flipG,flipB] = deal([]);
for i=height:-1:1
    flipR = [flipR;img(i,:,1)];
    flipG = [flipG;img(i,:,2)];
    flipB = [flipB;img(i,:,3)];
end
imgFlip = cat(3,flipR,flipG,flipB);
axes(handles.axes1);
imshow(imgFlip);

% --- Executes on button press in btnCrop.
function btnCrop_Callback(hObject, eventdata, handles)
% hObject    handle to btnCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = imread(get(handles.imgName,'String'));
w1 = str2num(['uint8(',get(handles.w1,'String'),')']);
w2 = str2num(['uint8(',get(handles.w2,'String'),')']);
h1 = str2num(['uint8(',get(handles.h1,'String'),')']);
h2 = str2num(['uint8(',get(handles.h2,'String'),')']);
imsize = size(img);
axes(handles.axes1);
imshow(img(h1:h2,w1:w2,:));

img = getimage(handles.axes1);
h = img(:,:,1);
[x,y]=size(h);

tR=1:256;
nR=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tR(z)=count;
    count=0;
end

axes(handles.axHistR);
plot(nR,tR,'r'); 
xlim([1 256]);
% ylim([0 4000]);
title('Red Histogram');

h = img(:,:,2);
[x,y]=size(h);

tG=1:256;
nG=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tG(z)=count;
    count=0;
end

axes(handles.axHistG);
plot(nG,tG,'g'); 
xlim([1 256]);
% ylim([0 4000]);
title('Green Histogram');

h = img(:,:,3);
[x,y]=size(h);

tB=1:256;
nB=0:255;
count=0;

for z=1:256
    for i=1:x
        for j=1:y
            if h(i,j)==z-1
                count=count+1;
            end
        end
    end
    tB(z)=count;
    count=0;
end

axes(handles.axHistB);
plot(nB,tB,'b'); 
xlim([1 256]);
% ylim([0 4000]);
title('Blue Histogram');


function brightnessVal_Callback(hObject, eventdata, handles)
% hObject    handle to brightnessVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brightnessVal as text
%        str2double(get(hObject,'String')) returns contents of brightnessVal as a double


% --- Executes during object creation, after setting all properties.
function brightnessVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightnessVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w1_Callback(hObject, eventdata, handles)
% hObject    handle to w1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w1 as text
%        str2double(get(hObject,'String')) returns contents of w1 as a double


% --- Executes during object creation, after setting all properties.
function w1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w2_Callback(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w2 as text
%        str2double(get(hObject,'String')) returns contents of w2 as a double


% --- Executes during object creation, after setting all properties.
function w2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h1_Callback(hObject, eventdata, handles)
% hObject    handle to h1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h1 as text
%        str2double(get(hObject,'String')) returns contents of h1 as a double


% --- Executes during object creation, after setting all properties.
function h1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h2_Callback(hObject, eventdata, handles)
% hObject    handle to h2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h2 as text
%        str2double(get(hObject,'String')) returns contents of h2 as a double


% --- Executes during object creation, after setting all properties.
function h2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnRotate.
function btnRotate_Callback(hObject, eventdata, handles)
% hObject    handle to btnRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
[rowsi,colsi,z]= size(img); 

check = get(handles.rotVal,'String')
if isempty(check)    
    errordlg('Enter rotation degree.');
    angle = 0;
else
   angle = str2double(get(handles.rotVal,'String'));
end

rads=2*pi*angle/360;  

rowsf=ceil(rowsi*abs(cos(rads))+colsi*abs(sin(rads)));                      
colsf=ceil(rowsi*abs(sin(rads))+colsi*abs(cos(rads)));                     

C=uint8(zeros([rowsf colsf 3 ]));

xo=ceil(rowsi/2);                                                            
yo=ceil(colsi/2);

midx=ceil((size(C,1))/2);
midy=ceil((size(C,2))/2);

for i=1:size(C,1)
    for j=1:size(C,2)                                                       

         x= (i-midx)*cos(rads)+(j-midy)*sin(rads);                                       
         y= -(i-midx)*sin(rads)+(j-midy)*cos(rads);                             
         x=round(x)+xo;
         y=round(y)+yo;

         if (x>=1 && y>=1 && x<=size(img,1) &&  y<=size(img,2) ) 
              C(i,j,:)=img(x,y,:);  
         end

    end
end

axes(handles.axes1);
imshow(C);

function rotVal_Callback(hObject, eventdata, handles)
% hObject    handle to rotVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotVal as text
%        str2double(get(hObject,'String')) returns contents of rotVal as a double


% --- Executes during object creation, after setting all properties.
function rotVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv1_Callback(hObject, eventdata, handles)
% hObject    handle to conv1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv1 as text
%        str2double(get(hObject,'String')) returns contents of conv1 as a double


% --- Executes during object creation, after setting all properties.
function conv1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv2_Callback(hObject, eventdata, handles)
% hObject    handle to conv2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv2 as text
%        str2double(get(hObject,'String')) returns contents of conv2 as a double


% --- Executes during object creation, after setting all properties.
function conv2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv3_Callback(hObject, eventdata, handles)
% hObject    handle to conv3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv3 as text
%        str2double(get(hObject,'String')) returns contents of conv3 as a double


% --- Executes during object creation, after setting all properties.
function conv3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv4_Callback(hObject, eventdata, handles)
% hObject    handle to conv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv4 as text
%        str2double(get(hObject,'String')) returns contents of conv4 as a double


% --- Executes during object creation, after setting all properties.
function conv4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv5_Callback(hObject, eventdata, handles)
% hObject    handle to conv5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv5 as text
%        str2double(get(hObject,'String')) returns contents of conv5 as a double


% --- Executes during object creation, after setting all properties.
function conv5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv6_Callback(hObject, eventdata, handles)
% hObject    handle to conv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv6 as text
%        str2double(get(hObject,'String')) returns contents of conv6 as a double


% --- Executes during object creation, after setting all properties.
function conv6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv7_Callback(hObject, eventdata, handles)
% hObject    handle to conv7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv7 as text
%        str2double(get(hObject,'String')) returns contents of conv7 as a double


% --- Executes during object creation, after setting all properties.
function conv7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv8_Callback(hObject, eventdata, handles)
% hObject    handle to conv8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv8 as text
%        str2double(get(hObject,'String')) returns contents of conv8 as a double


% --- Executes during object creation, after setting all properties.
function conv8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conv9_Callback(hObject, eventdata, handles)
% hObject    handle to conv9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conv9 as text
%        str2double(get(hObject,'String')) returns contents of conv9 as a double


% --- Executes during object creation, after setting all properties.
function conv9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conv9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBlur.
function btnBlur_Callback(hObject, eventdata, handles)
% hObject    handle to btnBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
c = 1/9*[1 1 1;1 1 1;1 1 1];

img = padarray(img,[1 1],0,'both');
imsize = size(img);
height = imsize(1);
width = imsize(2);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

convR = zeros(height,width);
convG = zeros(height,width);
convB = zeros(height,width);

for i=2:width-1
    for j=2:height-1
        convR(i,j) = sum(sum(c.*double(imgR(i-1:i+1,j-1:j+1))));
        convG(i,j) = sum(sum(c.*double(imgG(i-1:i+1,j-1:j+1))));
        convB(i,j) = sum(sum(c.*double(imgB(i-1:i+1,j-1:j+1))));
    end
end

imgBlur = cat(3,convR(2:height-1,2:width-1),convG(2:height-1,2:width-1),convB(2:height-1,2:width-1));
imgBlur = uint8(imgBlur);
axes(handles.axes1);
imshow(imgBlur);


% --- Executes on button press in btnSharp.
function btnSharp_Callback(hObject, eventdata, handles)
% hObject    handle to btnSharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
c = [0 -1 0;-1 5 -1;0 -1 0];

img = padarray(img,[1 1],0,'both');
imsize = size(img);
height = imsize(1);
width = imsize(2);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

convR = zeros(height,width);
convG = conv2(imgG,c,'same');
convB = conv2(imgB,c,'same');

for i=2:width-1
    for j=2:height-1
        convR(i,j) = sum(sum(c.*double(imgR(i-1:i+1,j-1:j+1))));
        convG(i,j) = sum(sum(c.*double(imgG(i-1:i+1,j-1:j+1))));
        convB(i,j) = sum(sum(c.*double(imgB(i-1:i+1,j-1:j+1))));
    end
end

imgSharp = cat(3,convR(2:height-1,2:width-1),convG(2:height-1,2:width-1),convB(2:height-1,2:width-1));
imgSharp = uint8(imgSharp);
axes(handles.axes1);
imshow(imgSharp);

% --- Executes on button press in btnEdge.
function btnEdge_Callback(hObject, eventdata, handles)
% hObject    handle to btnEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
c = [-1 -1 -1;-1 8 -1;-1 -1 -1];

img = padarray(img,[1 1],0,'both');
imsize = size(img);
height = imsize(1);
width = imsize(2);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

convR = zeros(height,width);
convG = conv2(imgG,c,'same');
convB = conv2(imgB,c,'same');

for i=2:width-1
    for j=2:height-1
        convR(i,j) = sum(sum(c.*double(imgR(i-1:i+1,j-1:j+1))));
        convG(i,j) = sum(sum(c.*double(imgG(i-1:i+1,j-1:j+1))));
        convB(i,j) = sum(sum(c.*double(imgB(i-1:i+1,j-1:j+1))));
    end
end

imgEdge = cat(3,convR(2:height-1,2:width-1),convG(2:height-1,2:width-1),convB(2:height-1,2:width-1));
imgEdge = uint8(imgEdge);
axes(handles.axes1);
imshow(imgEdge);

% --- Executes on button press in btnConv.
function btnConv_Callback(hObject, eventdata, handles)
% hObject    handle to btnConv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val1 = str2double(get(handles.conv1,'String'));
val2 = str2double(get(handles.conv2,'String'));
val3 = str2double(get(handles.conv3,'String'));
val4 = str2double(get(handles.conv4,'String'));
val5 = str2double(get(handles.conv5,'String'));
val6 = str2double(get(handles.conv6,'String'));
val7 = str2double(get(handles.conv7,'String'));
val8 = str2double(get(handles.conv8,'String'));
val9 = str2double(get(handles.conv9,'String'));

c = [val1 val2 val3;val4 val5 val6;val7 val8 val9];

img = getimage(handles.axes1);

img = padarray(img,[1 1],0,'both');
imsize = size(img);
height = imsize(1);
width = imsize(2);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

convR = zeros(height,width);
convG = zeros(height,width);
convB = zeros(height,width);

for i=2:width-1
    for j=2:height-1
        convR(i,j) = sum(sum(c.*double(imgR(i-1:i+1,j-1:j+1))));
        convG(i,j) = sum(sum(c.*double(imgG(i-1:i+1,j-1:j+1))));
        convB(i,j) = sum(sum(c.*double(imgB(i-1:i+1,j-1:j+1))));
    end
end

imgConv = cat(3,convR(2:height-1,2:width-1),convG(2:height-1,2:width-1),convB(2:height-1,2:width-1));
imgConv = uint8(imgConv);
axes(handles.axes1);
imshow(imgConv);
