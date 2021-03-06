function plotmsShock(msObj,saveFigures)
%% initialization
neuron = msObj.msData.neuron;
timeStamp = msObj.msData.timeStamp;
C_raw = neuron.C_raw;
numOfFrames = msObj.msData.numOfFrames;
numTotalNeuron = msObj.msData.numTotalNeuron;
timeIdx = msObj.timeIdx;
videoShockIdx = msObj.videoShockIdx;
numTotalShock = msObj.numTotalShock;
if nargin<2
    saveFigures = 'n';
    disp(['Not saving figures; display mode is on']);
else
    saveFigures = saveFigures;
end

mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
normalized_C = (C_raw - mean_Array)./std_Array;
%% Figure
f1 = figure('Units','inch','Position',[1 1 14 8],'Visible','on');
% set(gcf, 'Renderer', 'painters');

for neuronNum = 1: numTotalNeuron
    %% Full plot
    subplot(2,3,1:3)
    plot(timeStamp,normalized_C(neuronNum,:));
    hold on
    xlim([timeStamp(1) timeStamp(end)]);
    yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    
    %Shading bout as light red
    for i = 1: numTotalShock
        r = patch([timeStamp(videoShockIdx(i,1)) timeStamp(videoShockIdx(i,2)) timeStamp(videoShockIdx(i,2)) timeStamp(videoShockIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    
    % setting font size, title
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    set(gca,'TickDir','out'); % The only other option is 'in'

    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF (z score)');

    examRange = [-5 5];
    examRangeIdx = 5 *examRange;
    idx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);
    %first neuron's data
    neuronData_raw = normalized_C(neuronNum,:);
    
    for i = 1:numTotalShock%heating num
        if idx(i,2) < numOfFrames
            df_neuron_raw(i,:) = neuronData_raw(idx(i,1):idx(i,2));
        end
    end
    
    timeV = linspace(examRange(1),examRange(2),size(df_neuron_raw,2));
    %for extracting timeStamp, we need to load timestamp file.

     %% heatmap
    subplot(2,3,6)
    % fig2 = figure;
    % title(titleString)
    imagesc(timeV,1:1:numTotalShock,df_neuron_raw);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    plot([1,1],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside');
    hL = ylabel(c2,'\DeltaF (z score)');
    %     set(c2,'YTick',[-3 3]);
    % c2.Label.String = 'n\DeltaF';
    % set(hL,'Rotation',-90);
    
    % caxis([-3 3])
    % h.YTick = 1:numMouse;
    xlabel('Time (s)');
    ylabel('Shock Num');
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            11,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])
%% linegraph
    mean_df = mean(df_neuron_raw);
    std_df = std(df_neuron_raw,0,1);
    ste_df = std_df./sqrt(numTotalShock);

    subplot(2,3,5)
    mseb(timeV,mean_df,ste_df);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF (z score)');
    yRange = ylim;
    
    r = patch([0 1 1 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    set(gca,'TickDir','out'); % The only other option is 'in'
    %% bar graph
    subplot(2,3,4)

    examRangeIdx = [-10 10];
    firstShockRangeIdx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);

    dFF = normalized_C(neuronNum,:);
    dff_Array = [];
    for shockNum = 1:numTotalShock
        if firstShockRangeIdx(shockNum,2) > numOfFrames || firstShockRangeIdx(shockNum,1) >numOfFrames
        else
            dff_Array(shockNum,:) = dFF(firstShockRangeIdx(shockNum,1):firstShockRangeIdx(shockNum,2));
        end
    end
    
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baseline = dff_Array(:,1:abs(examRangeIdx(1)));
    meanBaseline = mean(baseline,2);
    steBaseline = std(meanBaseline,0,1)./sqrt(size(meanBaseline,1));

    response =  dff_Array(:,size(baseline,2)+1:end);
    meanResponse = mean(response,2);
    steResponse = std(meanResponse,0,1)./sqrt(size(meanResponse,1));
    
    [~,p] = ttest(meanResponse,meanBaseline);
    
    disp(p)
    pValue(neuronNum) = p;
    
    responseBar = bar(2,mean(meanResponse),'EdgeColor',[0 0 0],'FaceColor',[1 .2 .2]);
    hold on
    baselineBar = bar(1,mean(meanBaseline),'EdgeColor',[0 0 0],'FaceColor',[.3 .3 .3]);
    plot(2,meanResponse,'.','MarkerSize',10,'Color',[.5 .5 .5])
    plot(1,meanBaseline,'.','MarkerSize',10,'Color',[.5 .5 .5])
    errorbar(2,mean(meanResponse),steResponse ,'Color','k','LineWidth',2)
    errorbar(1,mean(meanBaseline),steBaseline,'Color','k','LineWidth',2)
    plot([1 2],[ meanBaseline meanResponse],'MarkerSize',10,'Color',[.5 .5 .5])

    sigstar({[1,2]},pValue(neuronNum))
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Baseline(-2s)', 'Shock(+2s)'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF (z score)');
    
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out');
    title(['P-Value = ' num2str(pValue(neuronNum))],'FontSize',8)
    
    
    %%
    if saveFigures == 'y' || saveFigures == 'Y'
        export_fig(gcf,['neuronNum ' num2str(neuronNum) '.jpg'], '-depsc', '-painters')   
    else
                pause(.2)
    end
    clf
end
%%
cellClassification = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum = 0;
examRange = [-2 2];
examRangeIdx = 5 *examRange;
samplingRate = 5;

firstShockRangeIdx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);
%%
for neuronNum =1:numTotalNeuron
    %first neuron's data    
