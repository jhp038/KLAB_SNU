function fpObj = getTTLOnOffTime(fpObj)
%% fpObj = getTTLOnOffTime(fpObj)
%Written by Han Heol Park and Jong Hwi Park
% 02/27/2018 (date when this comment was written by PJH)
%
% Extracts TTL on and off time via calculating threshold
% and find crossings that goes over it

totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    totalWaveNum = fpObj(fpObjNum).waveNum;


    for mouseNum = 1:totalMouseNum
        RawData = fpObj(fpObjNum).idvData(mouseNum).RawData;
        timeVectorS = RawData(:,1);

        for waveNum = 1:totalWaveNum        
           %% Detecting events
            % The event channel alternates between low values when the event is off and high values
            % when the event is on. Therefore, we can set a threshold which is halfway between the min and max values.
            ExtEvent = RawData(:,4:end);
            ExtEvent = ExtEvent(:,waveNum);
            TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

            % Now we want to figure out when the stimulation signal goes ON.
            TTLeventON = ExtEvent >= TTLThresh;
            TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

            TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
            TTLOnTimes = timeVectorS(TTLOnIdx);         % TTLPulseTimeS

            TTLOffIdx = find(TTLThreshCrossings == -1);      % Find crossings from below
            TTLOffTimes = timeVectorS(TTLOffIdx);         % TTLPulseTimeS

            fpObj(fpObjNum).idvData(mouseNum).TTLOnIdx{waveNum} = TTLOnIdx;
            fpObj(fpObjNum).idvData(mouseNum).TTLOnTimes{waveNum} = TTLOnTimes;
            fpObj(fpObjNum).idvData(mouseNum).TTLOffIdx{waveNum} = TTLOffIdx;
            fpObj(fpObjNum).idvData(mouseNum).TTLOffTimes{waveNum} = TTLOffTimes;
        end
    end
end
end