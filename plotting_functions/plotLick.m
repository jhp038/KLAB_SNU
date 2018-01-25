function plotLick(fpObj,manualExamRange,saveFigures)
%initialization
if exist('LickGraph') ~= 7
    [status, msg, msgID] = mkdir('LickGraph');
    if status == 1
        cd('LickGraph');
    end
else
    cd('LickGraph');
end


left = 0;bottom = 6;width = 4;height = 3;
examRange = manualExamRange;
timeV = linspace(manualExamRange(1),manualExamRange(2),size(fpObj.idvData(1).meanFirstBout,2));
%iterate through all mice data
totalMouseNum = fpObj.totalMouseNum;
dffMFB = [];
dffMFBn = [];
dffMLB = [];
dffMLBn = [];
%%
for numMouse = 1:totalMouseNum
    %% Plotting mean first lick exam Range
    
    figure('Units','inch','Position',[left bottom width height],'visible','off');
    left = left + width+.2;
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
    %     export_fig([fpObj.idvData(numMouse).Description ' First Lick'],'-eps','-jpg')
    if saveFigures =='y' || saveFigures =='Y'
        
        saveas(gcf,[fpObj.idvData(numMouse).Description ' First Lick' '.jpg'])
        saveas(gcf,[fpObj.idvData(numMouse).Description ' First Lick' '.svg'])
    end
    %% Plotting mean first lick exam Range NORMALIZED
    figure('Units','inch','Position',[left bottom width height],'visible','off');
    
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
    if saveFigures =='y' || saveFigures =='Y'
        
        saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm First Lick' '.jpg'])
        saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm First Lick' '.svg'])
    end
    %     export_fig([fpObj.idvData(numMouse).Description 'Norm First Lick'],'-eps','-jpg')
    
    
    %% Plotting mean last lick exam Range
    
    figure('Units','inch','Position',[left bottom width height],'visible','off');
    left = left + width+.2;
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
    
    
    if saveFigures =='y' || saveFigures =='Y'
        
        saveas(gcf,[fpObj.idvData(numMouse).Description ' Last Lick' '.jpg'])
        saveas(gcf,[fpObj.idvData(numMouse).Description ' Last Lick' '.svg'])
    end
    %     export_fig([fpObj.idvData(numMouse).Description ' Last Lick'],'-eps','-jpg')
    
    
    %% Plotting mean last lick exam Range NORMALIZED
    figure('Units','inch','Position',[left bottom width height],'visible','off');
    
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
    
    if saveFigures =='y' || saveFigures =='Y'
        
        saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm Last Lick' '.jpg'])
        saveas(gcf,[fpObj.idvData(numMouse).Description 'Norm Last Lick' '.svg'])
    end
    %     export_fig([fpObj.idvData(numMouse).Description ' Norm Last Lick'],'-eps','-jpg')
    
    %%
    
    % getting mean first and last lick. also ste
    dffMFB = [dffMFB ;fpObj.idvData(numMouse).meanFirstBout];
    dffMFBn = [dffMFBn ;fpObj.idvData(numMouse).meanNormFirstBout];
    
    dffMLB = [dffMLB ;fpObj.idvData(numMouse).meanLastBout];
    dffMLBn = [dffMLBn ;fpObj.idvData(numMouse).meanNormLastBout];
end
%% Now, we are going to draw HEATMAP
% timeV
% dffMFBn
% dffMLBn

fig1 = figure('Units',            'inch',                                 ...
    'Position',        [left bottom 7 5]);
% title(titleString)
sub2 = subplot(2,2,3:4);
set(sub2,...
    'Position',         [0.13 0.3 0.7 0.4])
imagesc(timeV,1:numMouse,dffMFBn);
hold on

plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);

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
    
    saveas(gcf,[fpObj.idvData(numMouse).Description 'FirstLick norm Heatmap' '.jpg'])
    saveas(gcf,[fpObj.idvData(numMouse).Description 'FirstLick norm Heatmap' '.svg'])
end
% export_fig('FirstLick norm Heatmap','-eps','-jpg')

%% SECOND
fig2 = figure('Units',            'inch',                                 ...
    'Position',        [left bottom 7 5]);
% title(titleString)
sub3 = subplot(2,2,3:4);
set(sub3,...
    'Position',         [0.13 0.3 0.7 0.4])
imagesc(timeV,1:numMouse,dffMLBn);
hold on

plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);

h = gca;
cm = colormap(gca,'hot');
c2 = colorbar(...
    'Location',         'east',...
    'position',          [.9 .3 .02 .2]);
hL = ylabel(c2,'n\DeltaF/F');
% set(c2,'YTick',[-3 3]);
% c2.Label.String = 'n\DeltaF';
% set(hL,'Rotation',-90);

% caxis([-3 3])
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
    
    saveas(gcf,[fpObj.idvData(numMouse).Description 'LastLick norm Heatmap' '.jpg'])
    saveas(gcf,[fpObj.idvData(numMouse).Description 'LastLick norm Heatmap' '.svg'])
end
% export_fig([fpObj.idvData(numMouse).Description 'LastLick norm Heatmap'],'-eps','-jpg')

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
    if saveFigures =='y' || saveFigures =='Y'
        
        saveas(gcf,[titleString '.jpg'])
        saveas(gcf,[titleString '.svg'])
    end
    % export_fig(titleString,'-eps','-jpg')
    
end

cd ..
