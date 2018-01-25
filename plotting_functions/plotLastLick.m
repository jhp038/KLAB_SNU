function plotLastLick(fpObj)
%initialization
left = 0;bottom = 6;width = 4;height = 3;
examRange = fpObj.examRange;
timeV = fpObj.timeV;
%iterate through all mice data
totalMouseNum = fpObj.totalMouseNum;
for numMouse = 1:totalMouseNum
%% Plotting mean last lick exam Range
    
    figure('Units','inch','Position',[left bottom width height]);
    left = left + width+.2;
    mseb(timeV,fpObj.idvData(numMouse).meanLastBout,fpObj.idvData(numMouse).steLastBout);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')   
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    
    title([fpObj.idvData(numMouse).Description ' Last Lick'],'FontSize',10)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
   
    xlim([examRange(1) examRange(2)])
    saveas(gcf,[fpObj.idvData(numMouse).Description ' Last Lick' '.jpg'])
    
    
    %% Plotting mean last lick exam Range NORMALIZED
    figure('Units','inch','Position',[left bottom width height]);
    
    mseb(timeV,fpObj.idvData(numMouse).meanNormLastBout,fpObj.idvData(numMouse).steNormLastBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
     
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('n\DeltaF/F');
    title([fpObj.idvData(numMouse).Description ' (Norm) Last Lick'],'FontSize',10)
    
    plot([0 0],ylim,'Color',[1 0 0]);
    xlim([examRange(1) examRange(2)])
    saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm Last Lick' '.jpg'])
    
    left = 0;
    bottom = bottom - height-.5;
end