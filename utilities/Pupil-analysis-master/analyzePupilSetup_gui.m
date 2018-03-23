function varargout = analyzePupilSetup_gui(varargin)
% ANALYZEPUPILSETUP_GUI MATLAB code for analyzePupilSetup_gui.fig
%      ANALYZEPUPILSETUP_GUI, by itself, creates a new ANALYZEPUPILSETUP_GUI or raises the existing
%      singleton*.
%
%      H = ANALYZEPUPILSETUP_GUI returns the handle to a new ANALYZEPUPILSETUP_GUI or the handle to
%      the existing singleton*.
%
%      ANALYZEPUPILSETUP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYZEPUPILSETUP_GUI.M with the given input arguments.
%
%      ANALYZEPUPILSETUP_GUI('Property','Value',...) creates a new ANALYZEPUPILSETUP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analyzePupilSetup_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analyzePupilSetup_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analyzePupilSetup_gui

% Last Modified by GUIDE v2.5 01-Dec-2017 14:37:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @analyzePupilSetup_gui_OpeningFcn, ...
    'gui_OutputFcn',  @analyzePupilSetup_gui_OutputFcn, ...
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

% --- Executes just before analyzePupilSetup_gui is made visible.
function analyzePupilSetup_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analyzePupilSetup_gui (see VARARGIN)

% Choose default command line output for analyzePupilSetup_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using analyzePupilSetup_gui.
if strcmp(get(hObject,'Visible'),'off')
    plot(nan(5));
end

% UIWAIT makes analyzePupilSetup_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analyzePupilSetup_gui_OutputFcn(hObject, eventdata, handles)
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
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
f = handles.fnamelist;
filename = cell2mat(f(popup_sel_index));
obj = VideoReader(filename); %create video object for selected filename

%Read video frame and get coordinates for eye ROI
im = rgb2gray(readFrame(obj));
imshow(im)

handles.im = im;
handles.filename = filename;
handles.vidobj = obj;
handles.nFrames = floor(obj.FrameRate*obj.Duration);
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
im = handles.im;

%Crop the image around the ROI area & save as binary image
%hold on
BW = roipoly;
eyeROI = double(BW);
[yROI,xROI] = find(eyeROI ~= 0);
ypix = min(yROI):max(yROI);
xpix = min(xROI):max(xROI);
im = im(ypix,xpix);
hold off;imshow(im)

handles.yROI = yROI;
handles.xROI = xROI;
guidata(hObject, handles);
disp('done')

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function [fnames] = popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

m = dir('*.mp4');
if ~isempty(m)
    fnames = {};
    a=1;
    for i = 1:size(m,1)
        if ~isempty(strfind(m(i).name,'eyevid'))
            fnames{a} = m(i).name; a=a+1;
        end
    end
    if a == 1
        fnames = {'No eye videos'};
    end
else
    fnames = {'No eye videos'};
end
handles.fnamelist = fnames;
guidata(hObject, handles);

set(hObject, 'String', fnames);
%set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.numThresh = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%disp(str2double(get(hObject,'String')));


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.openPix = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.erodePix = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.sens = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.colInvert = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.adjContrast = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Gathering data & parameters
if ~isfield(handles,'numThresh') %If starting with default values, have to set the values first
    numThresh = 4;
    openPix = 5;
    erodePix = 3;
    sens = 0.8;
    
    handles.numThresh = numThresh;
    handles.openPix = openPix;
    handles.erodePix = erodePix;
    handles.sens = sens;
else
    numThresh = handles.numThresh;
    openPix = handles.openPix;
    erodePix = handles.erodePix;
    sens = handles.sens;
end

nFrames = handles.nFrames;
vidobj = handles.vidobj;
xROI = handles.xROI;
yROI = handles.yROI;

%If boxes weren't selected then they haven't been added to handles; if
%that's the case add them now
if ~isfield(handles,'adjContrast')
    adjContrast = 0;
    handles.adjContast = adjContrast;
else
    adjContrast = handles.adjContrast;
end
if ~isfield(handles,'colInvert')
    colInvert = 0;
    handles.colInvert = colInvert;
else
    colInvert = handles.colInvert;
end
guidata(hObject, handles);

%Setting up new variables
ds = round(nFrames/20);

a=1;
cLast = nan(1,2);

axes(handles.axes1);
cla;

frame = 1;
testFrames = 1:ds:nFrames;
vidobj.CurrentTime = 0; %sets to first frame of video

while hasFrame(vidobj)
    %Read video frame and get coordinates for eye ROI
    eyeMov = readFrame(vidobj);
    
    if a <= length(testFrames)
        if frame == testFrames(a)
            
            im = eyeMov(:,:,1);
            
            %Crop the image around the ROI area & save as binary image
            ypix = min(yROI):max(yROI);
            xpix = min(xROI):max(xROI);
            im2 = im(ypix,xpix);
            
            if isequal(colInvert,1)
                im2 = imcomplement(im2);
            end
            
            if isequal(adjContrast,1)
                %Remove white pixels & adjust contrast
                m = mean(im2(:));
                x = im2;
                rlist = uint8(m+12*randn(size(x))+1);
                x(x>220) = rlist(x>220);
                im2 = imadjust(x);
            end
            
            [d,cLast,im4,imOpen,Ie2] = getPupilDiameter(im2,frame,numThresh,sens,openPix,erodePix,cLast,handles);
            if ~isempty(d)
                diam(a) = d;
            else
                diam(a) = NaN;
            end
            %m = nanmean(diam);
            
            axes(handles.axes1);
            %cla;
            %subplot(2,2,1)
            imshow(im2)
            hold on
            title(['Frame number: ',num2str(frame),' diam = ',num2str(diam(a))])
            viscircles(cLast,diam(a)/2,'EdgeColor','b');
            drawnow
            hold off
            
            axes(handles.axes2);
            %subplot(2,2,2)
            imshow(im4),title('after thresholding')
            drawnow
            
            axes(handles.axes3);
            %subplot(2,2,3)
            imshow(imOpen),title('after imopen')
            drawnow
            
            axes(handles.axes4);
            %subplot(2,2,4)
            imshow(Ie2),title('after imopen + imerode')
            drawnow
            
            a=a+1;
            
            pause(1)
        end
    end
    frame = frame+1;
end

disp('Finished testing parameters. Click "save parameters" or enter new ones to re-test.')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = handles.filename;

parameters = struct('numThresh',handles.numThresh,...
    'openPix', handles.openPix,...
    'erodePix', handles.erodePix,...
    'sens', handles.sens,...
    'nFrames', handles.nFrames,...
    'colInvert', handles.colInvert,...
    'adjContrast', handles.adjContast,...
    'xROI',handles.xROI,...
    'yROI',handles.yROI);

save([filename(1:end-4) '.mat'],'parameters')
disp('Parameters saved!')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = handles.filename;

disp('Running pupil diameter analysis on entire file...')
load([filename(1:end-4) '.mat'])
pupilTracking(filename,parameters)


% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
currDir = cd;
textLabel = {sprintf('%s','Current directory: ',currDir)};
set(hObject, 'String', textLabel);

handles.currDir = currDir;
guidata(hObject, handles);


% --- Executes on button press in pushbutton7.
%function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
