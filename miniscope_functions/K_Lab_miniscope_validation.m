clear;
% %% read data and convert to double
% %addpath(genpath('../../NoRMCorre'));
% Yf = read_file(name);
% Yf = single(Yf);
% [d1,d2,T] = size(Yf);
name = uigetfile
Y_raw = read_file(name);
numberOfFrames = size(Y_raw,3);

for frame = 1:1:numberOfFrames 
    %     Extract the frame from the movie structure.
    thisFrame = Y_raw(:,:,frame);
    meanBlueLevels(frame) = mean(mean(thisFrame));
end

plot(meanBlueLevels);

%%
%Initializae variable
threshold = [];
eventLightOn = [];
threshCrossings=[];
LEDOnIdx=[];
LEDOffIdx=[];

threshold = (max(meanBlueLevels)+min(meanBlueLevels))/2;
eventLightON = meanBlueLevels >= threshold;
threshCrossings = diff(eventLightON);
LEDOnIdx = find(threshCrossings == 1); 
LEDOffIdx = find(threshCrossings == -1); 
LEDOnIdx = LEDOnIdx +1;
LEDOffIdx = LEDOffIdx +1;
%%

folder_name = uigetdir;

RawData = Text2Array_miniscope(folder_name);
% RawData = downsample(RawData,10); %we have erased first 50 sec.
%%
timeVectorS = RawData(:,1);
ExtEvent = RawData(:,2);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
TTLOnIdx = TTLOnIdx+1;
TTLOnTimes = timeVectorS(TTLOnIdx);         % TTLPulseTimeS

TTLOffIdx = find(TTLThreshCrossings == -1);  
TTLOffIdx = TTLOffIdx+1;
TTLOffTimes = timeVectorS(TTLOffIdx);         % TTLPulseTimeS
if size(TTLOffIdx,1)>1
    RawData_trimmed = RawData(TTLOnIdx:end,:);
else
    RawData_trimmed = RawData(TTLOnIdx:TTLOffIdx,:);
end
RawData_trimmed(:,1) = RawData_trimmed(:,1) - RawData_trimmed(1,1);

k = dsearchn(RawData_trimmed(:,1),timestamp(1001)/1000);
RawData_processed = RawData_trimmed(k+33:end,:);
RawData_processed(:,1) = RawData_processed(:,1) - RawData_processed(1,1);
timeVectorS=RawData_processed(:,1);
% timeVectorS = linspace(0,12185/20,length(RawData_processed));
%
% looking for drinking idx
ExtEvent_2 = RawData_processed(:,3:end);
TTLThresh_2 = (max(ExtEvent_2) + min(ExtEvent_2)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON_2 = ExtEvent_2 >= TTLThresh_2;
TTLThreshCrossings_2 = diff(TTLeventON_2);      % Find threshold crossings by taking the first order difference

TTLOnIdx_2 = find(TTLThreshCrossings_2 == 1);      % Find crossings from below
TTLOnIdx_2 = TTLOnIdx_2+1%-45;

%
% timeV = linspace(0,timeVectorS(end),12185);
timeV = timestamp;
timeV = timeV(1001:end)./1000;
timeV = timeV - timeV(1);
%trying new thang
% timeVectorS = linspace(0,timeV(end),length(RawData_processed));

LEDOnTimes = timeV(LEDOnIdx);
TTLOnTimes = timeVectorS(TTLOnIdx_2);

timeDiff = LEDOnTimes - TTLOnTimes
mean(timeDiff)



