function plotFirstLick(fpObj)
%initialization
[status, msg, msgID] = mkdir('LickGraph');
if status == 1
    cd('LickGraph');
end

left = 0;bottom = 6;width = 4;height = 3;
examRange = fpObj.examRange;
timeV = fpObj.timeV;
%iterate through all mice data
totalMouseNum = fpObj.totalMouseNum;
dffMFB = [];
dffMFBn = [];
dffMLB = [];
dffMLBn = [];

for numMouse = 1:totalMouseNum
%% Plotting mean first lick exam Range
    
    figure('Units','inch','Position',[left bottom width height]);
    left = left + width+.2;
    mseb(timeV,fpObj.idvData(numMouse).meanFirstBout,fpObj.idvData(numMouse).steFirstBout);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')   
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    
    title([fpObj.idvData(numMouse).Description ' First Lick'],'FontSize',10)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    set(gca,'TickDir','out'); % The only other option is 'in'
   
    xlim([examRange(1) examRange(2)])
    saveas(gcf,[fpObj.idvData(numMouse).Description ' First Lick' '.jpg'])
    
    
    %% Plotting mean first lick exam Range NORMALIZED
    figure('Units','inch','Position',[left bottom width height]);
    
    mseb(timeV,fpObj.idvData(numMouse).meanNormFirstBout,fpObj.idvData(numMouse).steNormFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
     
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('n\DeltaF/F');
    title([fpObj.idvData(numMouse).Description ' (Norm) First Lick'],'FontSize',10)
    
    plot([0 0],ylim,'Color',[1 0 0]);
    xlim([examRange(1) examRange(2)])
    set(gca,'TickDir','out'); % The only other option is 'in'

    saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm First Lick' '.jpg'])
    
    left = 0;
    bottom = bottom - height-.5;
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
    
%%
    
    % getting mean first and last lick. also ste
    dffMFB = [dffMFB ;fpObj.idvData(numMouse).meanFirstBout];
    dffMFBn = [dffMFBn ;fpObj.idvData(numMouse).meanNormFirstBout];
    
    dffMLB = [dffMLB ;fpObj.idvData(numMouse).meanLastBout];
    dffMLBn = [dffMLBn ;fpObj.idvData(numMouse).meanNormLastBout];
end

%% Here, the code calculates mean of mean and ste of mean
%first
meanOf_dffMFB = mean(dffMFB);
meanOf_dffMFB_ste = std(dffMFB,0,1)/sqrt(size(dffMFB,1));


meanOf_dffMFBn = mean(dffMFBn);
meanOf_dffMFBn_ste = std(dffMFBn,0,1)/sqrt(size(dffMFBn,1));

%last
meanOf_dffMLB = mean(dffMLB);
meanOf_dffMLB_ste = std(dffMLB,0,1)/sqrt(size(dffMLB,1));

meanOf_dffMLBn = mean(dffMLBn);
meanOf_dffMLBn_ste = std(dffMLBn,0,1)/sqrt(size(dffMLBn,1));

%saving firstlick data
fpObj.meanOf_dffMFB = meanOf_dffMFB;
fpObj.meanOf_dffMFB_ste= meanOf_dffMFB_ste;
fpObj.meanOf_dffMFBn = meanOf_dffMFBn;
fpObj.meanOf_dffMFBn_ste = meanOf_dffMFBn_ste;
%saving lastlick data
fpObj.meanOf_dffMLB = meanOf_dffMLB;
fpObj.meanOf_dffMLB_ste = meanOf_dffMLB_ste;
fpObj.meanOf_dffMLBn = meanOf_dffMLBn;
fpObj.meanOf_dffMLBn_ste = meanOf_dffMLBn_ste;
%%
for i = 1:4
    
    if i == 1
        meanData = meanOf_dffMFB;
        steData = meanOf_dffMFB_ste;
        titleString = 'mom dff FirstLick';
        ylabelString = '\DeltaF/F (%)';
    elseif i == 2
        meanData = meanOf_dffMFBn;
        steData = meanOf_dffMFBn_ste;
        titleString = 'mom dff FirstLick (norm)';
        ylabelString = 'n\DeltaF/F';

    elseif i == 3    
        meanData = meanOf_dffMLB;
        steData = meanOf_dffMLB_ste;
        titleString = 'mom dff LastLick';
        ylabelString = '\DeltaF/F (%)';

    else    
        meanData = meanOf_dffMLBn;
        steData = meanOf_dffMLBn_ste;
        titleString = 'mom dff LastLick (norm)';
        ylabelString = 'n\DeltaF/F';
    end
    figure('Units','inch');
    left = left + width+.2;
    mseb(timeV,meanData,steData);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel(ylabelString);

    title(titleString,'FontSize',8)

    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    xlim([examRange(1)-.001 examRange(2)+.001])
     saveas(gcf,[titleString '.jpg'])
end
