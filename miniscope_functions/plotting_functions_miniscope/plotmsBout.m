function plotmsBout(msObj,saveFigures)
%% ideally, this function will SUBPLOT all necessary figures.
%   Current plan:
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                full bout%                    firstlickheatmap   firslickgraph
%    bargraph   maxOrMeangraph  lastlickheatmap    lastlickgraph
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<2
    saveFigures = 'n';
    disp(['Not saving figures; display mode is on']);
else
    saveFigures = saveFigures;
end

%initializing data
C_raw = msObj.msData.neuron.C_raw;
timeStamp = msObj.msData.timeStamp;
numOfFrames = msObj.msData.numOfFrames;
numTotalNeuron = msObj.msData.numTotalNeuron;
numTotalBout = msObj.boutData.numTotalBout;
numLicking = msObj.boutData.numLicking;
videoLickingEveryIdx = msObj.boutData.videoLickingEveryIdx;
videoLickingIdx = msObj.boutData.videoLickingIdx;
boutWindow =msObj.boutData.bout_criteria.boutWindow;
numWindow = msObj.boutData.bout_criteria.numWindow;

%% z score normalization
mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
normalized_C = (C_raw - mean_Array)./std_Array;
%%

f1 = figure('Units','inch','Position',[.5 .5 19 8],'Visible','on');

