function varargout = trimmingGUI_2(varargin)
% TRIMMINGGUI_2 MATLAB code for trimmingGUI_2.fig
%      TRIMMINGGUI_2, by itself, creates a new TRIMMINGGUI_2 or raises the existing
%      singleton*.
%
%      H = TRIMMINGGUI_2 returns the handle to a new TRIMMINGGUI_2 or the handle to
%      the existing singleton*.
%
%      TRIMMINGGUI_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIMMINGGUI_2.M with the given input arguments.
%
%      TRIMMINGGUI_2('Property','Value',...) creates a new TRIMMINGGUI_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trimmingGUI_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trimmingGUI_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trimmingGUI_2

% Last Modified by GUIDE v2.5 11-Sep-2017 16:48:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trimmingGUI_2_OpeningFcn, ...
                   'gui_OutputFcn',  @trimmingGUI_2_OutputFcn, ...
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


% --- Executes just before trimmingGUI_2 is made visible.
function trimmingGUI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trimmingGUI_2 (see VARARGIN)

% Choose default command line output for trimmingGUI_2
handles.output = hObject;
handles.fpObj = evalin('base','fpObj');
fpObj = handles.fpObj;
%show image
axes(handles.jonghwi);
imshow('jh.jpg');
axes(handles.main);
imshow('maxim_lab.png')


%initialize choice and trimming range array
totalMouseNum = 0;
for fpObjNum = 1:size(fpObj,2)
    totalMouseNum = totalMouseNum + fpObj(fpObjNum).totalMouseNum;
end

choiceArray = -ones(totalMouseNum,1); handles.choiceArray = choiceArray;
trimmingRange = zeros(totalMouseNum,2); handles.trimmingRange = trimmingRange;

j = 1;
for fpObjNum = 1:size(fpObj,2)
    for i = 1:fpObj(fpObjNum).totalMouseNum
        mouseID{j,1} = fpObj(fpObjNum).idvData(i).Description;
        RawDataArray{j,1} = fpObj(fpObjNum).idvData(i).RawData;  
        
        if fpObj(fpObjNum).trimmingRange{i,1} == 0
            trimmingRange(j,:) = 0;
            choiceArray(j,1) = 0;
        elseif isnan(fpObj(fpObjNum).trimmingRange{i,1}) == 0
            choiceArray(j,1) = 1;
            trimmingRange(j,1) = fpObj(fpObjNum).trimmingRange{i,1};
            trimmingRange(j,2) =  fpObj(fpObjNum).trimmingRange{i,2};  
        end
        
        if fpObj(fpObjNum).trimmingRange{i,2} >= size(RawDataArray{j,1},1) %if previously selected trimming range is bigger than actual raw data array..
            trimmingRange(j,:) = 0;
            choiceArray(j,1) = -1;
        end
        j = j + 1;
    end
    mouseNum(fpObjNum,1) = fpObj(fpObjNum).totalMouseNum;
end


%set visibility
set(handles.selectText,'Visible','Off')
set(handles.mouseList,'Visible','Off')
set(handles.discard,'Visible','Off')
set(handles.accept,'Visible','Off')
%         bls1 = polyfit (trimmedRawData(:,3),trimmedRawData(:,2),1);
%         y_fit_1 = polyval(bls1,trimmedRawData(:,3)); %fitted 405nm

%make color name array and set it at list
for i = 1:size(mouseID,1)
    if choiceArray(i) == -1 % no choice black
        colorID{i,1} = ['<HTML><FONT color="black">' mouseID{i,1} '</Font></html>'];
    elseif choiceArray(i) == 0 %discarded red
        colorID{i,1} = ['<HTML><FONT color="red">' mouseID{i,1} '</Font></html>'];   
    elseif choiceArray(i) == 1 %accepted green
        colorID{i,1} = ['<HTML><FONT color="green">' mouseID{i,1} '</Font></html>'];       
    end
end
set(handles.mouseList,'String',colorID)


