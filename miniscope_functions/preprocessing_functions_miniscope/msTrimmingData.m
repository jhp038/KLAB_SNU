function msObj =  msTrimmingData(msObj)
%initialization
raw_timeV = msObj.msData.timeStamp;


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

%% check existence of field 
if isfield(msObj,'wavData')  % now dealing with wave file
    RawData = msObj.wavData.RawData;
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
    
    % saving wav data
    msObj.wavData.RawData = wavData_processed;
    disp('WAV data has been saved in the field wavData')

elseif  isfield(msObj,'medData') %now dealing with MED data
    medData_txt = msObj.medData.txt;
    medData_num = msObj.medData.num;
    subject = medData_num(1,1);
    duration = medData_num(4,1);
    %find where C start and ends
    activeLeverStartIdx = find(strcmp(medData_txt, 'C(0)'));
    inactiveLeverStartIdx = find(strcmp(medData_txt, 'D(0)'));
    rewardStartIdx = find(strcmp(medData_txt, 'E(0)'));
    portEntryStartIdx = find(strcmp(medData_txt, 'J(0)'));
    finalIdx = find(strcmp(medData_txt, 'Z(0)'));

    medData_Idx = [activeLeverStartIdx inactiveLeverStartIdx-2 ...
        ; inactiveLeverStartIdx rewardStartIdx-2 ...
        ; rewardStartIdx portEntryStartIdx-2 ...
        ; portEntryStartIdx finalIdx-1];

    % subtracting time_1000th_frame 
    activeLeverTime = medData_num(find(medData_num(medData_Idx(1,1):medData_Idx(1,2),1) ~=0) + medData_Idx(1,1) - 1) - time_1000th_frame;
    inactiveLeverTime = medData_num(find(medData_num(medData_Idx(2,1):medData_Idx(2,2),1) ~=0) + medData_Idx(2,1) - 1) - time_1000th_frame;
    rewardTime = medData_num(find(medData_num(medData_Idx(3,1):medData_Idx(3,2),1) ~=0) + medData_Idx(3,1) - 1) - time_1000th_frame;
    portEntryTime = medData_num(find(medData_num(medData_Idx(4,1):medData_Idx(4,2),1) ~=0) + medData_Idx(4,1) - 1) - time_1000th_frame;
    
    %actual number
    totalNumActive = size(activeLeverTime,1);
    totalNumInactive = size(inactiveLeverTime,1);
    totalNumReward = size(rewardTime,1);
    totalNumPortEntry =  size(portEntryTime,1);
    
    %% save data into msObj
    msObj.medData.subject = subject;
    msObj.medData.duration = duration;
    
    msObj.medData.totalNumActive = totalNumActive;
    msObj.medData.totalNumInactive=totalNumInactive;
    msObj.medData.totalNumReward=totalNumReward;
    msObj.medData.totalNumPortEntry=totalNumPortEntry;
    
    msObj.medData.medData_Idx = medData_Idx;

    msObj.medData.activeLeverTime=activeLeverTime;
    msObj.medData.inactiveLeverTime=inactiveLeverTime;
    msObj.medData.rewardTime=rewardTime;
    msObj.medData.portEntryTime=portEntryTime;

    msObj.medData.activeLeverTimeIdx = dsearchn(timeV,activeLeverTime);
    msObj.medData.inactiveLeverTimeIdx=dsearchn(timeV,inactiveLeverTime);
    msObj.medData.rewardTimeIdx=dsearchn(timeV,rewardTime);
    msObj.medData.portEntryTimeIdx=dsearchn(timeV,portEntryTime);
    
    disp('MED data has been saved in the field medData')
end
msObj.msData.timeStamp = timeV;

