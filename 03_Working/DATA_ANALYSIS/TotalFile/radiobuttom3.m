function varargout = radiobuttom3(varargin)
% RADIOBUTTOM3 MATLAB code for radiobuttom3.fig
%      RADIOBUTTOM3, by itself, creates a new RADIOBUTTOM3 or raises the existing
%      singleton*.
%
%      H = RADIOBUTTOM3 returns the handle to a new RADIOBUTTOM3 or the handle to
%      the existing singleton*.
%
%      RADIOBUTTOM3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RADIOBUTTOM3.M with the given input arguments.
%
%      RADIOBUTTOM3('Property','Value',...) creates a new RADIOBUTTOM3 or raises the
%      existing singleton*.  Startigng from the left, property value pairs are
%      applied to the GUI before radiobuttom3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to radiobuttom3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help radiobuttom3

% Last Modified by GUIDE v2.5 15-Mar-2017 01:41:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @radiobuttom3_OpeningFcn, ...
                   'gui_OutputFcn',  @radiobuttom3_OutputFcn, ...
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


% --- Executes just before radiobuttom3 is made visible.
function radiobuttom3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to radiobuttom3 (see VARARGIN)

% Choose default command line output for radiobuttom3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
 x =imread('rgb.PNG');
 imshow(x);
% UIWAIT makes radiobuttom3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = radiobuttom3_OutputFcn(hObject, eventdata, handles) 



% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.a %hObject ตัวแปรเอาไว้จัดการรูป ถ้ารับค่ามาเป็น Rice ให้ทำงานดังนี้
    a = imread('pencil.jpg'); %อ่านรูป rice.png เข้ามาในตัวแปร a
    imshow(a); %แสดงรูปอยู่ในตัวแปร a

elseif hObject == handles.b %hObject ตัวแปรเอาไว้จัดการรูป ถ้ารับค่ามาเป็น Peppers ให้ทำงานดังนี้
    b = imread('box2.jpg'); %อ่านรูป perppers.png เข้ามาในตัวแปร b
    imshow(b); %แสดงรูปอยู่ในตัวแปร b
end
