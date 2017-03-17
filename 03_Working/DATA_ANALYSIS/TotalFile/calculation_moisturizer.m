function varargout = calculation_moisturizer(varargin)
% CALCULATION_MOISTURIZER MATLAB code for calculation_moisturizer.fig
%      CALCULATION_MOISTURIZER, by itself, creates a new CALCULATION_MOISTURIZER or raises the existing
%      singleton*.
%
%      H = CALCULATION_MOISTURIZER returns the handle to a new CALCULATION_MOISTURIZER or the handle to
%      the existing singleton*.
%
%      CALCULATION_MOISTURIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATION_MOISTURIZER.M with the given input arguments.
%
%      CALCULATION_MOISTURIZER('Property','Value',...) creates a new CALCULATION_MOISTURIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calculation_moisturizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calculation_moisturizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calculation_moisturizer

% Last Modified by GUIDE v2.5 17-Mar-2017 11:55:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calculation_moisturizer_OpeningFcn, ...
                   'gui_OutputFcn',  @calculation_moisturizer_OutputFcn, ...
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


% --- Executes just before calculation_moisturizer is made visible.
function calculation_moisturizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calculation_moisturizer (see VARARGIN)

% Choose default command line output for calculation_moisturizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
X1 = [80 70 70 60 55 50 40 30 10 6 80 100 100 90 85 100 ];%% dummy value
X = [80 70 70 60 55 50 40 30 10 6 80 100 100 90 85  ];
Z = [2 3 4 5 6 8 10 12 14 16 18 20 22 24 26 ];
% Y = 0:14
Y =diff(X1) 
[minV,minI] = min(Y); 
[maxV,maxI] = max(Y);
axes(handles.axes1);
plot(Z,X);
title('sensor read');
axes(handles.axes2);
plot(Z,Y);
title('diff sensor read');




% UIWAIT makes calculation_moisturizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calculation_moisturizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