for neuronNum = 1: numTotalNeuron
    
    % left = left + width+2+.2;
    % figure
    %     timeStamp = linspace(0,last_timeV,size(data_raw,2));
    subplot(2,4,[1:2])
    plot(timeStamp,normalized_C(neuronNum,:));
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
    ylabel('\DeltaF (z score)');
    title({['933 MED feeding Bout NeuronNum : ' num2str(neuronNum)]; ...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numTotalBout)];...
        ['Interval = ' num2str(boutWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',8)
    
    %% first lick
    % Plotting mean first lick exam Range = -15 15
    %examRange = fpObj.examRange;
    examRange = [-15 15];
    examRangeIdx = examRange * 5;
    firstBoutRangeIdx =[videoLickingIdx(:,1) videoLickingIdx(:,1)] +repmat(examRangeIdx,[numTotalBout 1]);
    dFF = normalized_C(neuronNum,:);
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
    subplot(2,4,3)
    
    mseb(firstBoutTimeV,meanFirstBout,steFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);
    
    %     xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF (z score)');
    title('First Lick','FontSize',8)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    %% firstlick heatmap
    subplot(2,4,4)
    imagesc(firstBoutTimeV,1:1:numTotalBout,firstBoutDffArray);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside')
    hL = ylabel(c2,'\DeltaF (z score)');
    
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
    
    subplot(2,4,7)
    mseb(lastBoutTimeV,meanLastBout,steLastBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);
    
    xlabel('Time (s)')
    
    ylabel('\DeltaF (z score)');
    title('Last Lick','FontSize',8)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    
    
    
    %% lastlick heatmap
    subplot(2,4,8)
    
    imagesc(firstBoutTimeV,1:1:numTotalBout,lastBoutDffArray);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside');
    hL = ylabel(c2,'\DeltaF (z score)');
    
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
    meanNonBoutDff=[];
    for boutNum = 1:numTotalBout
        %         meanBoutDff(boutNum,1) = mean(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        %         if videoLickingIdx(boutNum,1)+25 <length(dFF) && dFF(videoLickingIdx(boutNum,1)-25) >1
        meanBoutDff(boutNum,1) = mean(dFF(...
            videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,1)+10 ...
            ));
        %         maxBoutDff(boutNum,1) = max(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        meanNonBoutDff(boutNum,1) = mean(dFF(...
            videoLickingIdx(boutNum,1)-10:videoLickingIdx(boutNum,1)-1 ...
            ));
        %         end
    end
    
    
    
    meanDff = mean(meanBoutDff);
    steDff = std(meanBoutDff,0,1)./sqrt(size(meanBoutDff,1));
    meanNonDff = mean(meanNonBoutDff);
    steNonDff = std(meanNonBoutDff,0,1)./sqrt(size(meanNonBoutDff,1));
    %wilcoxon
    p(neuronNum) = ranksum(meanBoutDff,meanNonBoutDff);
    %t-test
    [~,p(neuronNum)] = ttest(meanBoutDff,meanNonBoutDff);
    
    %store meanDff and meanNonDff
    %
    %     meanDffStack = [meanDffStack; meanDff];
    %     meanNonDffStack = [meanNonDffStack;meanNonDff];
    %
    subplot(2,4,5)
    
    boutBar = bar(1,meanDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    hold on
    nonBoutBar = bar(2,meanNonDff,'EdgeColor',[0 0 0],'FaceColor',[.3 .3 .3]);
    plot(1,meanBoutDff,'.','MarkerSize',10,'Color',[.5 .5 .5])
    plot(2,meanNonBoutDff,'.','MarkerSize',10,'Color',[.5 .5 .5])
    errorbar(1,meanDff,steDff ,'Color','k','LineWidth',1.5)
    errorbar(2,meanNonDff,steNonDff,'Color','k','LineWidth',1.5)
    sigstar({[1,2]},p(neuronNum))
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Bout(+2s)', 'NonBout(-2s)'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF (z score)');
    
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out');
    title(['P-Value = ' num2str(round(p(neuronNum),6))],'FontSize',8)
    
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
    subplot(2,4,6)
    plot(x,y,'.','MarkerSize',15,'Color','k')
    hold on
    
    plot(x,yfit,'lineWidth',2);
    %graph spec
    xlim([.5 numTotalBout+.5])
    xlabel('Bout Number');
    ylabel('mean \DeltaF (z score)');
    
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial','box','off')
    set(gca,'TickDir','out');
    %     dim = [.7 .5 .3 .4];
    str = ['Pearson cor = ' num2str(r(1,2))];
    
    title(str,'FontSize',8)
    %% save this graph
    if saveFigures == 'y' || saveFigures == 'Y'
        export_fig(gcf,['neuronNum ' num2str(neuronNum) '.jpg'])
        %         pause(0.5)
    else
        %         pause
    end
    clf
end
%% pieplot via t-test
for neuronNum = 1: numTotalNeuron
    dFF = normalized_C(neuronNum,:);
    dFF = dFF';
    meanBoutDff = [];
    meanNonBoutDff=[];
    for boutNum = 1:numTotalBout
        %         meanBoutDff(boutNum,1) = mean(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        %         if videoLickingIdx(boutNum,1)+25 <length(dFF) && dFF(videoLickingIdx(boutNum,1)-25) >1
        meanBoutDff(boutNum,1) = mean(dFF(...
            videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,1)+10 ...
            ));
        %         maxBoutDff(boutNum,1) = max(dFF(videoLickingIdx(boutNum,1):videoLickingIdx(boutNum,2)));
        meanNonBoutDff(boutNum,1) = mean(dFF(...
            videoLickingIdx(boutNum,1)-10:videoLickingIdx(boutNum,1)-1 ...
            ));
        %         end
    end
    
    
    
    meanDff = mean(meanBoutDff);
    steDff = std(meanBoutDff,0,1)./sqrt(size(meanBoutDff,1));
    meanNonDff = mean(meanNonBoutDff);
    steNonDff = std(meanNonBoutDff,0,1)./sqrt(size(meanNonBoutDff,1));
    %wilcoxon
    %     p(neuronNum) = ranksum(meanBoutDff,meanNonBoutDff);
    %t-test
    [~,p] = ttest(meanBoutDff,meanNonBoutDff);
    
    disp(p)
    pValue(neuronNum) = p;
end
%
p_significant_idx = find(pValue<0.05);
numResponsive = length(p_significant_idx);
numNonResponsive = numTotalNeuron - numResponsive;

figure
data = [numResponsive numNonResponsive];

h1 = pie(data); % 2D pie chart
h1(1).FaceColor =[255/255 255/255 255/255];
h1(2).Position = 0.5*h1(2).Position;
h1(3).FaceColor = [165/255 165/255 156/255];
h1(4).Position = 0.5*h1(4).Position;
set(gcf,'Color',[1 1 1])
legend({'Feeding-responsive';'Feeding-non-responsive'},'Location','southeastoutside','Orientation','vertical')
title('T-Test')
if saveFigures == 'y' || saveFigures == 'Y'
    
    saveas(gcf,'T-Test Pie Plot.jpg');
else
end
%close figure when it ends.
if neuronNum == numTotalNeuron
    close(f1)
end

%% permutation test
examRangeIdx = [-10 10];
firstBoutRangeIdx =[videoLickingIdx(:,1) videoLickingIdx(:,1)] +repmat(examRangeIdx,[numTotalBout 1]);
cellClassification = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum=0;
for z = 1: numTotalNeuron
    dFF = normalized_C(z,:);
    numOfFrames = size(normalized_C,2);
    dff_Array = [];
    for boutNum = 1:numTotalBout
        if firstBoutRangeIdx(boutNum,2) > numOfFrames || firstBoutRangeIdx(boutNum,1) >numOfFrames
        else
            dff_Array(boutNum,:) = dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2));
        end
    end
    %     index_pointOneSec = round(frameRate/10);
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baseline = dff_Array(:,1:abs(examRangeIdx(1)));
    meanBaseline = mean(baseline,2);
    %     meanBaseline = max(baseline,[],2);
    
    response =  dff_Array(:,size(baseline,2)+1:end);
    meanResponse = mean(response,2);
    %     meanShock= max(shock,[],2);
    %     numBin = floor(length(firstBoutDffArray(1,baselineStartIdx:end))/index_pointOneSec);
    %     numBin = floor(length(firstBoutDffArray(1,baselineStartIdx:end))/2);
    
    %     figure
    %     histogram(meanBaseline,10)
    %     hold on
    %     histogram(meanShock,10)
    %     legend('baseline','feeding')
    diff_data = meanResponse-meanBaseline ;
    mu = mean(meanBaseline);
    %function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
    
    [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1([meanResponse meanBaseline] ,5000,1,0.05,mu,0);
    disp(pval)
    %     pval(z) = permtest(meanShock,meanBaseline,5000);
    pval = pval(1);
    if pval<= 0.05 %excited
        
        activatedCellNum = activatedCellNum + 1;
        cellClassification(z,1) = 1;
        cellClassification(z,2) = pval;
        cellClassification(z,3) = mean(diff_data);
        
    elseif pval >= 0.95 %inhibited
        inhibitiedCellNum = inhibitiedCellNum +1;
        cellClassification(z,1) = -1;
        cellClassification(z,2) = pval;
        cellClassification(z,3) = mean(diff_data);
        
    else
        nonResponsiveCellNum = nonResponsiveCellNum +1;
        cellClassification(z,1) = 0;
        cellClassification(z,2) = pval;
        cellClassification(z,3) = mean(diff_data);
        
    end
    
end


% pie plot
figure
data = [activatedCellNum inhibitiedCellNum nonResponsiveCellNum];

h1 = pie(data); % 2D pie chart
h1(1).FaceColor =[255/255 165/255 255/255];
h1(2).Position = 0.5*h1(2).Position;
h1(3).FaceColor = [165/255 165/255 255/255];
h1(4).Position = 0.5*h1(4).Position;
h1(5).FaceColor = [165/255 165/255 156/255];
h1(6).Position = 0.5*h1(6).Position;
title('Permutation Test')
set(gcf,'Color',[1 1 1])
legend({'Feeding-activated';'Feeding-inhibited';'non-responsive'},'Location','southeastoutside','Orientation','vertical')
if saveFigures == 'y' || saveFigures == 'Y'
    
    saveas(gcf,'permTest Pie Plot.jpg');
end
