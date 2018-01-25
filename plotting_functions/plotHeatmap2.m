function fpObj=plotHeatmap2(fpObj)
totalMouseNum = fpObj.totalMouseNum;
totalWaveNum = fpObj.waveNum;
examRange = fpObj.examRange;

% customColorMap = zeros(100,3);
% customColorMap(:,1) = 0.01:0.01:1;
% customColorMap(:,2) = 1:-0.01:0.01;
% customColorMap(:,3) = 1:-0.01:0.01;

group_trialArray = [];
group_trialArray_norm = [];
            
for mouseNum = 1:totalMouseNum;
    for waveNum = 1:totalWaveNum;
        if fpObj.dispBoolean(waveNum);
            
            for waveNum = 1:totalWaveNum;
                if fpObj.dispBoolean(waveNum);
                    group_trialArray = [group_trialArray ;fpObj.idvData(mouseNum).trialArray];
                    
                end
            end
            fpObj.groupData.trial_dFF = group_trialArray;
            
            trialArray=fpObj.idvData(mouseNum).trialArray{waveNum};
            trialNum = size(fpObj.idvData(mouseNum).trialArray{waveNum},1);
            
            examRangeLength = length(fpObj.idvData(mouseNum).mean{waveNum});
            examRangeVector = examRange(1):(examRange(2)-examRange(1))/examRangeLength:examRange(2);
            examRangeVector = examRangeVector(1:end-1);
            
            figure;
            hold on;
            imagesc(examRangeVector,1:trialNum,trialArray)
            % cm = colormap(gca,customColorMap);
            cm = colormap(gca,'hot')
            set(gca,'YDir','reverse');
            colorbar
            xlabel('Time (s)');
            ylabel('Trials');
            xlim(examRange);
            ylim([0.5 trialNum+0.5]);
            set(gca,'YTick',1:trialNum);
            title([fpObj.idvData(mouseNum).Description ' Response to ' fpObj.waveTitle{waveNum}]);
            
            
            trial_dFF_norm = []
            for i = 1:size(group_trialArray{1},1);
                    trial_dFF = group_trialArray{mouseNum}(i,:);
                    mean_event = mean(trial_dFF(1:floor(end/2)));
                    std_event = std(trial_dFF(1:floor(end/2)));
                    event_dFF_norm = (trial_dFF - mean_event)/std_event;
                    trial_dFF_norm = [trial_dFF_norm; event_dFF_norm];
            end

            
            group_trialArray_norm =[]
            for waveNum = 1:totalWaveNum
                if fpObj.dispBoolean(waveNum)
                    group_trialArray_norm = [group_trialArray_norm ;trial_dFF_norm];
                    
                end
            end
            
            fpObj.groupData.trial_dFF_norm{mouseNum} = group_trialArray_norm;
            trialArray=fpObj.groupData.trial_dFF_norm{mouseNum};

            figure;
            hold on;
            imagesc(examRangeVector,1:trialNum,trialArray)
            % cm = colormap(gca,customColorMap);
            cm = colormap(gca,'hot')
            set(gca,'YDir','reverse');
            colorbar            
            xlabel('Time (s)');
            ylabel('Trials');
            xlim(examRange);
            ylim([0.5 trialNum+0.5]);
            set(gca,'YTick',1:trialNum);
            
            title([fpObj.idvData(mouseNum).Description ' Response to ' fpObj.waveTitle{waveNum}]);
        
        end
    end
    saveas(gcf,[fpObj.idvData(mouseNum).Description 'HeatMap.png'])
end
end