% Update handles structure
handles.choiceArray = choiceArray;
handles.trimmingRange = trimmingRange;
handles.mouseID = mouseID;
handles.mouseNum = mouseNum;
handles.RawDataArray = RawDataArray;
handles.colorID = colorID;
guidata(hObject, handles);
% wait to close
uiwait(handles.figure1);

% UIWAIT makes trimmingGUI_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trimmingGUI_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
choiceArray = handles.choiceArray;
trimmingRange = handles.trimmingRange;
mouseNum = handles.mouseNum;
varargout{1}.choiceArray = choiceArray;
varargout{1}.trimmingRange = trimmingRange;
varargout{1}.mouseNum = mouseNum;

%closing figure
delete(handles.figure1);



% --- Executes on button press in discard.
function discard_Callback(hObject, eventdata, handles)
% hObject    handle to discard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choiceArray = handles.choiceArray;
trimmingRange = handles.trimmingRange;
selectedID = get(handles.mouseList,'Value');
mouseID = handles.mouseID;
colorID = handles.colorID;
%update choice array
choiceArray(selectedID) = 0;
handles.choiceArray = choiceArray;
RawDataArray = handles.RawDataArray;

%replot
cla
plot(RawDataArray{selectedID}(:,2),'r')    
hold on
plot(RawDataArray{selectedID}(:,3),'b')
plot(RawDataArray{selectedID}(:,4:end)*50,'g')   %syk
legend('473','405','event');
xlabel('index number')

%set as 0
if trimmingRange(selectedID,1) ~= 0
%     plot([trimmingRange(selectedID,1) trimmingRange(selectedID,1)],ylim,'white');
%     plot([trimmingRange(selectedID,2) trimmingRange(selectedID,2)],ylim,'white');
    trimmingRange(selectedID,:) = 0;
end

%set status
for i = 1:size(mouseID,1)
    if choiceArray(i) == -1 % no choice black
        colorID{i,1} = ['<HTML><FONT color="black">' mouseID{i,1} '</Font></html>'];
    elseif choiceArray(i) == 0 %discarded red
        colorID{i,1} = ['<HTML><FONT color="red">' mouseID{i,1} '</Font></html>'];   
    elseif choiceArray(i) == 1 %accepted green
        colorID{i,1} = ['<HTML><FONT color="green">' mouseID{i,1} '</Font></html>'];       
    end
end

set(handles.mouseList,'String',colorID)
disp(['Discarded']);

%save guidata
handles.trimmingRange = trimmingRange;
handles.mouseID = mouseID;
guidata(hObject, handles);

% --- Executes on button press in accept.
function accept_Callback(hObject, eventdata, handles)
% hObject    handle to accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%initialization
choiceArray = handles.choiceArray;
RawDataArray = handles.RawDataArray;
trimmingRange = handles.trimmingRange;
selectedID = get(handles.mouseList,'Value');
mouseID = handles.mouseID;
colorID = handles.colorID;
choiceArray(selectedID) = 1;

%set status
for i = 1:size(mouseID,1)
    if choiceArray(i) == -1 % no choice black
        colorID{i,1} = ['<HTML><FONT color="black">' mouseID{i,1} '</Font></html>'];
    elseif choiceArray(i) == 0 %discarded red
        colorID{i,1} = ['<HTML><FONT color="red">' mouseID{i,1} '</Font></html>'];   
    elseif choiceArray(i) == 1 %accepted green
        colorID{i,1} = ['<HTML><FONT color="green">' mouseID{i,1} '</Font></html>'];       
    end
end

set(handles.mouseList,'String',colorID)

disp(['accepted']);


%trimming
%When reseting, erase previously selected range as 0
%replot
cla
p473 = plot(RawDataArray{selectedID}(:,2),'r');
hold on
p405 = plot(RawDataArray{selectedID}(:,3),'b');
pEvent = plot(RawDataArray{selectedID}(:,4:end)*50,'g');
legend('473','405','event');
xlabel('index number')

[trimmingRange(selectedID,1),~] = ginput(1);
plot([trimmingRange(selectedID,1) trimmingRange(selectedID,1)],ylim,'black');

