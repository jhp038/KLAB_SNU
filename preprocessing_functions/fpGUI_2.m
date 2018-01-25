function varargout = fpGUI_2(varargin)
%% fpGUI_2
%Written by Jong Hwi Park
% 09/15/2017
% GUI that helps users to input multiple parameters to preprocess the data.
% Parameter list :
%   Sub Sampling Rate
%   Start ExamRange
%   End ExamRange
%   Wav1,Wav2,Wav3
%   TTL Alignment
%   Trimming Option
%   Session Duration


% Last Modified by GUIDE v2.5 05-Sep-2017 15:04:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fpGUI_2_OpeningFcn, ...
                   'gui_OutputFcn',  @fpGUI_2_OutputFcn, ...
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


% --- Executes just before fpGUI_2 is made visible.
function fpGUI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fpGUI_2 (see VARARGIN)
%% loading fpObj
fpObj = evalin('base','fpObj');
waveNum = size(fpObj(1).idvData(1).RawData,2) - 3;
if waveNum == 1
    set(handles.wav2,'Enable','off')
    set(handles.wav3,'Enable','off')
elseif waveNum == 2
    set(handles.wav3,'Enable','off')
end

set(handles.trimming_Auto,'Enable','Off')
set(handles.duration,'Enable','Off')
% Choose default command line output for fpGUI_2
handles.output = hObject;
handles.fpObj = evalin('base','fpObj');
% Update handles structure
guidata(hObject, handles);
imshow('jh.jpg');

% UIWAIT makes fpGUI_2 wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = fpGUI_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
fpObj = handles.fpObj;
% wavemode
waveNum = size(fpObj(1).idvData(1).RawData,2) - 3;
if waveNum == 1
    selection = get(handles.wav1,'String');
    waveMode{1} = selection{get(handles.wav1,'Value')};
elseif waveNum == 2
    selection = get(handles.wav1,'String');
    waveMode{1} = selection{get(handles.wav1,'Value')};  
    selection = get(handles.wav2,'String');
    waveMode{2} = selection{get(handles.wav2,'Value')};
elseif waveNum == 3   
    selection = get(handles.wav1,'String');
    waveMode{1} = selection{get(handles.wav1,'Value')};
    selection = get(handles.wav2,'String');
    waveMode{2} = selection{get(handles.wav2,'Value')};
    selection = get(handles.wav3,'String');
    waveMode{3} = selection{get(handles.wav3,'Value')};
end
%alignMode
if get(handles.TTL_On,'Value') == 1
    alignMode = 'on';
elseif get(handles.TTL_Off,'Value') == 1
    alignMode = 'off';
end

%trimOption
if get(handles.trimming_Manual,'Value') == 1
    trimmingOption = 'manual';
else
    trimmingOption = 'auto';
end

varargout{1}.subsamplingRate = str2num(get(handles.ssr,'String'));
varargout{1}.start_examRange = str2num(get(handles.start_examRange,'String'));
varargout{1}.end_examRange = str2num(get(handles.end_examRange,'String'));
varargout{1}.waveMode = waveMode;
varargout{1}.alignMode = alignMode;
varargout{1}.duration = str2num(get(handles.duration,'String'));
varargout{1}.trimmingOption = trimmingOption;
delete(handles.figure1);


function ssr_Callback(hObject, eventdata, handles)
% hObject    handle to ssr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ssr as text
%        str2double(get(hObject,'String')) returns contents of ssr as a double


% --- Executes during object creation, after setting all properties.
function ssr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ssr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_examRange_Callback(hObject, eventdata, handles)
% hObject    handle to start_examRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_examRange as text
%        str2double(get(hObject,'String')) returns contents of start_examRange as a double


% --- Executes during object creation, after setting all properties.
function start_examRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_examRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_examRange_Callback(hObject, eventdata, handles)
% hObject    handle to end_examRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_examRange as text
%        str2double(get(hObject,'String')) returns contents of end_examRange as a double


% --- Executes during object creation, after setting all properties.
function end_examRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_examRange (see GCBO)
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
uiresume(handles.figure1);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% The GUI is still in UIWAIT, us UIRESUME

%resetting GUI
ssr = set(handles.ssr,'String',10);
start_range = set(handles.start_examRange,'String',-15);
end_range = set(handles.end_examRange,'String',15);
set(handles.TTL_On,'Value',1)
set(handles.trimming_Manual,'Value',1)
set(handles.wav1,'Value',1);
set(handles.wav2,'Value',1);
set(handles.wav3,'Value',1);
set(handles.duration,'String',0,'Enable','Off')


% --- Executes on selection change in wav1.
function wav1_Callback(hObject, eventdata, handles)
% hObject    handle to wav1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wav1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wav1
selection1 = get(handles.wav1,'Value');
selection2 = get(handles.wav2,'Value');
selection3 = get(handles.wav3,'Value');

if selection1 == 2 ||selection2 == 2 || selection3 == 2
    set(handles.trimming_Auto,'Enable','On')
else
    set(handles.trimming_Auto,'Enable','Off')
    set(handles.trimming_Manual,'Value',1)
    set(handles.trimming_Auto,'Value',0)
    set(handles.duration,'Enable','Off')
end

% --- Executes during object creation, after setting all properties.
function wav1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wav1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wav2.
function wav2_Callback(hObject, eventdata, handles)
% hObject    handle to wav2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wav2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wav2
selection1 = get(handles.wav1,'Value');
selection2 = get(handles.wav2,'Value');
selection3 = get(handles.wav3,'Value');

if selection1 == 2 ||selection2 == 2 || selection3 == 2
    set(handles.trimming_Auto,'Enable','On')
else
    set(handles.trimming_Auto,'Enable','Off')
    set(handles.trimming_Manual,'Value',1)
    set(handles.trimming_Auto,'Value',0)
    set(handles.duration,'Enable','Off')
end

% --- Executes during object creation, after setting all properties.
function wav2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wav2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wav3.
function wav3_Callback(hObject, eventdata, handles)
% hObject    handle to wav3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wav3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wav3
selection1 = get(handles.wav1,'Value');
selection2 = get(handles.wav2,'Value');
selection3 = get(handles.wav3,'Value');

if selection1 == 2 ||selection2 == 2 || selection3 == 2
    set(handles.trimming_Auto,'Enable','On')
else
    set(handles.trimming_Auto,'Enable','Off')
    set(handles.trimming_Manual,'Value',1)
    set(handles.trimming_Auto,'Value',0)
    set(handles.duration,'Enable','Off')
end

% --- Executes during object creation, after setting all properties.
function wav3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wav3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration as text
%        str2double(get(hObject,'String')) returns contents of duration as a double


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trimming_Auto.
function trimming_Auto_Callback(hObject, eventdata, handles)
% hObject    handle to trimming_Auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.duration,'Enable','On')
end

% Hint: get(hObject,'Value') returns toggle state of trimming_Auto


% --- Executes on button press in trimming_Manual.
function trimming_Manual_Callback(hObject, eventdata, handles)
% hObject    handle to trimming_Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.duration,'Enable','Off')
end
% Hint: get(hObject,'Value') returns toggle state of trimming_Manual


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume()
% delete(hObject);
