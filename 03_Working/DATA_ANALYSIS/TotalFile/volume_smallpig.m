function varargout = volume_smallpig(varargin)
% VOLUME_SMALLPIG MATLAB code for volume_smallpig.fig
%      VOLUME_SMALLPIG, by itself, creates a new VOLUME_SMALLPIG or raises the existing
%      singleton*.
%
%      H = VOLUME_SMALLPIG returns the handle to a new VOLUME_SMALLPIG or the handle to
%      the existing singleton*.
%
%      VOLUME_SMALLPIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLUME_SMALLPIG.M with the given input arguments.
%
%      VOLUME_SMALLPIG('Property','Value',...) creates a new VOLUME_SMALLPIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before volume_smallpig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to volume_smallpig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help volume_smallpig

% Last Modified by GUIDE v2.5 17-Mar-2017 06:42:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @volume_smallpig_OpeningFcn, ...
                   'gui_OutputFcn',  @volume_smallpig_OutputFcn, ...
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


% --- Executes just before volume_smallpig is made visible.
function volume_smallpig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to volume_smallpig (see VARARGIN)

% Choose default command line output for volume_smallpig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes volume_smallpig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = volume_smallpig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
    axes(handles.axes1);
    imshow('tesa.jpg');
    title('Original image');
    
     axes(handles.axes2);
    imshow('topgun.jpg');
    title('final image');


function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double


% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ratio_Callback(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratio as text
%        str2double(get(hObject,'String')) returns contents of ratio as a double


% --- Executes during object creation, after setting all properties.
function ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enter.
function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    src='durainpi.jpg';
    I = imread(src);
    BW = im2bw(I,0.53);
    BW = not(BW);
    BW_filled = imfill(BW,'holes');
    
    handles.output = hObject;
    axes(handles.axes1);
    imshow(I);
    title('Original image');
    %% new method
    I2 = imgaussfilt(I);
    imgray2=rgb2gray(I2);


    J = imnoise(imgray2,'salt & pepper',0.02);
    imgray = medfilt2(J);

    BW2 = bwareaopen(BW, 300);%≈∫ ’¢“«
    axes(handles.axes2);
    imshow(BW2);
    title('final image');
       
    NumberOnRealWorld=str2num(get(handles.scaleR,'String'));
    NumberOnPixel=str2num(get(handles.scaleP,'String'));
    scallingPix=NumberOnRealWorld/NumberOnPixel;
    
    %% Find Volume
    [heigh,wide,z1] = size(BW2);
    valArea = 1:wide;
    valR = 1:wide;
    valRFalse = 1:wide;
    volume = 0;
    checkFirstCol = 0;
    firstCol  = 0;
    checkLastCol = 0;
    lastCol  = 0;
    minRow = heigh;
    maxRow = 0;


    for col=1:wide
        countPixel = 0;
       for row=1:heigh              
           if BW2(row,col) == 1
                countPixel = countPixel +1 ;            
                if checkFirstCol == 0 
                    checkFirstCol = 1;
                    firstCol = col;                
                end             
                if maxRow < row
                    maxRow = row;
                end            
                if minRow > row
                    minRow = row;
                end
           end
       end    
       if countPixel < 120  && checkFirstCol == 1 && checkLastCol == 0 && col > firstCol + 90
           checkLastCol = 1;
           lastCol = col;
       end          
        r = countPixel/2.0;
        realR = r*scallingPix;
        area = 3.14*realR*realR*scallingPix;    
        valRFalse(col) = r;
        valR(col) = realR;
        valArea(col) = area;    
        if countPixel > 100
            volume = volume + area;
        end

    end

    txt = fprintf('\n Area = %.2f cm^3 \n', volume);

    widthDurian = (maxRow - minRow) * scallingPix
    heightDurian = (lastCol - firstCol) * scallingPix  
    ratio=heightDurian/widthDurian

     set(handles.volume,'String',volume);
    set(handles.ratio,'String',ratio);
    set(handles.height,'String', heightDurian);
    set(handles.width,'String',widthDurian);
    
    set(handles.imsrc,'String',src);

function scaleR_Callback(hObject, eventdata, handles)
% hObject    handle to scaleR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleR as text
%        str2double(get(hObject,'String')) returns contents of scaleR as a double


% --- Executes during object creation, after setting all properties.
function scaleR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imsrc_Callback(hObject, eventdata, handles)
% hObject    handle to imsrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imsrc as text
%        str2double(get(hObject,'String')) returns contents of imsrc as a double


% --- Executes during object creation, after setting all properties.
function imsrc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imsrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scaleP_Callback(hObject, eventdata, handles)
% hObject    handle to scaleP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleP as text
%        str2double(get(hObject,'String')) returns contents of scaleP as a double


% --- Executes during object creation, after setting all properties.
function scaleP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