%     dFF = df_neuron;
    dFF = normalized_C(neuronNum,:);
    dff_Array = [];
    for shockNum = 1:numTotalShock
        if firstShockRangeIdx(shockNum,2) > numOfFrames || firstShockRangeIdx(shockNum,1) >numOfFrames
        else
            dff_Array(shockNum,:) = dFF(firstShockRangeIdx(shockNum,1):firstShockRangeIdx(shockNum,2));
        end
    end
    
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baseline = dff_Array(:,1:abs(examRangeIdx(1)));
    meanBaseline = mean(baseline,2);
    
    response =  dff_Array(:,size(baseline,2)+1:end);
    meanResponse = mean(response,2);

    diff_data = meanResponse-meanBaseline ;
    mu = mean(meanBaseline);
    %function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
    [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1([meanResponse meanBaseline] ,5000,1,0.05,mu,0);
    disp(pval)
    %     pval(neuronNum) = permtest(meanShock,meanBaseline,5000);
    pval = pval(1);
    if pval<= 0.05 %excited
        
        activatedCellNum = activatedCellNum + 1;
        cellClassification(neuronNum,1) = 1;
        cellClassification(neuronNum,2) = pval;
        cellClassification(neuronNum,3) = mean(diff_data);
        
    elseif pval >= 0.95 %inhibited
        inhibitiedCellNum = inhibitiedCellNum +1;
        cellClassification(neuronNum,1) = -1;
        cellClassification(neuronNum,2) = pval;
        cellClassification(neuronNum,3) = mean(diff_data);
        
    else
        nonResponsiveCellNum = nonResponsiveCellNum +1;
        cellClassification(neuronNum,1) = 0;
        cellClassification(neuronNum,2) = pval;
        cellClassification(neuronNum,3) = mean(diff_data);
        
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
legend({'Shock-activated';'Shock-inhibited';'non-responsive'},'Location','southeastoutside','Orientation','vertical')
% if saveFigures == 'y' || saveFigures == 'Y'  
    export_fig(gcf,'permTest Pie Plot.jpg', '-depsc', '-painters');
% end
%% classified cell heatmap
examRange = [-5 5];
neuron = msObj.msData.neuron;
data_raw = neuron.C_raw;
numOfFrames = msObj.msData.numOfFrames;
numTotalNeuron = msObj.msData.numTotalNeuron;
checkBoutData = isfield(msObj,'boutData');
if checkBoutData ==1
    videoEventIdx=msObj.boutData.videoLickingIdx;
    numEvent=msObj.boutData.numTotalBout;
else
    videoEventIdx = msObj.videoShockIdx;
    numEvent = msObj.numTotalShock;
end
examRangeIdx = examRange*5;
totalExamRangeIdx = examRangeIdx(2) - examRangeIdx(1) +1;
timeV = linspace(examRange(1),examRange(2),totalExamRangeIdx);
examRangeSize = size(timeV,2);

data_raw_max = max(data_raw,[],2);
data_raw_min = min(data_raw,[],2);

max_data_raw_array = repmat(data_raw_max,[1,numOfFrames]);
min_data_raw_array = repmat(data_raw_min,[1,numOfFrames]);

data_norm =((data_raw - min_data_raw_array)./(max_data_raw_array-min_data_raw_array)-.5)*2;

for neuronNum = 1: numTotalNeuron
    idx = [videoEventIdx(:,1) videoEventIdx(:,1)] + repmat(examRangeIdx,[numEvent 1]);
    %first neuron's data
    
    for i = 1:numEvent%heating num
        if idx(i,2) < numOfFrames
            df_neuron(i,:) = normalized_C(neuronNum,idx(i,1):idx(i,2));
        end
    end
    mean_norm_array(neuronNum,:) = mean(df_neuron);
end

%For each neuron responsive to social contact, neuronal activities were averaged crossing trials and then normalized to the baseline 
%(averaged fluorescent intensity in 5 s before the initiation of social interaction). K-means clustering (6 clusters) was performed on this type of responses.


baselineMean = mean(mean_norm_array(:,1:abs(examRangeIdx(1))),2);
mean_norm_array = mean_norm_array - repmat(baselineMean,[1,examRangeSize]);
%% sorting Array
% tempArray = [];
% [B,I] = sort(cellClassification(find(cellClassification(:,1) == 1),2));
% excitedArray = mean_norm_array(I,:);
% tempArray  = [tempArray; excitedArray];
% 
% [B,I] = sort(cellClassification(find(cellClassification(:,1) == 0),2));
% nonresponsiveArray = mean_norm_array(I,:);
% tempArray  = [tempArray; nonresponsiveArray];
% 
% [B,I] = sort(cellClassification(find(cellClassification(:,1) == -1),2));
% inhibitedArray = mean_norm_array(I,:);
% tempArray  = [tempArray; inhibitedArray];
% 
% imagesc(tempArray)
[B,I]=sort(cellClassification(:,2));
mean_norm_array_sorted = mean_norm_array(I,:);
cellClassification_sorted = cellClassification(I,:);
cumsumData = cumsum([activatedCellNum nonResponsiveCellNum inhibitiedCellNum]');


%plotting
f1 = figure('Units','inch','Position',[1 1 4 8],'Visible','on');

imagesc(timeV, 1:size(cellClassification,1), mean_norm_array_sorted)
hold on
plot([0,0],ylim, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 2);
if checkBoutData == 0
    plot([1,1],ylim, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 2);
end
h = gca;
cm = colormap(gca,othercolor('BuDRd_18'));
c2 = colorbar(...
    'Location',         'eastoutside');
hL = ylabel(c2,'\DeltaF (z score)','FontSize',11);

%     set(c2,'YTick',[-3 3]);
% c2.Label.String = 'n\DeltaF';
% set(hL,'Rotation',-90);

caxis([-5 5])
% h.YTick = 1:numMouse;
xlabel('Time (s)');
ylabel('Neuron Num');
set(gcf,'Color',[1 1 1])
set(gca,...
    'linewidth',           2.0,...
    'FontSize',            11,...
    'FontName',          'Arial',...
    'TickDir',            'out',...
    'box',               'off')
xRange = xlim;
hold on
line(xRange,[flipud(cumsumData)+.5 flipud(cumsumData)+.5],'LineWidth',1.2,'Color',[0 0 0])

% if saveFigures == 'y' || saveFigures == 'Y'  
    export_fig(gcf,'permTest sorted heatmap.jpg', '-depsc', '-painters');
% end

%% line graph
f1 = figure('Units','inch','Position',[1 1 5 3],'Visible','on');
% plot(timeV,organized_meanArray);
organized_meanArray = [];
organized_steArray=[];
legendString=[];
idxData = [ones(size(cumsumData,1),1) cumsumData];
idxData(2,1) = idxData(1,2)+1;
idxData(3,1) = idxData(2,2)+1;
lineProps.col = {[1 0 0];[.5 .5 .5];[0 0 1]}
for k= 1:3
    organized_meanArray = [organized_meanArray; mean(mean_norm_array_sorted(idxData(k,1):idxData(k,2),:))];
    temp_std= std((mean_norm_array_sorted(idxData(k,1):idxData(k,2),:)),0,1);
    organized_steArray(k,:) = temp_std./sqrt(data(k));
end

mseb(timeV,organized_meanArray,organized_steArray,lineProps);


set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
set(gca, 'box', 'off')
set(gcf,'Color',[1 1 1])
ylim([-2.5 2.5]);
xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF (z score)')
set(gca,'TickDir','out'); % The only other option is 'in'
yRange = ylim;
legend('Shock-activated','Shock-inhibited','non-responsive','Location','northeastoutside')
legend('boxoff')
if checkBoutData == 0
    r = patch([0 1 1 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
else
    hold on
    plot([0,0],ylim, 'Color','k', 'LineStyle', '--', 'LineWidth', 2);
end

% if saveFigures == 'y' || saveFigures == 'Y'  
    export_fig(gcf,'permTest sorted lineGraph.jpg', '-depsc', '-painters');
% end

%% normalize before....


for neuronNum = 1: numTotalNeuron
    idx = [videoEventIdx(:,1) videoEventIdx(:,1)] + repmat(examRangeIdx,[numEvent 1]);
    %first neuron's data
    
    for i = 1:numEvent%heating num
        if idx(i,2) < numOfFrames
            df_neuron(i,:) = data_norm(neuronNum,idx(i,1):idx(i,2));
        end
    end
    mean_norm_array(neuronNum,:) = mean(df_neuron);
end

%For each neuron responsive to social contact, neuronal activities were averaged crossing trials and then normalized to the baseline 
%(averaged fluorescent intensity in 5 s before the initiation of social interaction). K-means clustering (6 clusters) was performed on this type of responses.


baselineMean = mean(mean_norm_array(:,1:abs(examRangeIdx(1))),2);
mean_norm_array = mean_norm_array - repmat(baselineMean,[1,examRangeSize]);
temparray=mean_norm_array;

%
for neuronNum = 1: numTotalNeuron
        examRangeIdx = [-10 10];
    firstShockRangeIdx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);

    dFF = normalized_C(neuronNum,:);
    dff_Array = [];
    for shockNum = 1:numTotalShock
        if firstShockRangeIdx(shockNum,2) > numOfFrames || firstShockRangeIdx(shockNum,1) >numOfFrames
        else
            dff_Array(shockNum,:) = dFF(firstShockRangeIdx(shockNum,1):firstShockRangeIdx(shockNum,2));
        end
    end
    
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baseline = dff_Array(:,1:abs(examRangeIdx(1)));
    meanBaseline = mean(baseline,2);
    steBaseline = std(meanBaseline,0,1)./sqrt(size(meanBaseline,1));

    response =  dff_Array(:,size(baseline,2)+1:end);
    meanResponse = mean(response,2);
    steResponse = std(meanResponse,0,1)./sqrt(size(meanResponse,1));
    
    [~,p] = ttest(meanResponse,meanBaseline);
    
    disp(p)
    pValue(neuronNum) = p;
    
end
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
legend({'Shock-responsive';'Shock-non-responsive'},'Location','southeastoutside','Orientation','vertical')
title('T-Test')

if saveFigures == 'y' || saveFigures == 'Y'
    export_fig(gcf,'T-Test Pie Plot.jpg', '-depsc', '-painters');
%     print(gcf,'T-Test Pie Plot.jpg', '-depsc', '-painters');

else
end
%close figure when it ends.
% if neuronNum == numTotalNeuron
%     close(f1)
% end