%% plotHeatmap
%Created by Jonghwi Park
%7/19/2017
%Description:

%
%
function plotHeatmap(fpObj,saveChoice)
%initialization 
totalfpObjNum = size(fpObj,2);
left = 0;bottom = 6;width =  5;height = 4; 

for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    totalWaveNum = fpObj(fpObjNum).waveNum;
    examRange = fpObj(fpObjNum).examRange;
    timeRange = round(fpObj(fpObjNum).idvData(1).TTLOffTimes{1,1}(1,1) ...
        - fpObj(fpObjNum).idvData(1).TTLOnTimes{1,1}(1,1));
    examRangeVector = linspace(examRange(1),examRange(2),length(fpObj(fpObjNum).timeWindow)+1);
% %% Plotting RAW trace
%     %left, bottom, width and height of figure are in INCH
%     
%     figure('Units','inch','Position',[left bottom width height]);
%     hold on;
%     %plotting shaded error bar
%     shadedErrorBar(examRangeVector,fpObj(fpObjNum).meanRawArray,fpObj(fpObjNum).steRawArray,'b');
%     % Plotting individual mean data with gray color
%     for mouseNum = 1:totalMouseNum
%         for waveNum = 1:totalWaveNum
%         hold on;
%         plot(examRangeVector,fpObj(fpObjNum).idvData(mouseNum).mean{waveNum} ,'Color',[.5 .5 .5])   
%         end
%     end  
    %%
    for mouseNum = 1:totalMouseNum
        %% Raw Heatmap
        figure('Units','inch','Position',[left bottom width height]);
        trialNum = size(fpObj(fpObjNum).idvData(mouseNum).trialArray{1,1},1);
        imagesc(examRangeVector,1:trialNum,fpObj(fpObjNum).idvData(mouseNum).trialArray{1,1})
        cm = colormap(gca,'hot');
        set(gca,'YDir','reverse');
        colorbar
        xlabel('Time (s)');
        ylabel('Trials');
        xlim(examRange);
        ylim([0.5 trialNum+0.5]);
        set(gca,'YTick',0:5:trialNum);
        set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
        set(gcf,'Color',[1 1 1]);
        hold on
        plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        plot([timeRange,timeRange],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
%         plot([10,10],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);        
        titleString = [fpObj(fpObjNum).idvData(mouseNum).Description ' \_Raw \DeltaF/F'];
        title(titleString,'FontSize',10);
        if saveChoice == 1
            saveas(gcf,[fpObj(fpObjNum).idvData(mouseNum).Description ' Raw Heatmap.jpg'])
        end
        %% Normalized
        figure('Units','inch','Position',[left bottom-height/2 width height]);
        left = left + width/2;
        imagesc(examRangeVector,1:trialNum,fpObj(fpObjNum).idvData(mouseNum).norm_trialArray{1,1})
        cm = colormap(gca,'hot');
        set(gca,'YDir','reverse');
        colorbar
        xlabel('Time (s)');
        ylabel('Trials');
        xlim(examRange);
        ylim([0.5 trialNum+0.5]);
        set(gca,'YTick',0:5:trialNum);
        set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')     
        set(gcf,'Color',[1 1 1]);
        hold on
        plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        plot([timeRange,timeRange],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        %         plot([10,10],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
        titleString = [fpObj(fpObjNum).idvData(mouseNum).Description ' \_Norm \DeltaF/F'];
        title(titleString,'FontSize',10);        
        if saveChoice == 1
            saveas(gcf,[fpObj(fpObjNum).idvData(mouseNum).Description ' Norm Heatmap.jpg'])
        end
end
end


