function  plotmsFR1(msObj,saveFigures)
if nargin<2
    saveFigures = 'n';
    disp(['Not saving figures; display mode is on']);
else
    saveFigures = saveFigures;
end
%% initialization
msData = msObj.msData;
medData = msObj.medData;
examRange = msObj.examRange;
examRangeIdx = msObj.examRangeIdx;
frameRate =msObj.framRate;

%msData
timeStamp = msData.timeStamp;
neuron = msData.neuron;
C_raw = neuron.C_raw;
numOfFrames = msObj.msData.numOfFrames;
numTotalNeuron = msObj.msData.numTotalNeuron;

%extracted medData
activeLever_examRangeIdx= msObj.activeLever_examRangeIdx;
activeLeverTimeIdx = msObj.medData.activeLeverTimeIdx;
totalNumActive = msObj.medData.totalNumActive;

inactiveLever_examRangeIdx = msObj.inactiveLever_examRangeIdx;
inactiveLeverTimeIdx = msObj.medData.inactiveLeverTimeIdx;
totalNumInactive = msObj.medData.totalNumInactive;

rewardTimeIdx_examRangeIdx = msObj.rewardTimeIdx_examRangeIdx;
rewardTimeIdx = msObj.medData.rewardTimeIdx;
totalNumReward = msObj.medData.totalNumReward;

portEntryTimeIdx_examRangeIdx = msObj.portEntryTimeIdx_examRangeIdx;
portEntryTimeIdx = msObj.medData.portEntryTimeIdx;
totalNumPortEntry = msObj.medData.totalNumPortEntry;


%%
f1 = figure('Units','inch','Position',[.5 .5 15 8],'Visible','on');

for neuronNum = 1: numTotalNeuron
    for caseNum = 1:4
        switch caseNum %i have to add subplot control
            case 1
                everyActionIdx = activeLeverTimeIdx;
                totalNumAction = totalNumActive;
                action_examRange_Idx = activeLever_examRangeIdx;
                subplotIdx = 1;
                titleString = 'Active';
            case 2
                everyActionIdx = inactiveLeverTimeIdx;
                totalNumAction = totalNumInactive;
                action_examRange_Idx = inactiveLever_examRangeIdx;
                subplotIdx = 5;
                titleString = 'Inactive';
            case 3
                everyActionIdx = rewardTimeIdx;
                totalNumAction = totalNumReward;
                action_examRange_Idx = rewardTimeIdx_examRangeIdx;
                subplotIdx = 9;
                titleString = 'Reward';
            case 4
                everyActionIdx = portEntryTimeIdx;
                totalNumAction = totalNumPortEntry;
                action_examRange_Idx = portEntryTimeIdx_examRangeIdx;
                subplotIdx = 13;
                titleString = 'PortEntry';
        end
        
        action_Array = [];
        for i = 1:totalNumAction
            if action_examRange_Idx(i,2) > numOfFrames || action_examRange_Idx(i,1) >numOfFrames
            else
                action_Array(i,:) = C_raw(neuronNum,action_examRange_Idx(i,1):action_examRange_Idx(i,2));
            end
        end
        %% GENERAL PLOTTING FUCNTION
        %1. full plot
        subplot(4,4,subplotIdx:subplotIdx+1)
        plot(timeStamp,C_raw(neuronNum,:));
        hold on
        xlim([timeStamp(1) timeStamp(end)]);
        yRange = ylim;
        xRange = xlim;
        for i = 1:totalNumAction
            line([timeStamp(everyActionIdx(i)) timeStamp(everyActionIdx(i))], [0 yRange(2)],'Color','r');
        end
        set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
        set(gca, 'box', 'off')
        set(gcf,'Color',[1 1 1])
        set(gca,'TickDir','out');
        title(titleString)
        ylabel('\DeltaF');
        if caseNum ~=4
            set(gca,'XTick',[]);
        else
            xlabel('Time (s)')
        end
        %2. line graph
        subplot(4,4,subplotIdx+2)
        meanArray = mean(action_Array,1);
        if size(action_Array,1) == 1
            plot(timeV,meanArray)
        elseif size(action_Array,1) == []
        else
        steArray = std(action_Array,0,1)/sqrt(size(action_Array,1));
        timeV = linspace(examRange(1),examRange(2),size(action_Array,2));
        mseb(timeV,meanArray,steArray);
        end
        yRange = ylim;
        hold on
        
        plot([0 0],ylim,'Color',[1 0 0]);
        plot([0 0],ylim,'Color',[1 0 0]);
        set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
        set(gca, 'box', 'off')
        set(gca,'TickDir','out');
        set(gcf,'Color',[1 1 1])
        xlim(examRange);
        ylim(yRange)
        ylabel('\DeltaF');
        if caseNum ~=4
            set(gca,'XTick',[]);
        else
            xlabel('Time (s)')
        end
        
        %3. heatmap
        subplot(4,4,subplotIdx+3)
        imagesc(timeV,1:1:totalNumAction,action_Array);
        hold on
        plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        if caseNum ~=4
            set(gca,'XTick',[]);
        else
            xlabel('Time (s)')
        end
        h = gca;
        cm = colormap(gca,'hot');
        c2 = colorbar(...
            'Location',         'eastoutside');
        hL = ylabel(c2,'\DeltaF');
        
        ylabel([titleString ' #']);
        set(gca,...
            'linewidth',           2.0,...
            'FontSize',            10,...
            'FontName',          'Arial',...
            'TickDir',            'out',...
            'box',               'off')
        set(gcf,'Color',[1 1 1])
        
    end
    %% save this graph
    if saveFigures == 'y' || saveFigures == 'Y'
        export_fig(gcf,['neuronNum ' num2str(neuronNum) '.jpg'])
%         pause(0.5)
    else
        pause
    end
    clf
end
end
