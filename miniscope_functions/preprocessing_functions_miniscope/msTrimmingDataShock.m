function msObj =  msTrimmingDataShock(msObj)
raw_timeV = msObj.msData.timeStamp;
RawData = msObj.wavData.RawData;
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
RawData_processed = RawData_trimmed(k:end,:);
% RawData_processed(:,1) = RawData_processed(:,1) - RawData_trimmed(k-1,1);
RawData_processed(:,1) = RawData_processed(:,1) - RawData_processed(1,1);

timeVectorS = RawData_processed(:,1);
time_error = timeVectorS(end) - timeV(end);
disp(['Time difference between miniscope vs TTL = ' num2str(time_error)]);
if time_error>50
    k = dsearchn(timeVectorS, timeV(end));
    RawData_processed = RawData_processed(1:k,:);
else
    RawData_processed(:,1) = timeVectorS-time_error;
end
msObj.wavData.RawData  = RawData_processed;

disp('WAV data has been saved in the field wavData')
msObj.msData.timeStamp = timeV;
