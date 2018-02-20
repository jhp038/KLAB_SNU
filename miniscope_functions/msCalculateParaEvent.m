function msObj = msCalculateParaEvent(msObj)
%%
% clc
%%initialization
RawData = msObj.wavData.RawData;
samplingRate = round(msObj.wavData.samplingRate);
wavTime = RawData(:,1);
neuron = msObj.msData.neuron;
timeStamp = msObj.msData.timeStamp;
data_raw = neuron.C_raw;
numOfFrames = msObj.msData.numOfFrames;
numTotalNeuron = msObj.msData.numTotalNeuron;

%%
ExtEvent = RawData(:,3:end);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
TTLOffIdx = find(TTLThreshCrossings == -1);      % Find crossings from below
timeIdx = [wavTime(TTLOnIdx) wavTime(TTLOffIdx)];

numTotalShock = size(TTLOnIdx,1);

videoShockIdx = [];
videoShockIdx(:,1) = dsearchn(timeStamp,timeIdx(:,1));
videoShockIdx(:,2) = dsearchn(timeStamp,timeIdx(:,2));

if videoShockIdx(end) > size(timeStamp,1)
    videoShockIdx(end) =  size(timeStamp,1);
end

%% saving
msObj.timeIdx = timeIdx;
msObj.videoShockIdx = videoShockIdx;
msObj.numTotalShock = numTotalShock;

fprintf(['##### Results are successfully saved in msObj ##### \n' ...
    '\tTotal number of Shock: ' num2str(numTotalShock) '\n'])
