function fpObj = calculateBout(fpObj,timeWindow,numWindow,normalizeWindow,manualExamRange)
%% fpObj = calculateBout(fpObj,3,3,3,[-15 30])
%Written by Jong Hwi Park
% 02/27/2018 (date when this comment was written by PJH)
%
% Calculates bouts via TTLOnIdx with given criteria.
% Normalizes via given normalize window (nWindow ~ 0 as baseline)
% Extracts Firstlick/lastlick para event array with given range,manualExamRange

%TO DO LIST: need to implement 473 ONLY case.

% Output to fpObj
fpObj.timeWindow = timeWindow;
fpObj.numWindow = numWindow;
%%
totalMouseNum = fpObj.totalMouseNum;
dFFChoice = fpObj.analysisChoice;
switch dFFChoice
    case '473n405'
        for numMouse = 1:totalMouseNum
            %initialization
            disp(['Processing NumMouse: ' num2str(numMouse)])
            boutWindow = timeWindow;
            window = round(boutWindow *fpObj.samplingRate);
            lickingIdx = fpObj.idvData(numMouse).TTLOnIdx{1,1};
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
            numPossibleBout = numPossibleBout +1;
            
            %% Second Threshold -> numWindow or more licks in each interval
            for i = 1:numPossibleBout
                if (on_off_Idx(i,2) - on_off_Idx(i,1)) <= numWindow % changed criteria
                    on_off_Idx(i,:) = 0;
                end
            end
            on_off_Idx = snip(on_off_Idx,'0');
            
            % Get bout index on dFF data
            numActualBout = size(on_off_Idx,1);
            % getting actual bout index
            boutIdx = ones(numActualBout,2);
            boutIdx(:,1) = lickingIdx(on_off_Idx(:,1));
            boutIdx(:,2) = lickingIdx(on_off_Idx(:,2));
            %dff comes in now~!
            dFF = fpObj.idvData(numMouse).dFF;
            
            
            %% Calculating mean first lick exam Range
            
            %             examRange = [-timeWindow timeWindow];
            examRange = manualExamRange;
            examRangeIdx = examRange * round(fpObj.samplingRate);
            firstBoutRangeIdx = repmat(boutIdx(:,1),[1 2]) +repmat(examRangeIdx,[numActualBout 1]);
            for i = size(firstBoutRangeIdx,1):-1:1
                if firstBoutRangeIdx(i,1) <= 0
                    firstBoutRangeIdx(i,:) = [];
                    numActualBout = numActualBout - 1;
                end
            end
            %find boutrange that exceeds
            
            firstBoutDffArray = [];
            for boutNum = 1:numActualBout
                %                 disp(num2str(boutNum));
                firstBoutDffArray = [firstBoutDffArray;dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2))'];
            end
            firstBoutTimeV = linspace(examRange(1),examRange(2),size(firstBoutDffArray,2));
            
            meanFirstBout = mean(firstBoutDffArray,1);
            steFirstBout = std(firstBoutDffArray,0,1)/sqrt(size(firstBoutDffArray,1));
            
            % Calculating mean first lick exam Range NORMALIZED
            eachMeanArray = mean(firstBoutDffArray(:,(abs(examRangeIdx(1)) - normalizeWindow*round(fpObj.samplingRate)):abs(examRangeIdx(1))-1),2);
            eachSTDArray = std(firstBoutDffArray(:,(abs(examRangeIdx(1)) - normalizeWindow*round(fpObj.samplingRate)):abs(examRangeIdx(1))-1),0,2);
            repmat_mean_half = repmat(eachMeanArray,1,size(firstBoutDffArray,2));
            eachNormArray = (firstBoutDffArray - repmat(eachMeanArray,1,size(firstBoutDffArray,2)))./repmat(eachSTDArray,[1 size(meanFirstBout,2)]);
            
            meanNormFirstBout = mean(eachNormArray,1);
            steNormFirstBout = std(eachNormArray,0,1)/sqrt(size(eachNormArray,1));
            
            
            
            %% Calculating mean last lick exam Range
            lastBoutRangeIdx = repmat(boutIdx(:,2),[1 2]) +repmat(examRangeIdx,[numActualBout 1]);
            
            lastBoutDffArray = [];
            for boutNum = 1:numActualBout
                lastBoutDffArray = [lastBoutDffArray;dFF(lastBoutRangeIdx(boutNum,1):lastBoutRangeIdx(boutNum,2))'];
            end
            
            meanLastBout = mean(lastBoutDffArray,1);
            steLastBout = std(lastBoutDffArray,0,1)/sqrt(size(lastBoutDffArray,1));
            
            % Calculating mean first lick exam Range NORMALIZED
            %             eachMeanArray_last = mean(lastBoutDffArray(:,1:normalizeWindow*round(fpObj.samplingRate)),2);
            %             eachSTDArray_last = std(lastBoutDffArray(:,1:normalizeWindow*round(fpObj.samplingRate)),0,2);
            
            
            eachMeanArray_last = mean(lastBoutDffArray(:,(abs(examRangeIdx(1)) - normalizeWindow*round(fpObj.samplingRate)):abs(examRangeIdx(1))-1),2);
            eachSTDArray_last = std(lastBoutDffArray(:,(abs(examRangeIdx(1)) - normalizeWindow*round(fpObj.samplingRate)):abs(examRangeIdx(1))-1),0,2);
            
            %             eachNormArray_last = (lastBoutDffArray - repmat(eachMeanArray_last,1,size(lastBoutDffArray,2)))./repmat(eachSTDArray_last,[1 size(meanLastBout,2)]);       ;
            eachNormArray_last = (lastBoutDffArray - repmat(eachMeanArray,1,size(lastBoutDffArray,2)))./repmat(eachSTDArray,[1 size(meanLastBout,2)]);       ;
            
            
            meanNormLastBout = mean(eachNormArray_last,1);
            steNormLastBout = std(eachNormArray_last,0,1)/sqrt(size(eachNormArray_last,1));
            
            
            %% output to fpObj.idvData
            %examRange and timeV
            fpObj.examRange = examRange;
            fpObj.examRangeIdx = examRangeIdx;
            fpObj.timeV = firstBoutTimeV;
            
            %bout/licking
            fpObj.idvData(numMouse).boutIdx = boutIdx;
            fpObj.idvData(numMouse).lickingIdx = lickingIdx;
            
            fpObj.idvData(numMouse).totalNumBout = numActualBout;
            fpObj.idvData(numMouse).totalNumLicking = numLicking;
            
            %dff of bout
            
            fpObj.idvData(numMouse).firstBoutDffArray = firstBoutDffArray;
            fpObj.idvData(numMouse).lastBoutDffArray = lastBoutDffArray;
            
            fpObj.idvData(numMouse).normFirstBoutDffArray = eachNormArray;
            fpObj.idvData(numMouse).normLastBoutDffArray = eachNormArray_last;
            
            %raw
            fpObj.idvData(numMouse).meanFirstBout = meanFirstBout;
            fpObj.idvData(numMouse).steFirstBout = steFirstBout;  
            
            fpObj.idvData(numMouse).meanLastBout = meanLastBout;
            fpObj.idvData(numMouse).steLastBout = steLastBout;
            %normalized
            fpObj.idvData(numMouse).meanNormFirstBout = meanNormFirstBout;
            fpObj.idvData(numMouse).steNormFirstBout = steNormFirstBout;
            
            fpObj.idvData(numMouse).meanNormLastBout = meanNormLastBout;
            fpObj.idvData(numMouse).steNormLastBout = steNormLastBout;
            
%             fpObj.idvData(numMouse).timeV = 
            
        end
        
    case '473'
        for numMouse = 1:totalMouseNum
            %initialization
            
            boutWindow = timeWindow;
            window = round(boutWindow *fpObj.samplingRate);
            lickingIdx = fpObj.idvData(numMouse).TTLOnIdx{1,1};
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
            numActualBout = size(on_off_Idx,1);
            % getting actual bout index
            boutIdx = ones(numActualBout,2);
            boutIdx(:,1) = lickingIdx(on_off_Idx(:,1));
            boutIdx(:,2) = lickingIdx(on_off_Idx(:,2));
            raw473 = fpObj.idvData(numMouse).raw473;
            
            
            %% Calculating mean first lick exam Range
            
            examRange = [-timeWindow timeWindow];
            examRangeIdx = examRange * round(fpObj.samplingRate);
            firstBoutRangeIdx = boutIdx(:,1) +examRangeIdx;
            for i = size(firstBoutRangeIdx,1):-1:1
                if firstBoutRangeIdx(i,1) <= 0
                    firstBoutRangeIdx(i,:) = [];
                    numActualBout = numActualBout - 1;
                end
            end
            % MODIFIED TO get DFF from 473 ONLY need to get median vector from
            % timewindow.
            medianArray = [];
            for boutNum = 1:numActualBout
                medianArray = [medianArray;median(raw473(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,1)+window))];
            end
            
            firstBoutDffArray = [];
            for boutNum = 1:numActualBout
                firstBoutDffArray = [firstBoutDffArray;...
                    ((raw473(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2))-medianArray(boutNum))'./medianArray(boutNum))*100];
            end
            firstBoutTimeV = linspace(examRange(1),examRange(2),size(firstBoutDffArray,2));
            
            meanFirstBout = mean(firstBoutDffArray,1);
            steFirstBout = std(firstBoutDffArray,0,1)/sqrt(size(firstBoutDffArray,1));
            
            % Calculating mean first lick exam Range NORMALIZED
            eachMeanArray = mean(firstBoutDffArray(:,1:examRange(2)*round(fpObj.samplingRate)),2);
            eachSTDArray = std(firstBoutDffArray(:,1:examRange(2)*round(fpObj.samplingRate)),0,2);
            eachNormArray = (firstBoutDffArray - repmat(eachMeanArray,1,size(firstBoutDffArray,2)))./eachSTDArray;
            
            meanNormFirstBout = mean(eachNormArray,1);
            steNormFirstBout = std(eachNormArray,0,1)/sqrt(size(eachNormArray,1));
            
            
            
            %% Calculating mean last lick exam Range
            lastBoutRangeIdx = boutIdx(:,2) +examRangeIdx;
            
            lastBoutDffArray = [];
            %             for boutNum = 1:numActualBout
            %                 lastBoutDffArray = [lastBoutDffArray;dFF(lastBoutRangeIdx(boutNum,1):lastBoutRangeIdx(boutNum,2))'];
            %             end
            %
            for boutNum = 1:numActualBout
                lastBoutDffArray = [lastBoutDffArray;...
                    ((raw473(lastBoutRangeIdx(boutNum,1):lastBoutRangeIdx(boutNum,2))-medianArray(boutNum))'./medianArray(boutNum))*100];
            end
            
            meanLastBout = mean(lastBoutDffArray,1);
            steLastBout = std(lastBoutDffArray,0,1)/sqrt(size(lastBoutDffArray,1));
            
            % Calculating mean first lick exam Range NORMALIZED
            eachMeanArray_last = mean(lastBoutDffArray(:,1:timeWindow*round(fpObj.samplingRate)),2);
            eachSTDArray_last = std(lastBoutDffArray(:,1:timeWindow*round(fpObj.samplingRate)),0,2);
            eachNormArray_last = (lastBoutDffArray - eachMeanArray_last)./eachSTDArray_last;
            
            meanNormLastBout = mean(eachNormArray_last,1);
            steNormLastBout = std(eachNormArray_last,0,1)/sqrt(size(eachNormArray_last,1));
            
            
            
            
            %% output to fpObj.idvData
            %examRange and timeV
            fpObj.examRange = examRange;
            fpObj.examRangeIdx = examRangeIdx;
            fpObj.timeV = firstBoutTimeV;
            
            %bout/licking
            fpObj.idvData(numMouse).boutIdx = boutIdx;
            fpObj.idvData(numMouse).lickingIdx = lickingIdx;
            
            fpObj.idvData(numMouse).totalNumBout = numActualBout;
            fpObj.idvData(numMouse).totalNumLicking = numLicking;
            %raw
            fpObj.idvData(numMouse).meanFirstBout = meanFirstBout;
            fpObj.idvData(numMouse).steFirstBout = steFirstBout;
            
            fpObj.idvData(numMouse).meanLastBout = meanLastBout;
            fpObj.idvData(numMouse).steLastBout = steLastBout;
            %normalized
            fpObj.idvData(numMouse).meanNormFirstBout = meanNormFirstBout;
            fpObj.idvData(numMouse).steNormFirstBout = steNormFirstBout;
            
            fpObj.idvData(numMouse).meanNormLastBout = meanNormLastBout;
            fpObj.idvData(numMouse).steNormLastBout = steNormLastBout;
            
            
        end
        
end
