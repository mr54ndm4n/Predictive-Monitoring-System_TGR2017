

function varargout = Matlab_WeatherForecast(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Matlab_WeatherForecast_OpeningFcn, ...
                   'gui_OutputFcn',  @Matlab_WeatherForecast_OutputFcn, ...
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


% --- Executes just before Matlab_WeatherForecast is made visible.
function Matlab_WeatherForecast_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Matlab_WeatherForecast (see VARARGIN)

% Choose default command line output for Matlab_WeatherForecast
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Matlab_WeatherForecast wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% QPF 5 day



% --- Outputs from this function are returned to the command line.
function varargout = Matlab_WeatherForecast_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function date1_Callback(hObject, eventdata, handles)
% hObject    handle to date1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of date1 as text
%        str2double(get(hObject,'String')) returns contents of date1 as a double


% --- Executes during object creation, after setting all properties.
function date1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function water_Callback(hObject, eventdata, handles)
% hObject    handle to water (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of water as text
%        str2double(get(hObject,'String')) returns contents of water as a double


% --- Executes during object creation, after setting all properties.
function water_CreateFcn(hObject, eventdata, handles)
% hObject    handle to water (see GCBO)
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
a=get(handles.listbox,'Value');
base_url='http://api.wunderground.com/api/b728a7436f25b9f2/forecast10day/q/TH/';
 if (a==1)
     
       provice_url='Nonthaburi.json';       
 elseif(a==2)
    
     provice_url='Rayong.json';
 else
     
     provice_url='Chanthaburi.json';
 end
 Url=[base_url,provice_url]
 
dataForecast = webread(Url)
valForecast = dataForecast.forecast;



    Rain=[dataForecast.forecast.simpleforecast.forecastday(1).qpf_allday.mm;...
          dataForecast.forecast.simpleforecast.forecastday(2).qpf_allday.mm;...
          dataForecast.forecast.simpleforecast.forecastday(3).qpf_allday.mm;...
          dataForecast.forecast.simpleforecast.forecastday(4).qpf_allday.mm;...
          dataForecast.forecast.simpleforecast.forecastday(5).qpf_allday.mm;...
        ];
 
    plot(1:5,Rain);
    xlabel('days');
    ylabel('qbf');

      if Rain(1)>1
         set(handles.water,'String','don''t wathering');
      else
         set(handles.water,'String','Wathering today ');
      end
  
%% Rain in Past
formatOut = 'yyyymmdd';

date = datestr(now,formatOut);
yearStr = [date(1),date(2),date(3),date(4)];
month = [date(5),date(6)];
day = [date(7),date(8)];
yearInt = str2num(yearStr);

dayInt = str2num(day);

day1 = int2str(dayInt);
day2 = int2str(dayInt-1);
day3 = int2str(dayInt+1);




count = 0;
for k=1:2
    
   yearInt = yearInt - 1;
   tempStr = int2str(yearInt);
   
   if day > 1
              
       url = ['http://api.wunderground.com/api/b728a7436f25b9f2/history_',tempStr,month,day1,'/q/TH/',provice_url];
       dataRainPast = webread(url);
       valRainPast = dataRainPast.history.dailysummary.rain;
       
       
      pastWheater =['time=',tempStr,'day =', day1,'RainValue= ',valRainPast,'\\n'];      
      set(handles.listboxdaypass,'String',pastWheater); 
            
     
       url = ['http://api.wunderground.com/api/b728a7436f25b9f2/history_',tempStr,month,day2,'/q/TH/',provice_url];
       dataRainPast = webread(url);
       valRainPast = dataRainPast.history.dailysummary.rain;       
       
      oldstr=get(handles.listboxdaypass,'String');      
      newstr = ['time = ',tempStr,'day = ', day2,'RainValue = ',valRainPast,'\\n']      
      pastWheater = srtvcat(oldstr,newstr);
      set(handles.listboxdaypass,'String',pastWheater); 
       if valRainPast == 1
            count = count + 1;
       end
   else
       
       url = ['http://api.wunderground.com/api/b728a7436f25b9f2/history_',tempStr,month,day1,'/q/TH/',provice_url];
       dataRainPast = webread(url);
       valRainPast = dataRainPast.history.dailysummary.rain;
       
      oldstr=get(handles.listboxdaypass,'String');      
      newstr=['time=',tempStr,'day =', day1,'RainValue= ',valRainPast,'\\n']      
      pastWheater =srtvcat(oldstr,newstr);
      set(handles.listboxdaypass,'String',pastWheater);  

        url = ['http://api.wunderground.com/api/b728a7436f25b9f2/history_',tempStr,month,day3,'/q/TH/',provice_url];
       dataRainPast = webread(url);
       valRainPast = dataRainPast.history.dailysummary.rain;
     
       oldstr=get(handles.listboxdaypass,'String');      
       newstr=['time=',tempStr,'day =', day3,'RainValue= ',valRainPast,'\\n']      
       pastWheater =srtvcat(oldstr,newstr);
       set(handles.listboxdaypass,'String',pastWheater);     
    
       if valRainPast == 1
            count = count + 1;
       end
       
   end
   
end
     
if count > 4 
    set(handles.water2,'String','don''t wathering');% wash
else
    set(handles.water2,'String','wathering'); % not wash
end



% --- Executes on button press in rayong.
function rayong_Callback(hObject, eventdata, handles)
% hObject    handle to rayong (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rayong


% --- Executes on button press in nontaburi.
function nontaburi_Callback(hObject, eventdata, handles)
% hObject    handle to nontaburi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nontaburi


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on selection change in popupmenu8.


% --- Executes during object creation, after setting all properties.


function water2_Callback(hObject, eventdata, handles)
% hObject    handle to water2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of water2 as text
%        str2double(get(hObject,'String')) returns contents of water2 as a double


% --- Executes during object creation, after setting all properties.
function water2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to water2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox

 
% --- Executes during object creation, after setting all properties.

function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in listboxdaypass.
function listboxdaypass_Callback(hObject, eventdata, handles)
% hObject    handle to listboxdaypass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxdaypass contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxdaypass


% --- Executes during object creation, after setting all properties.
function listboxdaypass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxdaypass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



