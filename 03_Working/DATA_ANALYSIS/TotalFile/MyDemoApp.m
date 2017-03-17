function varargout = MyDemoApp(varargin)
% MYDEMOAPP MATLAB code for MyDemoApp.fig
%      MYDEMOAPP, by itself, creates a new MYDEMOAPP or raises the existing
%      singleton*.
%
%      H = MYDEMOAPP returns the handle to a new MYDEMOAPP or the handle to
%      the existing singleton*.
%
%      MYDEMOAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYDEMOAPP.M with the given input arguments.
%
%      MYDEMOAPP('Property','Value',...) creates a new MYDEMOAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MyDemoApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MyDemoApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MyDemoApp

% Last Modified by GUIDE v2.5 14-Mar-2017 14:04:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyDemoApp_OpeningFcn, ...
                   'gui_OutputFcn',  @MyDemoApp_OutputFcn, ...
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


% --- Executes just before MyDemoApp is made visible.
function MyDemoApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MyDemoApp (see VARARGIN)

% Choose default command line output for MyDemoApp
handles.output = hObject;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyDemoApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MyDemoApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


t=0:0.1:2*pi;
w= str2num(handles.FreqVal.String);
y=sin(w*t);
plot(t,y);
handles.t=t;

guidata(hObject,handles);


function FreqVal_Callback(hObject, eventdata, handles)
% hObject    handle to FreqVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FreqVal as text
%        str2double(get(hObject,'String')) returns contents of FreqVal as a double


% --- Executes during object creation, after setting all properties.
function FreqVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FreqVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
