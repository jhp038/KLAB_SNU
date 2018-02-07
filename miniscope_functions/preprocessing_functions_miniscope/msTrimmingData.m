function msObj =  msTrimmingData(msObj)
%initialization
raw_timeV = msObj.msData.timeStamp;
RawData = msObj.wavData.RawData;


%% data loaded: dealing with .dat file first
% cutting first 1000 frame

time_1000th_frame = raw_timeV(1000); % this will be used continuously.
trimmed_timeV = raw_timeV(1001:end);
trimmed_timeV = trimmed_timeV - trimmed_timeV(1);
timeV = downsample(trimmed_timeV,4);

% make exception to control diff length
neuronData_length = size(msObj.msData.neuron.C_raw,2);
if length(timeV) > neuronData_length
    timeV = timeV(1: neuronData_length);
end


%%  now dealing with wave file
timeVectorS = RawData(:,1);
ExtEvent = RawData(:,2);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
TTLOnIdx = TTLOnIdx +1;
TTLOnTimes = timeVectorS(TTLOnIdx);         % TTLPulseTimeS
% posslbeError = TTLOnTimes
TTLOffIdx = find(TTLThreshCrossings == -1);  
TTLOffTimes = timeVectorS(TTLOffIdx);         % TTLPulseTimeS

RawData_trimmed = RawData(TTLOnIdx:TTLOffIdx,:);
RawData_trimmed(:,1) = RawData_trimmed(:,1) - RawData_trimmed(1,1);

k = dsearchn(RawData_trimmed(:,1),raw_timeV(1001));
wavData_processed = RawData_trimmed(k:end,:);
% RawData_processed(:,1) = RawData_processed(:,1) - RawData_trimmed(k-1,1);
wavData_processed(:,1) = wavData_processed(:,1) - wavData_processed(1,1);

%algining end
if timeV(end) < wavData_processed(end,1)
    endIdx = dsearchn(wavData_processed(:,1),timeV(end));
    wavData_processed = wavData_processed(1:endIdx,:);
%     timeVectorS = RawData_processed(:,1);
end

msObj.wavData.RawData = wavData_processed;
msObj.msData.timeStamp = timeV;

