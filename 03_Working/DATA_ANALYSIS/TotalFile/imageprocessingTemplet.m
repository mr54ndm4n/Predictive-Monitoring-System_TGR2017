function varargout = imageprocessingTemplet(varargin)
% IMAGEPROCESSINGTEMPLET MATLAB code for imageprocessingTemplet.fig
%      IMAGEPROCESSINGTEMPLET, by itself, creates a new IMAGEPROCESSINGTEMPLET or raises the existing
%      singleton*.
%
%      H = IMAGEPROCESSINGTEMPLET returns the handle to a new IMAGEPROCESSINGTEMPLET or the handle to
%      the existing singleton*.
%
%      IMAGEPROCESSINGTEMPLET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEPROCESSINGTEMPLET.M with the given input arguments.
%
%      IMAGEPROCESSINGTEMPLET('Property','Value',...) creates a new IMAGEPROCESSINGTEMPLET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageprocessingTemplet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageprocessingTemplet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageprocessingTemplet

% Last Modified by GUIDE v2.5 15-Mar-2017 02:03:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageprocessingTemplet_OpeningFcn, ...
                   'gui_OutputFcn',  @imageprocessingTemplet_OutputFcn, ...
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


% --- Executes just before imageprocessingTemplet is made visible.
function imageprocessingTemplet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageprocessingTemplet (see VARARGIN)

% Choose default command line output for imageprocessingTemplet
handles.output = hObject;
   a = imread('pencil.jpg'); %อ่านรูป rice.png เข้ามาในตัวแปร a
  axes(handles.axes1)
    imshow(a);
    b = imread('box2.jpg'); %อ่านรูป perppers.png เข้ามาในตัวแปร b
    axes(handles.axes2)
    imshow(b);
     x =imread('rgb.PNG');
     axes(handles.axes3)
 imshow(x);
  handles.a=a;  

% Update handles structure
guidata(hObject, handles);
 
  
% UIWAIT makes imageprocessingTemplet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageprocessingTemplet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function imagename_Callback(hObject, eventdata, handles)
% hObject    handle to imagename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagename as text
%        str2double(get(hObject,'String')) returns contents of imagename as a double


% --- Executes during object creation, after setting all properties.
function imagename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
