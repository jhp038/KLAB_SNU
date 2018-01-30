function fpObj = normalize_dual(fpObj,normalizeWindow)
%% Newly added function: normalizeWindow
%for now, I am not considerfing 
%1. multiple number of fpObj
%2. waveNum more than 1.
% such functionality will be added soon.


%% Initialization
totalMouseNum = fpObj.totalMouseNum;
totalWaveNum = fpObj.waveNum;
samplingRate = round(fpObj.samplingRate);
examRange = fpObj.examRange;
examRangeIdx = fpObj.examRangeIdx;
normalizeWindowIdx = normalizeWindow * samplingRate;
tempArray = [];
group_trialArray_norm = [];
group_TA_mean = [];
group_TA_std = [];
concatMeanArray = [];
concatNorm_MeanArray = [];
%calculating necessary idxes...
zeroIdx = abs(examRangeIdx(1));
actualWindowIdx = zeroIdx +normalizeWindowIdx;

%% grouping individual data into a struct, groupData.tiral_dFF
for mouseNum = 1:totalMouseNum
    for waveNum = 1:totalWaveNum
        for numdFF = 1:2
            tempArray = [];

            tempArray = [tempArray ;fpObj.idvData(mouseNum).trialArray{numdFF}];
            
            %generating exam Range vector that is linearly spaced between examRange(1)
            %to examRange(2)
            if mouseNum == 1 && waveNum == 1
                examRangeLength = length(fpObj.idvData(mouseNum).mean{waveNum});
                examRangeVector = linspace(examRange(1),examRange(2),examRangeLength);
                [min_value min_index] = min(abs(examRangeVector));
            end
            %getting mean dff of individual mouse
            %meanDFF(mouseNum,:) = mean(group_trialArray{mouseNum,1});
            
            %getting normalized dff of individual mouse
            %firstHalfMean = mean(meanDFF(1,floor(1:end/2)));
            %firstHalfSTD = std(meanDFF(1,floor(1:end/2)));
            %meanDFF_norm(mouseNum,:) = (meanDFF(mouseNum,:) - firstHalfMean)./firstHalfSTD;
            
            group_TA_mean{mouseNum,numdFF} = mean(tempArray(:,actualWindowIdx(1):actualWindowIdx(2)),2);
            group_TA_std{mouseNum,numdFF} = std(tempArray(:,actualWindowIdx(1):actualWindowIdx(2)),0,2);
            
            group_trialArray_raw{mouseNum,numdFF} = tempArray;
            group_trialArray_norm{mouseNum,numdFF} = tempArray...
                - repmat(group_TA_mean{mouseNum,numdFF},1,size(tempArray,2))./repmat(group_TA_std{mouseNum,numdFF},1,size(tempArray,2));
            
            group_trialArray_rawMean{mouseNum,numdFF} = mean(group_trialArray_raw{mouseNum,numdFF});
            group_trialArray_normMean{mouseNum,numdFF} = mean(group_trialArray_norm{mouseNum,numdFF});
%             group_TA_mean{mouseNum,waveNum} = mean(group_trialArray{mouseNum,waveNum}(:,1:min_index),2);
%             group_TA_std{mouseNum,waveNum} = std(group_trialArray{mouseNum,waveNum}(:,1:min_index),0,2);
%             group_trialArray_norm{mouseNum,waveNum} = (group_trialArray{mouseNum,waveNum}...
%                 - repmat(group_TA_mean{mouseNum,waveNum},1,size(group_trialArray{mouseNum,waveNum},2)))./repmat(group_TA_std{mouseNum,waveNum},1,size(group_trialArray{mouseNum,waveNum},2));
%             
%             fpObj.idvData(mouseNum).norm_trialArray{waveNum} = group_trialArray_norm{mouseNum,waveNum};
%             fpObj.idvData(mouseNum).norm_mean{waveNum}=  mean(group_trialArray_norm{mouseNum,waveNum},1);
%             fpObj.idvData(mouseNum).norm_ste{waveNum}=  std(group_trialArray_norm{mouseNum,waveNum},0,1)/sqrt(size(group_trialArray_norm{mouseNum,waveNum},1));
%             
%             concatMeanArray = [concatMeanArray; fpObj.idvData(mouseNum).mean{waveNum}];
%             concatNorm_MeanArray = [concatNorm_MeanArray; fpObj.idvData(mouseNum).norm_mean{waveNum}];
            
        end
    end
end

%% saving concat Raw and Norm array. Also calculate mean and ste


fpObj.group_trialArray_raw = group_trialArray_raw;
fpObj.group_trialArray_norm = group_trialArray_norm;
fpObj.group_trialArray_rawMean = group_trialArray_rawMean;
fpObj.group_trialArray_normMean = group_trialArray_normMean;

end
