function fpObj = normalize(fpObj)
%%
    %% Initialization
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    totalWaveNum = fpObj(fpObjNum).waveNum;
    examRange = fpObj(fpObjNum).examRange;
    group_trialArray = [];
    group_trialArray_norm = [];
    group_TA_mean = [];
    group_TA_std = [];
    concatMeanArray = [];
    concatNorm_MeanArray = [];
    
    %% grouping individual data into a struct, groupData.tiral_dFF
    for mouseNum = 1:totalMouseNum
        for waveNum = 1:totalWaveNum
            group_trialArray = [group_trialArray ;fpObj(fpObjNum).idvData(mouseNum).trialArray];
            
            %generating exam Range vector that is linearly spaced between examRange(1)
            %to examRange(2)
            if mouseNum == 1 && waveNum == 1
                examRangeLength = length(fpObj(fpObjNum).idvData(mouseNum).mean{waveNum});
                examRangeVector = linspace(examRange(1),examRange(2),examRangeLength);
                [min_value min_index] = min(abs(examRangeVector));
            end
            %getting mean dff of individual mouse
            %meanDFF(mouseNum,:) = mean(group_trialArray{mouseNum,1});
            
            %getting normalized dff of individual mouse
            %firstHalfMean = mean(meanDFF(1,floor(1:end/2)));
            %firstHalfSTD = std(meanDFF(1,floor(1:end/2)));
            %meanDFF_norm(mouseNum,:) = (meanDFF(mouseNum,:) - firstHalfMean)./firstHalfSTD;
            
            group_TA_mean{mouseNum,waveNum} = mean(group_trialArray{mouseNum,waveNum}(:,1:min_index),2);
            group_TA_std{mouseNum,waveNum} = std(group_trialArray{mouseNum,waveNum}(:,1:min_index),0,2);
            group_trialArray_norm{mouseNum,waveNum} = (group_trialArray{mouseNum,waveNum}...
                - repmat(group_TA_mean{mouseNum,waveNum},1,size(group_trialArray{mouseNum,waveNum},2)))./repmat(group_TA_std{mouseNum,waveNum},1,size(group_trialArray{mouseNum,waveNum},2));
            
            fpObj(fpObjNum).idvData(mouseNum).norm_trialArray{waveNum} = group_trialArray_norm{mouseNum,waveNum};
            fpObj(fpObjNum).idvData(mouseNum).norm_mean{waveNum}=  mean(group_trialArray_norm{mouseNum,waveNum},1);
            fpObj(fpObjNum).idvData(mouseNum).norm_ste{waveNum}=  std(group_trialArray_norm{mouseNum,waveNum},0,1)/sqrt(size(group_trialArray_norm{mouseNum,waveNum},1));
            
            concatMeanArray = [concatMeanArray; fpObj(fpObjNum).idvData(mouseNum).mean{waveNum}];
            concatNorm_MeanArray = [concatNorm_MeanArray; fpObj(fpObjNum).idvData(mouseNum).norm_mean{waveNum}];
            
        end
        
    end
    
    %% saving concat Raw and Norm array. Also calculate mean and ste

    fpObj(fpObjNum).meanRawArray = mean(concatMeanArray,1);
    fpObj(fpObjNum).meanNormArray = mean(concatNorm_MeanArray,1);
    fpObj(fpObjNum).steRawArray = std(concatMeanArray,0,1)/sqrt(size(concatMeanArray,1));
    fpObj(fpObjNum).steNormArray = std(concatNorm_MeanArray,0,1)/sqrt(size(concatNorm_MeanArray,1));
    
end
