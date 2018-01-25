function plotFirstLickHeatmap(fpObj,upperExamRange)
%detailed explanation goes here


%initialization
% left = 0;bottom = 6;width = 4;height = 3;
% examRange = fpObj.examRange;
% timeV = fpObj.timeV;
% %iterate through all mice data
% totalfpObjNum = size(fpObj,2);
% totalMouseNum = fpObj.totalMouseNum;

% for fpObjNum = 1:totalfpObjNum
%     for mouseNum = 1:totalMouseNum
%         %% Plotting mean first lick exam Range
%
%         figure('Units','inch','Position',[left bottom width height]);
%         trialNum = size(fpObj(fpObjNum).idvData(mouseNum).firstBoutDffArray,1);
%         imagesc(timeV,1:trialNum,fpObj(fpObjNum).idvData(mouseNum).firstBoutDffArray)
%         colormap(gca,'hot');
%         set(gca,'YDir','reverse');
%         c=colorbar;
% %         caxis([-5 5]);
%
%         c.Label.String = '\DeltaF/F(%)';
%
%         xlabel('Time (s)');
%         ylabel('Trials');
%         xlim(examRange);
%         ylim([0.5 trialNum+0.5]);
%         set(gca,'YTick',0:5:trialNum);
%         set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
%         set(gcf,'Color',[1 1 1]);
%         hold on
%         plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
%         titleString = [fpObj(fpObjNum).idvData(mouseNum).Description ' \_Raw \DeltaF/F'];
%         title(titleString,'FontSize',10);
%         saveas(gcf,[fpObj.idvData(mouseNum).Description ' First Lick heatmap' '.jpg'])
%
% before and after first lick mean
totalfpObjNum = size(fpObj,2);
totalMouseNum = fpObj.totalMouseNum;
examRange = [fpObj.examRange(1) upperExamRange];
examRangeIdx = examRange * round(fpObj.samplingRate);
for fpObjNum = 1:totalfpObjNum
    for mouseNum = 1:totalMouseNum
        dFF = fpObj.idvData(mouseNum).dFF;
        timeV = fpObj.idvData(mouseNum).timeVectors;
        boutIdx = fpObj.idvData(mouseNum).boutIdx;
        lickingIdx = fpObj.idvData(mouseNum).lickingIdx;
        % numLicking =  fpObj.idvData(numMouse).totalNumLicking;
        numBout = fpObj.idvData(mouseNum).totalNumBout;
        plotRangeIdx = boutIdx(:,1) + examRangeIdx;
        
        %% Calculating raw and normalized dFF trace of each bout
        
        numColumns = examRangeIdx(2) - examRangeIdx(1) + 1;
        eachBoutTimeV = linspace(examRange(1), examRange(2), numColumns);
        
        eachBoutDffArray = zeros(numBout, numColumns);
        
        for boutOrder = 1 : numBout
            eachBoutDffArray(boutOrder, :) = dFF(plotRangeIdx(boutOrder,1):plotRangeIdx(boutOrder,2))';
        end
        
        % normalization
        meanEachBoutArray = repmat(mean(eachBoutDffArray(:, 1:(-examRangeIdx(1))), 2), 1, numColumns);
        stdEachBoutArray = repmat(std(eachBoutDffArray(:, 1:(-examRangeIdx(1))), 0, 2), 1, numColumns);
        eachBoutNormDffArray = (eachBoutDffArray - meanEachBoutArray)./stdEachBoutArray;
        
        % Plotting mean first lick exam Range

        figure
        imagesc(eachBoutTimeV,1:numBout,eachBoutDffArray)
        colormap(gca,'hot');
        set(gca,'YDir','reverse');
        c=colorbar;

        c.Label.String = '\DeltaF/F(%)';

        xlabel('Time (s)');
        ylabel('bout Number');
        xlim(examRange);
        ylim([0.5 numBout+0.5]);
        set(gca,'YTick',0:5:numBout);
        set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
        set(gcf,'Color',[1 1 1]);
        hold on
        plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        titleString = [fpObj(fpObjNum).idvData(mouseNum).Description ' \_Raw \DeltaF/F FirstLick'];
        title(titleString,'FontSize',10);
        saveas(gcf,[fpObj.idvData(mouseNum).Description ' First Lick heatmap' '.jpg'])       
        
        % mean heatmap
        figure('Units','inch','Position',[3 3 6 1.5])%,'visible','off');

        imagesc(eachBoutTimeV,1,mean(eachBoutDffArray))
        colormap(gca,'hot');
        set(gca,'YDir','reverse');
        c=colorbar;

        c.Label.String = '\DeltaF/F(%)';

        xlabel('Time (s)');
        ylabel('bout Number');
        xlim(examRange);
        set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
        set(gca,'YTick',1);
        
        set(gcf,'Color',[1 1 1]);
        hold on
        plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        titleString = [fpObj(fpObjNum).idvData(mouseNum).Description ' \_Raw \DeltaF/F mean FirstLick'];
        title(titleString,'FontSize',10);
        saveas(gcf,[fpObj.idvData(mouseNum).Description ' First Lick mean heatmap' '.jpg'])       
    end
end