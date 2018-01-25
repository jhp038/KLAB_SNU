%% plotFTTHeatmap
%Created by Jonghwi Park and Sieun Jung


%
%
function plotFTTHeatmap(fpObj)
%initialization
totalMouseNum = fpObj.totalMouseNum;
smoothedTempData = fpObj.smoothedTempData;
dFF = fpObj.FTTdFF;
timeVector = fpObj.FTTtimeVector;
groupmean = fpObj.FTTgroupmean;
groupste = fpObj.FTTgroupste;

%% Plotting
%plotting shaded error bar
left = 0;bottom = 6;width =  7.5;height = 5; 
fig = figure('Units',            'inch',                                 ...
                 'Position',        [left bottom width height]);


left_color = [0 0 1];
right_color = [1 0 0];
set(fig,...
    'defaultAxesColorOrder',   [left_color; right_color]);


yyaxis left
shadedErrorBar(timeVector,groupmean,groupste,'b');
xlabel('Time (min)')
ylabel('\DeltaF/F(%)');
ylimdFF = get(gca,'Ylim');
ylim([ylimdFF(1)-3 ylimdFF(2)])
ylimdFF = get(gca,'Ylim');


%plotting temp
yyaxis right
plot(timeVector,smoothedTempData,...
        'Color',              [1 0 0],...
        'lineWidth',        2)
    
ylimTemp = get(gca,'Ylim');
ylim([ylimTemp(1)-5 ylimTemp(2)+15])
ylimTemp = get(gca,'Ylim');
yticks([ylimTemp(1):10:ylimTemp(2)])

s = sprintf('%c', char(176));
ylabel(['Temp (' s 'C )'])



titleString = [fpObj.groupInfo{1,1} '-' fpObj.expDescription{1,1}];
title(titleString)

set(gca,...
    'linewidth',           2.0,...
    'FontSize',            20,...
    'FontName',          'Arial',...
    'box',                   'off')

set(gcf,...
    'Color',                [1 1 1])

saveas(gcf,[titleString ' ShadedErrorBar.jpg'])
% 
% % Plotting dff
left = 0;bottom = 3;width =  7.5;height = 5; 
fig2 = figure('Units',            'inch',                                 ...
                 'Position',        [left bottom width height]);
title(titleString)
% sub1
sub1 = subplot(2,2,1:2);
imagesc(timeVector,1,smoothedTempData)
colormap(othercolor('BuDRd_18'))
c1 = colorbar(...
    'Location',             'eastoutside',...
    'position',             [.9 0.8 .02 .15]);

s = sprintf('%c', char(176));
c1.Label.String = ['Temp (' s 'C )'];

set(sub1, ...
    'xticklabel',           {[]},...
    'yticklabel',           {[]},...
    'box',                    'off',...
    'Position',             [0.13 0.8 .7 .15],...
    'linewidth',           2.0,...
    'FontSize',            15,...
    'FontName',          'Arial')

set(gca,...
    'xcolor',               'w',...
    'ycolor',               'w',...
    'xtick',                  [],...
    'ytick',                  [])



% sub2
sub2 = subplot(2,2,3:4);
set(sub2,...
    'Position',         [0.13 0.3 0.7 0.4])
imagesc(timeVector,1:length(totalMouseNum),dFF);
h = gca;
cm = colormap(gca,'hot');
c2 = colorbar(...
    'Location',         'eastoutside',...
    'position',          [.9 .3 .02 .4]);
c2.Label.String = '\DeltaF/F(%)';
h.YTick = 1:totalMouseNum;
xlabel('Time (min)');
ylabel('Mouse');
set(gca,...
    'linewidth',           2.0,...
    'FontSize',            15,...
    'FontName',          'Arial')

set(gcf,'Color',[1 1 1])
set(gca, 'box', 'off')

saveas(gcf,[titleString ' Heatmap.jpg'])
% saveas(gcf,[titleString ' Heatmap.fig'])

end