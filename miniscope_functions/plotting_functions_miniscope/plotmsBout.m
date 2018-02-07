function plotmsBout(msObj)
%% idealistically, this function will SUBPLOT all necessary figures.
%   Current plan:
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           full bout
%           firstlickheatmap   firslickgraph
%           lastlickheatmap    lastlickgraph
%           bargraph            maxOrMeangraph
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initializing data
C_raw = msObj.msData.neuron.C_raw;
timeStamp = msObj.msData.timeStamp;
numTotalNeuron = msObj.msData.numTotalNeuron;
numTotalBout = msObj.boutData.numTotalBout;
numLicking = msObj.boutData.numLicking;
videoLickingEveryIdx = msObj.boutData.videoLickingEveryIdx;
videoLickingIdx = msObj.boutData.videoLickingIdx;
boutWindow =msObj.boutData.bout_criteria.boutWindow;
numWindow = msObj.boutData.bout_criteria.numWindow;

f1 = figure('Units','inch','Position',[.5 .5 10 10],'Visible','on');

for neuronNum = 1: numTotalNeuron
    
    % left = left + width+2+.2;
    % figure
    %     timeStamp = linspace(0,last_timeV,size(data_raw,2));
    subplot(5,4,[1:8])
    plot(timeStamp,C_raw(neuronNum,:));
    hold on
    xlim([timeStamp(1) timeStamp(end)]);
    yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    
    %Shading bout as light red
    for i = 1: numTotalBout
        r = patch([timeStamp(videoLickingIdx(i,1)) timeStamp(videoLickingIdx(i,2)) timeStamp(videoLickingIdx(i,2)) timeStamp(videoLickingIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    for i = 1:size(videoLickingEveryIdx,1)
        line([timeStamp(videoLickingEveryIdx(i)) timeStamp(videoLickingEveryIdx(i))], [yRange(2)*9/10 yRange(2)],'Color','r')
        %     set(r1, 'FaceAlpha', 0.5,'LineStyle','none');
        %     uistack(r1,'up')
    end
    
    % setting font size, title
    set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    set(gca,'TickDir','out');
    %     xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title({['714 MED feeding Bout NeuronNum : ' num2str(neuronNum)]; ...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numTotalBout)];...
        ['Interval = ' num2str(boutWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',8)
    
    %% first lick
    % Plotting mean first lick exam Range = -15 15
    %examRange = fpObj.examRange;
    examRange = [-15 15];
    examRangeIdx = examRange * 5;
    firstBoutRangeIdx =[videoLickingIdx(:,1) videoLickingIdx(:,1)] +repmat(examRangeIdx,[numTotalBout 1]);
    dFF = C_raw(neuronNum,:);
    numOfFrames = size(C_raw,2);
    firstBoutDffArray = [];
    for boutNum = 1:numTotalBout
        if firstBoutRangeIdx(boutNum,2) > numOfFrames || firstBoutRangeIdx(boutNum,1) >numOfFrames
        else
            firstBoutDffArray(boutNum,:) = dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2));
            %                 firstBoutDffArray(boutNum,:) = [firstBoutDffArray;dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2))];
        end
    end
    firstBoutTimeV = linspace(examRange(1),examRange(2),size(firstBoutDffArray,2));
    meanFirstBout = mean(firstBoutDffArray,1);
    steFirstBout = std(firstBoutDffArray,0,1)/sqrt(size(firstBoutDffArray,1));
    %     figure('Units','inch','Position',[left bottom width height]);
    %     left = left + width+.2;
    subplot(5,4,[9:10])
    
    mseb(firstBoutTimeV,meanFirstBout,steFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);
    
%     xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title('First Lick','FontSize',8)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
        %% firstlick heatmap
    subplot(5,4,[11:12])
    imagesc(firstBoutTimeV,1:1:numTotalBout,firstBoutDffArray);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside')
    hL = ylabel(c2,'\DeltaF');
    
%     xlabel('Time (s)');
    ylabel('Bout Num');
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            10,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])
    %% last lick
    LastBoutRangeIdx =[videoLickingIdx(:,2) videoLickingIdx(:,2)] +repmat(examRangeIdx,[numTotalBout 1]);
    lastBoutDffArray = [];
    for boutNum = 1:numTotalBout
        if LastBoutRangeIdx(boutNum,2) > numOfFrames || LastBoutRangeIdx(boutNum,1) >numOfFrames
        else
            lastBoutDffArray(boutNum,:) = dFF(LastBoutRangeIdx(boutNum,1):LastBoutRangeIdx(boutNum,2));
        end
    end
    lastBoutTimeV = linspace(examRange(1),examRange(2),size(lastBoutDffArray,2));
    meanLastBout = mean(lastBoutDffArray,1);
    steLastBout = std(lastBoutDffArray,0,1)/sqrt(size(lastBoutDffArray,1));
    
    subplot(5,4,[13:14])
    mseb(lastBoutTimeV,meanLastBout,steLastBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);
    
    xlabel('Time (s)')
    
    ylabel('\DeltaF');
    title('Last Lick','FontSize',8)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    

    
    %% lastlick heatmap
    subplot(5,4,[15:16])
    
    imagesc(firstBoutTimeV,1:1:numTotalBout,lastBoutDffArray);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside')
    hL = ylabel(c2,'\DeltaF');
    
    xlabel('Time (s)');
    ylabel('Bout Num');
    
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            10,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])
    %% bar plot
    
    dFF = dFF';
    meanBoutDff = [];
    hozconcatDff = [];
    hozconcat_nonDff = [];
    
    for boutNum = 1:numTotalBout
        meanBoutDff(boutNum,1) = mean(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        maxBoutDff(boutNum,1) = max(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        
        steBoutDff(boutNum,1) = std(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)),0,1)/length(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        hozconcatDff = [hozconcatDff dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2))'];
        hozconcat_nonDff = (sum(dFF) - sum(hozconcatDff)) / (size(dFF,1) - size(hozconcatDff,2));
    end
    
    
    
    meanDff = mean(hozconcatDff);
    meanNonDff = mean(hozconcat_nonDff);
    %store meanDff and meanNonDff
    %
    %     meanDffStack = [meanDffStack; meanDff];
    %     meanNonDffStack = [meanNonDffStack;meanNonDff];
    %
    subplot(5,4,[17:18])
    
    boutBar = bar(1,meanDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    hold on
    nonBoutBar = bar(2,meanNonDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
    
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Bout', 'NonBout'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF');
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out');
    
    %% regression(mean)
     %% Linear Regression (MEAN)
    x = 1:numTotalBout;
    y = meanBoutDff';
%     y = maxBoutDff';
    % get regression coefficient
    p = polyfit(x,y,1);
    yfit = polyval(p,x);
    yresid = y - yfit;
    
    SSresid = sum(yresid.^2);
    SStotal = (length(y)-1) * var(y);
    rsq = 1 - SSresid/SStotal;
    r = round(corrcoef(x,y),2);%pearson cor
    
    %standard error
    
    
    %plot
    subplot(5,4,[19:20])
    plot(x,y,'.','MarkerSize',15,'Color','k')
    hold on
    
    plot(x,yfit,'lineWidth',2);
    %graph spec
    xlim([.5 numTotalBout+.5])
    xlabel('Bout Number');
    ylabel('\DeltaF');
    
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial','box','off')
    set(gca,'TickDir','out');
%     dim = [.7 .5 .3 .4];
    str = ['                                               pearson cor = ' num2str(r(1,2))];
    title(str,'FontSize',8)
    saveas(gcf,['neuronNum ' num2str(neuronNum) '.jpg'])
    clf
end