[trimmingRange(selectedID,2),~] = ginput(1);
plot([trimmingRange(selectedID,2) trimmingRange(selectedID,2)],ylim,'black');
disp(trimmingRange)
%round trimming range
trimmingRange = round(trimmingRange);

if trimmingRange(selectedID,1) ~= 0   
    %added
    trimmedRawData = RawDataArray{selectedID}(trimmingRange(selectedID,1):trimmingRange(selectedID,2),:);
    bls1 = polyfit (trimmedRawData(:,3),trimmedRawData(:,2),1);
    y_fit_1 = polyval(bls1,trimmedRawData(:,3)); %fitted 405nm
    pFITTED = plot(trimmingRange(selectedID,1): trimmingRange(selectedID,2) , y_fit_1,'m')
    lgd = legend([p473 p405 pEvent pFITTED],'473','405','event','fitted');
end

%update array
handles.choiceArray = choiceArray;
handles.trimmingRange = round(trimmingRange);
guidata(hObject, handles);



% --- Executes on selection change in mouseList.
function mouseList_Callback(hObject, eventdata, handles)
% hObject    handle to mouseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mouseList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mouseList
%initialization

trimmingRange = handles.trimmingRange;
RawDataArray = handles.RawDataArray;

%plotting
cla
selectedID = get(hObject,'Value');
plot(RawDataArray{selectedID}(:,2),'r')    
hold on
plot(RawDataArray{selectedID}(:,3),'b')
plot(RawDataArray{selectedID}(:,4:end)*50,'g')   %syk
legend('473','405','event');
xlabel('index number')

%plotting selected range
if trimmingRange(selectedID,1) ~= 0
    
    %added
    trimmedRawData = RawDataArray{selectedID}(trimmingRange(selectedID,1):trimmingRange(selectedID,2),:);
    bls1 = polyfit (trimmedRawData(:,3),trimmedRawData(:,2),1);
    y_fit_1 = polyval(bls1,trimmedRawData(:,3)); %fitted 405nm
    plot(trimmingRange(selectedID,1): trimmingRange(selectedID,2) , y_fit_1,'m')
    lgd = legend('473','405','event','fitted');

    plot([trimmingRange(selectedID,1) trimmingRange(selectedID,1)],ylim,'black');
    plot([trimmingRange(selectedID,2) trimmingRange(selectedID,2)],ylim,'black');
    
end



% totalMouseNum = fpObj.
% disp(choiceArray)


% --- Executes during object creation, after setting all properties.
function mouseList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% handles = guidata(hObject);
%data handling

cla


% --- Executes on button press in finish.
function finish_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1)


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RawDataArray = handles.RawDataArray;
set(handles.selectText,'Visible','On')
set(handles.mouseList,'Visible','On')
set(handles.discard,'Visible','On')
set(handles.accept,'Visible','On')
set(handles.start,'Visible','Off')
% set(handles.mouseList,'String',mouseID)
% set(handles.mouseList,'Value',1);

cla
selectedID = get(hObject,'Value');
plot(RawDataArray{selectedID}(:,2),'r')    
hold on
plot(RawDataArray{selectedID}(:,3),'b')
plot(RawDataArray{selectedID}(:,4:end)*50,'g')   %syk
lgd = legend('473','405','event');
xlabel('Time (s)')

trimmingRange = handles.trimmingRange;
%plotting selected range
if trimmingRange(selectedID,1) ~= 0
    
    %added
    trimmedRawData = RawDataArray{selectedID}(trimmingRange(selectedID,1):trimmingRange(selectedID,2),:);
    bls1 = polyfit (trimmedRawData(:,3),trimmedRawData(:,2),1);
    y_fit_1 = polyval(bls1,trimmedRawData(:,3)); %fitted 405nm
    plot(trimmingRange(selectedID,1): trimmingRange(selectedID,2) , y_fit_1,'m')
    lgd = legend('473','405','event','fitted');

    plot([trimmingRange(selectedID,1) trimmingRange(selectedID,1)],ylim,'black');
    plot([trimmingRange(selectedID,2) trimmingRange(selectedID,2)],ylim,'black');
    
end
