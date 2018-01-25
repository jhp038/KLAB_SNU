function boutAnalysis(fpObj,timeWindow,numWindow)
totalMouseNum = fpObj.totalMouseNum;
left = 0;bottom = 6;width = 5;height = 4;
for numMouse = 1:totalMouseNum
    %initialization
    
    boutWindow = timeWindow;
    window = round(boutWindow *fpObj.samplingRate);
    lickingIdx = fpObj.idvData(numMouse).TTLOnIdx{1,1};
    numLicking = size(lickingIdx,1);
    %a drinking bout is defined as any set of ten or more licks in which no interlick
    % interval is greater than one second
    
    %% first threshold -> Interlick interval greater than 1 sec
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
    
    %% Second Threshold -> 10 or more licks in each interval
    for i = 1:numPossibleBout
        if (on_off_Idx(i,2) - on_off_Idx(i,1)) < numWindow % changed criteria
            on_off_Idx(i,:) = 0;
        end
    end
    on_off_Idx = snip(on_off_Idx,'0');
    
    % Get bout index on dFF data
    numActualBout = size(on_off_Idx,1);
    %getting actual bout index
    boutIdx = ones(numActualBout,2);
    boutIdx(:,1) = lickingIdx(on_off_Idx(:,1));
    boutIdx(:,2) = lickingIdx(on_off_Idx(:,2));
    dFF = fpObj.idvData(numMouse).dFF;
    timeV = fpObj.idvData(numMouse).timeVectors;
    %% Plotting dFF with bout
 
    
    figure('Units','inch','Position',[left bottom width+2 height]);
    left = left + width+2+.2;
    
    % plot(timeV(boutRangeIdx(i,1):boutRangeIdx(i,2)),dFF(boutRangeIdx(i,1):boutRangeIdx(i,2)))
    plot(timeV,dFF)
    hold on
    xlim([timeV(1) timeV(end)]);
    yRange = ylim;
    xRange = xlim;
    
    yValLicking = repmat(yRange(2),size(lickingIdx,1),1);
    plot(timeV(lickingIdx),yValLicking,'s','MarkerSize',2,'Color','r')

    %Shading bout as light red
    for i = 1:size(boutIdx,1)
        r = patch([timeV(boutIdx(i,1)) timeV(boutIdx(i,2)) timeV(boutIdx(i,2)) timeV(boutIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    
    
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca, 'box', 'off')
    
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)'); 
    title({[fpObj.idvData(numMouse).Description ' Bout Analysis'];...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numActualBout)];...
        ['Interval = ' num2str(timeWindow) 's'  '     Interlick = ' num2str(numWindow) ' licks' ]},...
        'FontSize',10)
%     saveas(gcf,[fpObj.idvData(numMouse).Description ' Bout Analysis' '.jpg'])
    %% Plotting mean first lick exam Range = -15 15
    
    %examRange = fpObj.examRange;
    examRange = [-timeWindow timeWindow];
    examRangeIdx = examRange * window;
    firstBoutRangeIdx = boutIdx(:,1) +examRangeIdx;
    for i = size(firstBoutRangeIdx,1):-1:1
        if firstBoutRangeIdx(i,1) <= 0
            firstBoutRangeIdx(i,:) = [];
            numActualBout = numActualBout - 1;
        end
    end
    firstBoutDffArray = [];
    for boutNum = 1:numActualBout
        firstBoutDffArray = [firstBoutDffArray;dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2))'];
    end
    firstBoutTimeV = linspace(examRange(1),examRange(2),size(firstBoutDffArray,2));
    meanFirstBout = mean(firstBoutDffArray,1);
    steFirstBout = std(firstBoutDffArray,0,1)/sqrt(size(firstBoutDffArray,1));
    figure('Units','inch','Position',[left bottom width height]);
    left = left + width+.2;
    mseb(firstBoutTimeV,meanFirstBout,steFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca, 'box', 'off')
    
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    title([fpObj.idvData(numMouse).Description ' First Lick'],'FontSize',10)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
   
%     saveas(gcf,[fpObj.idvData(numMouse).Description ' First Lick' '.jpg'])
    
    
    %% Plotting mean first lick exam Range = -15 15 NORMALIZED
    eachMeanArray = mean(firstBoutDffArray(:,1:examRangeIdx(2)),2);
    eachSTDArray = std(firstBoutDffArray(:,1:examRangeIdx(2)),0,2);
%     eachNormArray = (firstBoutDffArray - eachMeanArray)./eachSTDArray;
        eachNormArray = (firstBoutDffArray - repmat(eachMeanArray,1,size(firstBoutDffArray,2)))./eachSTDArray;

    meanNormFirstBout = mean(eachNormArray,1);
    steNormFirstBout = std(eachNormArray,0,1)/sqrt(size(eachNormArray,1));
    
    figure('Units','inch','Position',[left bottom width height]);
    
    mseb(firstBoutTimeV,meanNormFirstBout,steNormFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca, 'box', 'off')
     
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('n\DeltaF/F');
    title([fpObj.idvData(numMouse).Description ' (Norm) First Lick'],'FontSize',10)
    
    plot([0 0],ylim,'Color',[1 0 0]);
%     saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm First Lick' '.jpg'])
    
    left = 0;
    bottom = bottom - height-.5;
end
end


