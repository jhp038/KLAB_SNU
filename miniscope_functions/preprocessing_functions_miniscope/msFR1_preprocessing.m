function msObj = msFR1_preprocessing(msObj,examRangeInput,frameRateInput)
clc
if nargin<2
    examRange = [-5 5];
    frameRate = 5;    
    examRangeIdx = examRange * frameRate;
    fprintf(['Automatically chosen parameters \n' ...
        'Exam Range: ' num2str(examRange) ' (s)\n' ...
        'Frame Rate: ' num2str(frameRate) ' Hz \n'])
else
    examRange = examRangeInput;
    frameRate = frameRateInput;
    examRangeIdx = examRange * frameRate;
    fprintf(['Manually chosen parameters \n' ...
        'Exam Range: ' num2str(examRange) ' (s)\n' ...
        'Frame Rate: ' num2str(frameRate) ' \n'])
end

%% initialization
msData = msObj.msData;
medData = msObj.medData;

%msData
timeStamp = msData.timeStamp;
neuron = msData.neuron;
C_raw = neuron.C_raw;

%medData_time idx array
activeLeverTimeIdx = medData.activeLeverTimeIdx; 
inactiveLeverTimeIdx = medData.inactiveLeverTimeIdx;
rewardTimeIdx = medData.rewardTimeIdx;
portEntryTimeIdx  = medData.portEntryTimeIdx;

%creating Idx array for timeStamp
activeLever_examRangeIdx = [activeLeverTimeIdx activeLeverTimeIdx] + repmat(examRangeIdx,[size(activeLeverTimeIdx,1) 1]);
inactiveLever_examRangeIdx = [inactiveLeverTimeIdx inactiveLeverTimeIdx] + repmat(examRangeIdx,[size(inactiveLeverTimeIdx,1) 1]);
rewardTimeIdx_examRangeIdx = [rewardTimeIdx rewardTimeIdx] + repmat(examRangeIdx,[size(rewardTimeIdx,1) 1]);
portEntryTimeIdx_examRangeIdx = [portEntryTimeIdx portEntryTimeIdx] + repmat(examRangeIdx,[size(portEntryTimeIdx,1) 1]);


%saving
msObj.activeLever_examRangeIdx = activeLever_examRangeIdx;
msObj.inactiveLever_examRangeIdx = inactiveLever_examRangeIdx;
msObj.rewardTimeIdx_examRangeIdx = rewardTimeIdx_examRangeIdx;
msObj.portEntryTimeIdx_examRangeIdx = portEntryTimeIdx_examRangeIdx;

msObj.examRange = examRange;
msObj.examRangeIdx = examRangeIdx;
msObj.framRate = frameRate;



end