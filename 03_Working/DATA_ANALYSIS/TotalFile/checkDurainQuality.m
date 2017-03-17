function varargout = checkDurainQuality(varargin)
% CHECKDURAINQUALITY MATLAB code for checkDurainQuality.fig
%      CHECKDURAINQUALITY, by itself, creates a new CHECKDURAINQUALITY or raises the existing
%      singleton*.
%
%      H = CHECKDURAINQUALITY returns the handle to a new CHECKDURAINQUALITY or the handle to
%      the existing singleton*.
%
%      CHECKDURAINQUALITY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECKDURAINQUALITY.M with the given input arguments.
%
%      CHECKDURAINQUALITY('Property','Value',...) creates a new CHECKDURAINQUALITY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before checkDurainQuality_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to checkDurainQuality_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help checkDurainQuality

% Last Modified by GUIDE v2.5 17-Mar-2017 10:01:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @checkDurainQuality_OpeningFcn, ...
                   'gui_OutputFcn',  @checkDurainQuality_OutputFcn, ...
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


% --- Executes just before checkDurainQuality is made visible.
function checkDurainQuality_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to checkDurainQuality (see VARARGIN)

% Choose default command line output for checkDurainQuality
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

nameFile = 'ทุเรียนติดโรค.jpg';
set(handles.name,'String',nameFile);

% UIWAIT makes checkDurainQuality wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = checkDurainQuality_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in enter.
function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nameFile = 'ทุเรียนติดโรค.jpg';

    axes(handles.axes1);
    imshow(nameFile);
    title('Original image');
    
    
    
command = ['python classifyDurian.py ',nameFile];
[status,cmdout] = system(command)
set(handles.listbox1,'String',cmdout);



function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function good_Callback(hObject, eventdata, handles)
% hObject    handle to good (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of good as text
%        str2double(get(hObject,'String')) returns contents of good as a double


% --- Executes during object creation, after setting all properties.
function good_CreateFcn(hObject, eventdata, handles)
% hObject    handle to good (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bad_Callback(hObject, eventdata, handles)
% hObject    handle to bad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bad as text
%        str2double(get(hObject,'String')) returns contents of bad as a double


% --- Executes during object creation, after setting all properties.
function bad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conclusion_Callback(hObject, eventdata, handles)
% hObject    handle to conclusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conclusion as text
%        str2double(get(hObject,'String')) returns contents of conclusion as a double


% --- Executes during object creation, after setting all properties.
function conclusion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conclusion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
