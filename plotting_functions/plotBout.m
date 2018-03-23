function plotBout(fpObj,manualExamRange,saveFigures)
%initialization
%check directory and make dir if does not exists

% if exist('BoutGraph') ~= 7
%     [status, msg, msgID] = mkdir('BoutGraph');
%     if status == 1
%         cd('BoutGraph');
%     end
% else
%     cd('BoutGraph');
% end
examRange = manualExamRange;
totalMouseNum = fpObj.totalMouseNum;
timeWindow =fpObj.timeWindow;
numWindow = fpObj.numWindow;
dffMFB = [];
dffMFBn = [];
dffMLB = [];
dffMLBn = [];
for numMouse = 1:totalMouseNum
    %initialization
    dFF = fpObj.idvData(numMouse).dFF;
    timeV = fpObj.idvData(numMouse).timeVectors;
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    lickingIdx = fpObj.idvData(numMouse).lickingIdx;
    numLicking =  fpObj.idvData(numMouse).totalNumLicking;
    numBout = fpObj.idvData(numMouse).totalNumBout;
    
    %% Plotting dFF with bout
    
    
    figure('Units','inch','Position',[1 1 6 3.5],'visible','on');
    set(gcf,'renderer','Painters')
    
    
    plot(timeV,dFF,'Color','k')

    hold on
    xlim([timeV(1) timeV(end)]);
