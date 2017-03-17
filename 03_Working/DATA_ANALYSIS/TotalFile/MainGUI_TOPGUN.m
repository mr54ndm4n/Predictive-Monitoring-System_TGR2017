function varargout = MainGUI_TOPGUN(varargin)
% MAINGUI_TOPGUN MATLAB code for MainGUI_TOPGUN.fig
%      MAINGUI_TOPGUN, by itself, creates a new MAINGUI_TOPGUN or raises the existing
%      singleton*.
%
%      H = MAINGUI_TOPGUN returns the handle to a new MAINGUI_TOPGUN or the handle to
%      the existing singleton*.
%
%      MAINGUI_TOPGUN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI_TOPGUN.M with the given input arguments.
%
%      MAINGUI_TOPGUN('Property','Value',...) creates a new MAINGUI_TOPGUN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_TOPGUN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_TOPGUN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI_TOPGUN

% Last Modified by GUIDE v2.5 17-Mar-2017 12:20:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_TOPGUN_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_TOPGUN_OutputFcn, ...
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


% --- Executes just before MainGUI_TOPGUN is made visible.
function MainGUI_TOPGUN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI_TOPGUN (see VARARGIN)

% Choose default command line output for MainGUI_TOPGUN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

handles.output = hObject;
    a = imread('topgun.jpg'); %อ่านรูป rice.png เข้ามาในตัวแปร a
    axes(handles.axes1)
    imshow(a);
    b = imread('tesa.jpg'); %อ่านรูป perppers.png เข้ามาในตัวแปร b
    axes(handles.axes2)
    imshow(b);
   
    
% handles.a=a;  


% UIWAIT makes MainGUI_TOPGUN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_TOPGUN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Valume.
function Valume_Callback(hObject, eventdata, handles)
% hObject    handle to Valume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
volume_smallpig('title,confirm close');

% --- Executes on button press in count.
function count_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_segmentation5;

% --- Executes on button press in Watering.
function Watering_Callback(hObject, eventdata, handles)
% hObject    handle to Watering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Matlab_WeatherForecast('title,confirm close');


% --- Executes on button press in disease.
function disease_Callback(hObject, eventdata, handles)
% hObject    handle to disease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkDurainQuality('title,confirm close');


% --- Executes on button press in calculation.
function calculation_Callback(hObject, eventdata, handles)
% hObject    handle to calculation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
calculation_moisturizer('title,confirm close');
