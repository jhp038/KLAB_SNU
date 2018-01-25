%% plotTrace
%Created by Jonghwi Park
%7/19/2017
%Description:

%
%
function plotTrace(fpObj,saveChoice)
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
%% Plotting RAW trace
    %left, bottom, width and height of figure are in INCH
    
    figure('Units','inch','Position',[left bottom width height]);
    hold on;
    %plotting shaded error bar
    mseb(examRangeVector,fpObj(fpObjNum).meanRawArray,fpObj(fpObjNum).steRawArray);
    % Plotting individual mean data with gray color
    %{
    for mouseNum = 1:totalMouseNum
        for waveNum = 1:totalWaveNum
        hold on;
        plot(examRangeVector,fpObj(fpObjNum).idvData(mouseNum).mean{waveNum} ,'Color',[.5 .5 .5])   
        end
    end  
    %}
    % Shading passive IR as light red
    yRange = ylim;
    r = patch([0 timeRange timeRange 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [.1,.1,.1,.1],[1,.7,.7]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    uistack(r,'top')
    %setting title, label, and gcf color
    %save    xlim(examRange);
    xlabel('Time (s)');
    ylabel('\DeltaF/F (%)');
    set(gcf,'Color',[1 1 1]);
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')  
    ylim(yRange);

    title([fpObj(fpObjNum).expDescription{1,1} ' ' fpObj(fpObjNum).groupInfo{1,1} '\_Raw \DeltaF/F'],'FontSize',10);

    if saveChoice == 1
        saveas(gcf,[fpObj(fpObjNum).expDescription{1,1} ' ' fpObj(fpObjNum).groupInfo{1,1} ' '...
            'raw trace.jpg'])
    end
%% Plotting Normalized trace
    figure('Units','inch','Position',[left bottom-height/2 width height]);
    left = left + width/2;
    hold on;
    %plotting shaded error bar
    mseb(examRangeVector,fpObj(fpObjNum).meanNormArray,fpObj(fpObjNum).steNormArray);
    % Shading passive IR as light red
    yRange = ylim;
    r = patch([0 timeRange timeRange 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [.1,.1,.3,.3],[1,.7,.7]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    uistack(r,'top')
    %setting title, label, and gcf color
    xlim(examRange);
    ylim(yRange);
    title([fpObj(fpObjNum).expDescription{1,1} ' ' fpObj(fpObjNum).groupInfo{1,1} '\_Norm \DeltaF/F'],'FontSize',10);    
    xlabel('Time (s)');
    ylabel('n\DeltaF/F');
    set(gcf,'Color',[1 1 1]);
  
    % Save
    if saveChoice == 1
        saveas(gcf,[fpObj(fpObjNum).expDescription{1,1} ' ' fpObj(fpObjNum).groupInfo{1,1} ' '...
            'norm trace.jpg'])   
    end
    
end
end