%     yRange = [-3 10];
yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    yValLicking = repmat(yRange(2),numLicking,1);
    %Shading licking as dark red
    for i = 1:numLicking
        line([timeV(lickingIdx(i)) timeV(lickingIdx(i))], [yRange(2)*9/10 yRange(2)],'Color','r')
    end
    
    %Shading bout as light red
    for i = 1:size(boutIdx,1)
        r = patch([timeV(boutIdx(i,1)) timeV(boutIdx(i,2)) timeV(boutIdx(i,2)) timeV(boutIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    % setting font size, title
    set(gcf,'renderer','Painters')
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    title({[fpObj.idvData(numMouse).Description ' Bout'];...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numBout)];...
        ['Interval = ' num2str(timeWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',10)
    %% Plotting mean first lick exam Range
    figure('Units','inch','Position',[1 1 8 8],'visible','on');
    subplot(2,2,1)
    timeV = linspace(manualExamRange(1),manualExamRange(2),size(fpObj.idvData(1).meanFirstBout,2));
    
    mseb(timeV,fpObj.idvData(numMouse).meanFirstBout,fpObj.idvData(numMouse).steFirstBout);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    
    title([fpObj.idvData(numMouse).Description ' First Lick'],'FontSize',6)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    xlim([examRange(1) examRange(2)])
    
    %% Plotting mean first lick exam Range NORMALIZED
    subplot(2,2,2)
    
    mseb(timeV,fpObj.idvData(numMouse).meanNormFirstBout,fpObj.idvData(numMouse).steNormFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('n\DeltaF/F');
    title([fpObj.idvData(numMouse).Description ' (Norm) First Lick'],'FontSize',6)
    
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    
    xlim([examRange(1) examRange(2)])
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    
    
    %% Plotting mean last lick exam Range
    
    subplot(2,2,3)
    mseb(timeV,fpObj.idvData(numMouse).meanLastBout,fpObj.idvData(numMouse).steLastBout);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    
    title([fpObj.idvData(numMouse).Description ' Last Lick'],'FontSize',6)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    xlim([examRange(1) examRange(2)])
    
    
    
    
    
    %% Plotting mean last lick exam Range NORMALIZED
    subplot(2,2,4)
    
    mseb(timeV,fpObj.idvData(numMouse).meanNormLastBout,fpObj.idvData(numMouse).steNormLastBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('n\DeltaF/F');
    title([fpObj.idvData(numMouse).Description ' (Norm) Last Lick'],'FontSize',6)
    
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    xlim([examRange(1) examRange(2)]);
    
    % getting mean first and last lick. also ste
    dffMFB = [dffMFB ;fpObj.idvData(numMouse).meanFirstBout];
    dffMFBn = [dffMFBn ;fpObj.idvData(numMouse).meanNormFirstBout];
    
    dffMLB = [dffMLB ;fpObj.idvData(numMouse).meanLastBout];
    dffMLBn = [dffMLBn ;fpObj.idvData(numMouse).meanNormLastBout];
    % save
    if saveFigures =='y' || saveFigures =='Y'
        print(gcf, '-painters', '-depsc', [fpObj.idvData(numMouse).Description ' Bout.pdf'])
        print(gcf, '-painters', '-depsc', [fpObj.idvData(numMouse).Description ' Bout.jpg'])
    end
end


%% Now, we are going to draw HEATMAP
% timeV
% dffMFBn
% dffMLBn
timeV = linspace(manualExamRange(1),manualExamRange(2),size(fpObj.idvData(1).meanFirstBout,2));

fig1 = figure('Units',            'inch',                                 ...
    'Position',        [1 1 7 5]);
sub2 = subplot(2,2,3:4);
set(sub2,...
    'Position',         [0.13 0.3 0.7 0.4])
imagesc(timeV,1:numMouse,dffMFBn);
hold on

plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
title('FirstLick Norm Heatmap')

h = gca;
cm = colormap(gca,'hot');
c2 = colorbar(...
    'Location',         'east',...
    'position',          [.9 .3 .02 .2]);
hL = ylabel(c2,'n\DeltaF/F');
% set(c2,'YTick',[-1 6]);
% c2.Label.String = 'n\DeltaF';
% set(hL,'Rotation',-90);

% caxis([-1 6])
h.YTick = 1:numMouse;
xlabel('Time (s)');
ylabel('Mouse');
set(gca,...
    'linewidth',           2.0,...
    'FontSize',            15,...
    'FontName',          'Arial',...
    'TickDir',            'out',...
    'box',               'off')
set(gcf,'Color',[1 1 1])
if saveFigures =='y' || saveFigures =='Y'
    print(gcf, '-painters', '-depsc', ['FirstLick norm Heatmap.pdf'])
    print(gcf, '-painters', '-depsc', ['FirstLick norm Heatmap.jpg'])
end
% export_fig('FirstLick norm Heatmap','-eps','-jpg')

%% SECOND
fig2 = figure('Units',            'inch',                                 ...
    'Position',        [1 1 7 5]);
sub3 = subplot(2,2,3:4);
set(sub3,...
    'Position',         [0.13 0.3 0.7 0.4])
imagesc(timeV,1:numMouse,dffMLBn);
hold on

plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
title('LastLick Norm Heatmap')

h = gca;
cm = colormap(gca,'hot');
c2 = colorbar(...
    'Location',         'east',...
    'position',          [.9 .3 .02 .2]);
hL = ylabel(c2,'n\DeltaF/F');
% set(c2,'YTick',[-3 3]);
% c2.Label.String = 'n\DeltaF';
% set(hL,'Rotation',-90);

% caxis([-1 6])
h.YTick = 1:numMouse;
xlabel('Time (s)');
ylabel('Mouse');
set(gca,...
    'linewidth',           2.0,...
    'FontSize',            15,...
    'FontName',          'Arial',...
    'TickDir',            'out',...
    'box',               'off')
set(gcf,'Color',[1 1 1])
if saveFigures =='y' || saveFigures =='Y'
    print(gcf, '-painters', '-depsc', [fpObj.idvData(numMouse).Description ' LastLick norm Heatmap.pdf'])
    print(gcf, '-painters', '-depsc', [fpObj.idvData(numMouse).Description ' LastLick norm Heatmap.jpg'])
end
%%
meanOf_dffMFB = mean(dffMFB);
meanOf_dffMFB_ste = std(dffMFB,0,1)/sqrt(size(dffMFB,1));


meanOf_dffMFBn = mean(dffMFBn);
meanOf_dffMFBn_ste = std(dffMFBn,0,1)/sqrt(size(dffMFBn,1));

%last
meanOf_dffMLB = mean(dffMLB);
meanOf_dffMLB_ste = std(dffMLB,0,1)/sqrt(size(dffMLB,1));

meanOf_dffMLBn = mean(dffMLBn);
meanOf_dffMLBn_ste = std(dffMLBn,0,1)/sqrt(size(dffMLBn,1));
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
    mseb(timeV,meanData,steData);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel(ylabelString);
    
    title(titleString,'FontSize',8)
%     ylim([-2 6])
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    set(gca,'TickDir','out'); % The only other option is 'in'
    xlim([examRange(1)-.001 examRange(2)+.001])
    if saveFigures =='y' || saveFigures =='Y'
        print(gcf, '-painters', '-depsc', [titleString '.pdf'])
        print(gcf, '-painters', '-depsc', [titleString '.jpg'])
    end
    % export_fig(titleString,'-eps','-jpg')
    
end
end

