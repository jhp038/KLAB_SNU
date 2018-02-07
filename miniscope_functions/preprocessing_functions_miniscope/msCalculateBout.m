function msObj = msCalculateBout(msObj,boutWindow,numWindow)
%% initialization
clc
RawData = msObj.wavData.RawData;
samplingRate = round(msObj.wavData.samplingRate);
wavTime = RawData(:,1);
neuron = msObj.msData.neuron;
timeStamp = msObj.msData.timeStamp;
%% looking for drinking idx
if nargin<2,
    boutWindow =10;
    numWindow = 10;
    
    fprintf(['Automatically chosen bout criteria \n' ...
        'Temporal Window: ' num2str(boutWindow) ' (s)\n' ...
        'Interlick Window: ' num2str(numWindow) ' licks \n'])
else
    fprintf(['Manually chosen bout criteria \n' ...
        'Temporal Window: ' num2str(boutWindow) ' (s)\n' ...
        'Interlick Window: ' num2str(numWindow) ' licks \n'])
    boutWindow = boutWindow;
    numWindow = numWindow;
end

ExtEvent = RawData(:,3:end);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below


%initialization
window = round(boutWindow *samplingRate);
lickingIdx =TTLOnIdx;
numLicking = size(lickingIdx,1);
%a drinking bout is defined as any set of ten or more licks in which no interlick
% interval is greater than one second

%% first threshold -> Interlick interval greater than timeWindow sec
lickingInterval = diff(lickingIdx);
boutOffset = find(lickingInterval >= window);
if size(lickingIdx,1) - boutOffset(end) >= window
    boutOffset(end+1) = size(lickingIdx,1);
end
numPossibleBout = size(boutOffset,1);
on_off_Idx = ones(numPossibleBout,2);
on_off_Idx(2:end,1) = boutOffset(1:end-1)+1;
on_off_Idx(:,2) = boutOffset;
%adding last row EDITED 9/25
on_off_Idx(size(on_off_Idx,1)+1,:) = [on_off_Idx(end,2)+1 size(lickingIdx,1)];

%% Second Threshold -> numWindow or more licks in each interval
for i = 1:numPossibleBout
    if (on_off_Idx(i,2) - on_off_Idx(i,1)) < numWindow % changed criteria
        on_off_Idx(i,:) = 0;
    end
end
on_off_Idx = snip(on_off_Idx,'0');

% Get bout index on dFF data
numTotalBout = size(on_off_Idx,1);
% getting actual bout index
boutIdx = ones(numTotalBout,2);
boutIdx(:,1) = lickingIdx(on_off_Idx(:,1));
boutIdx(:,2) = lickingIdx(on_off_Idx(:,2));

timeIdx = wavTime(boutIdx);
%% load neuron data and find matching timepoint
data = neuron.C;
% last_timeV = timeV(end);
numTotalNeuron = size(data,1);
videoLickingIdx = [];
videoLickingIdx(:,1) = dsearchn(timeStamp,timeIdx(:,1));
videoLickingIdx(:,2) = dsearchn(timeStamp,timeIdx(:,2));
videoLickingEveryIdx = dsearchn(timeStamp,wavTime(lickingIdx));

%% need to add lines to creat bout array...
%1. aligned to first lick
%2. aligned to last lick
%3. sorted for plotting bar plot

%% output
msObj.boutData.bout_criteria.boutWindow = boutWindow;
msObj.boutData.bout_criteria.numWindow = numWindow;

msObj.boutData.boutTime = timeIdx;
msObj.boutData.numLicking = numLicking;
msObj.boutData.numTotalBout = numTotalBout;
msObj.boutData.videoLickingIdx = videoLickingIdx;
msObj.boutData.videoLickingEveryIdx = videoLickingEveryIdx;
% msObj.
msObj.msData.numTotalNeuron = numTotalNeuron;
%printing out result

fprintf(['##### Results are successfully saved in msObj ##### \n' ...
    '\tTotal number of Licks: ' num2str(numLicking) '\n' ...
    '\tTotal number of bout : ' num2str(numTotalBout) '\n'])


end