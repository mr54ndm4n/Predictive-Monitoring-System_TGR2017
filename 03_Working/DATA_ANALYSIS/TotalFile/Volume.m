function varargout = Volume(varargin)
% VOLUME MATLAB code for Volume.fig
%      VOLUME, by itself, creates a new VOLUME or raises the existing
%      singleton*.
%
%      H = VOLUME returns the handle to a new VOLUME or the handle to
%      the existing singleton*.
%
%      VOLUME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLUME.M with the given input arguments.
%
%      VOLUME('Property','Value',...) creates a new VOLUME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Volume_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Volume_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Volume

% Last Modified by GUIDE v2.5 17-Mar-2017 05:39:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Volume_OpeningFcn, ...
                   'gui_OutputFcn',  @Volume_OutputFcn, ...
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


% --- Executes just before Volume is made visible.
function Volume_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Volume (see VARARGIN)

% Choose default command line output for Volume
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Volume wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Volume_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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
% hObject    handle to width145 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width145 as text
%        str2double(get(hObject,'String')) returns contents of width145 as a double


% --- Executes during object creation, after setting all properties.
function width145_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width145 (see GCBO)
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% PREPROCESSING
   
    
    %  Convert uint8 to double image type
   
    target_image = imread('ทุเรียน.jpg');    
    
     handles.output = hObject;
     axes(handles.axes1);
    imshow(target_image);
    title('Original image');
    image_double = im2double(target_image);
    %  Convert RGB to Gray scale
    image_gray = rgb2gray(target_image);
    image_adjust = imadjust(image_gray);    
    

 %% FEATURE EXTRACTION
%  edge --> boudary --> shape, volume, size
%  extract interest inforamtion from image

%  Edge detection.
    [~, th] = edge(image_gray, 'Canny');
    factors = 0.90;
    image_edge = edge(image_gray, 'Canny', th * factors);
    edge_panel = figure('Name', 'Edge Image');
   
  

%  Expand edge width145
    SE90 = strel('line', 10, 90);
    SE0 = strel('line', 10, 0);
    image_dilation = imdilate(image_edge, [SE90, SE0]);
   

CC = bwconncomp(image_dilation);
%  Fill hole in image
    image_filled = imfill(image_dilation, 'holes');
  

%  Clear border
    image_clear_border = imclearborder(image_filled, 8);
    

%  Perlim
    image_perlim = bwperim(image_clear_border);
    

%  Remove noise
    image_conncomp = bwconncomp(image_perlim);
    num_pixels = cellfun(@numel,image_conncomp.PixelIdxList);
    [biggest_size,idx] = max(num_pixels);
    image_final = false(size(image_clear_border));
    image_final(image_conncomp.PixelIdxList{idx}) = true;
    area = regionprops(image_final , 'Area');
    
%     image_final=imfill(image_final,'holes');
    imshow(image_final);
    axes(handles.axes2);
    imshow(image_final);
    title('Durian image');

    
    % Find volume
    scale_input=str2num(get(handles.scale,'String'));
    
    real_world_scale_cm=scale_input;
    image_scale_pixel=72;
    scalling=real_world_scale_cm/image_scale_pixel;
    d_size = size(image_final);
    d_weight_dive_by_2 = (d_size(2)/2);
    d_height_margin = 10;

    result = 0;
    for a =1:1:d_size(1)
        %disp(a)
        cen = image_final(a,d_weight_dive_by_2);
        lhs = 0;
        rhs = 0;
        for i = d_weight_dive_by_2:-1: 1
            if image_final(a,i) 
                %disp(i)
                lhs = i;
            end
            %disp(i)
        end
        for i = d_weight_dive_by_2:1: d_size(2)
            if image_final(a,i) 
                %disp(i)
                rhs = i;
            end
            %disp(i)
        end
        if rhs > 0
            r = (rhs - a)/2;
            real_r = r * scalling;
            result = result + (pi*real_r*real_r) * scalling;
        end
        if lhs > 0
            r = (a-lhs)/2;
            real_r = r * scalling;
            result = result + (pi * real_r * real_r)* scalling;
        end
    end
    
  %% Find width145 & Height
    heigh = 0;
    for i =1:1:d_size(1)
        for j =1:1:d_size(2)
            if image_final(i,j)
                heigh = heigh + 1;
                break
            end
        end    
    end    

weight =0;

    for i =1:1:d_size(2)
        for j =1:1:d_size(1)
            if image_final(j,i)
                weight = weight + 1;
                break
            end
        end    
    end

    real_height = heigh * scalling;
    real_width = weight * scalling;

    fprintf('Area : %.2f cm^ 2\n', pi * real_width * real_width / 4);
    fprintf('Height : %.2f cm\n', real_height);
    fprintf('Width : %.2f cm\n', real_width);
    fprintf('Ratio HEIGHT/WIDTH : %.3f\n', real_height / real_width);  
    fprintf('Volume : %.8f cm^3\n', result * 2);
 
    set(handles.volume,'String',result * 2);
    set(handles.ratio,'String',real_height / real_width);
    set(handles.height,'String',real_height);
    set(handles.width,'String',real_width);
    
    set(handles.imgesrc,'String','ทุเรียน.jpg');

  



function scale_Callback(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scale as text
%        str2double(get(hObject,'String')) returns contents of scale as a double


% --- Executes during object creation, after setting all properties.
function scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imgesrc_Callback(hObject, eventdata, handles)
% hObject    handle to imgesrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgesrc as text
%        str2double(get(hObject,'String')) returns contents of imgesrc as a double


% --- Executes during object creation, after setting all properties.
function imgesrc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgesrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
