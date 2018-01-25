%% plotTraceACTIVEIR
%Created by Jonghwi Park and Sieun Jung
%7/11/2017
%Description:

%
%
function output = plotTraceACTIVEIR(fpObj,delay)
%initialization
totalMouseNum = fpObj.totalMouseNum;
totalWaveNum = fpObj.waveNum;
examRange = fpObj.examRange;
timeRange = round(fpObj.idvData(1).TTLOffTimes{1,1}(1,1) ...
    - fpObj.idvData(1).TTLOnTimes{1,1}(1,1));
%% grouping individual data into a struct, groupData.tiral_dFF
for waveNum = 1:totalWaveNum;
    for mouseNum = 1:totalMouseNum;
        group_trialArray = [];
        group_trialArray_norm = [];         

        group_trialArray = [group_trialArray ;fpObj.idvData(mouseNum).trialArray{1,waveNum}];        
        
        %generating exam Range vector that is linearly spaced between examRange(1)
        %to examRange(2)
       
        %getting mean dff of individual mouse
        meanDFF(mouseNum,:) = mean(group_trialArray);
        
        % calculating normalized group data's mean and ste
        groupmean = mean(meanDFF,1);
        groupste = std(meanDFF,1) / sqrt(size(meanDFF,1));
    end  
       %%     
        figure(waveNum)
        hold on;
        
        if delay == 1    %If there is delay...
            if waveNum == 1
                examRangeVector = linspace(examRange(1)+2,examRange(2)+2,length(fpObj.timeWindow)+1);
                shadedplot=shadedErrorBar(examRangeVector,groupmean,groupste,'b');
                xlim(examRange);
                set(gcf,'Color',[1 1 1]);
                yRange = ylim;
                r = patch([2 timeRange+2 timeRange+2 2], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
                     [.1,.1,.1,.1],[1,.7,.7]);
                set(r, 'FaceAlpha', 0.2,'LineStyle','none');
                uistack(r,'top')

            else 
                examRangeVector = linspace(examRange(1),examRange(2),length(fpObj.timeWindow)+1);
                shadedplot=shadedErrorBar(examRangeVector,groupmean,groupste,'b');
                xlim(examRange);
                set(gcf,'Color',[1 1 1]);
                yRange = ylim;
                plot([0 0],yRange,'LineStyle','--','Color','r')
            end
                
        else
            examRangeVector = linspace(examRange(1),examRange(2),length(fpObj.timeWindow)+1);
            shadedplot=shadedErrorBar(examRangeVector,groupmean,groupste,'b');
            xlim(examRange);
            set(gcf,'Color',[1 1 1]);
            yRange = ylim;
            r = patch([0 timeRange timeRange 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
                [.1,.1,.1,.1],[1,.7,.7]);
            set(r, 'FaceAlpha', 0.2,'LineStyle','none');
            uistack(r,'top')

        end
        
        xlabel('Time (s)');
        ylabel('\DeltaF/F (%)');
        title([fpObj.groupInfo{1,1} ' ' fpObj.expDescription{1,1} '\_' fpObj.waveTitle{1,waveNum} ' Raw \DeltaF/F (%)' ]);
        saveas(gcf,[fpObj.groupInfo{1,1} ' ' fpObj.expDescription{1,1} ' ' fpObj.waveTitle{1,waveNum} ' raw dff.jpg' ])

        output = shadedplot;
end

