indexMap = cell_registered_struct.cell_to_index_map
for i = 1:size(indexMap,1)
    if indexMap(i,1) == 0 || indexMap(i,2) ==0
        indexMap(i,:) = 0
    end
end

snipped_indexMap = snip(indexMap,'0');




%% Shock
msObjShock_1 = msObjMake;

% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObjShock_1 = msTrimmingDataShock(msObjShock_1);
msObjShock_1 = msCalculateParaEvent(msObjShock_1);

%% Shock
msObjShock_2 = msObjMake;

% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObjShock_2 = msTrimmingDataShock(msObjShock_2);
msObjShock_2 = msCalculateParaEvent(msObjShock_2);

%% Feeding
%trimming timestamp and wav data(first 50sec)
msObjFeeding = msObjMake;
msObjFeeding = msTrimmingData(msObjFeeding);


%now, calculate bout
boutWindow = 3;
numWindow = 3;
msObjFeeding = msCalculateBout(msObjFeeding,boutWindow,numWindow);

% %% 120 data
% shock_714 = msObjShock.msData.neuron;
% feeding_714 = msObjFeeding.msData.neuron;
% 
% %  reshape(neuron.A(:,n), d1 , d2);
% figure
% for i = 1: size(snipped_indexMap,1)
%     subplot(1,2,1)
%     imagesc(reshape(feeding_714.A(:,snipped_indexMap(i,1)),size(feeding_714.Cn)))
%     subplot(1,2,2)
%     
%     imagesc(reshape(shock_714.A(:,snipped_indexMap(i,2)),size(shock_714.Cn)))
%     pause
%     clf
% end

%% plotting function
% we have to visualize both shock and feeding at the same time...
% shock preprocessing

%%
set(0,'units','inches')
Inch_SS = get(0,'screensize')
Inch_SS(4) = Inch_SS(4)/2
f1 = figure('Units','inch','Position',Inch_SS,'Visible','on');

for z = 1: size(snipped_indexMap,1)
    %spatial
    neuron = msObjShock_1.msData.neuron;
    timeStamp = msObjShock_1.msData.timeStamp;
    C_raw = neuron.C_raw;
    numOfFrames = msObjShock_1.msData.numOfFrames;
    numTotalNeuron = msObjShock_1.msData.numTotalNeuron;
    timeIdx = msObjShock_1.timeIdx;
    videoShockIdx = msObjShock_1.videoShockIdx;
    numTotalShock = msObjShock_1.numTotalShock;
    
    mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
    std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
    normalized_C = (C_raw - mean_Array)./std_Array;
    subplot(2,6,1)
    
    imagesc(reshape(neuron.A(:,snipped_indexMap(z,2)),size(neuron.Cn)))
    title(['Neuron Num: ' num2str(snipped_indexMap(z,2))])
    
    
    %% Full plot
    neuronNum = snipped_indexMap(z,2);
    subplot(2,6,2:3)
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
    
%     xlabel('Time (s)')%,'FontSize',18)
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
    subplot(2,6,6)
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
%     xlabel('Time (s)');
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
    
    subplot(2,6,5)
    mseb(timeV,mean_df,ste_df);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
%     xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF (z score)');
    yRange = ylim;
    
    r = patch([0 1 1 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    set(gca,'TickDir','out'); % The only other option is 'in'
    %% bar graph
    subplot(2,6,4)
    
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
    
    
    
    %% now, plotting function for bout analysis
    %initializing data
    neuron =  msObjFeeding.msData.neuron;
    C_raw = msObjFeeding.msData.neuron.C_raw;
    timeStamp = msObjFeeding.msData.timeStamp;
    numOfFrames = msObjFeeding.msData.numOfFrames;
    numTotalNeuron = msObjFeeding.msData.numTotalNeuron;
    numTotalBout = msObjFeeding.boutData.numTotalBout;
    numLicking = msObjFeeding.boutData.numLicking;
    videoLickingEveryIdx = msObjFeeding.boutData.videoLickingEveryIdx;
    videoLickingIdx = msObjFeeding.boutData.videoLickingIdx;
    boutWindow =msObjFeeding.boutData.bout_criteria.boutWindow;
    numWindow = msObjFeeding.boutData.bout_criteria.numWindow;
    
    %% z score normalization
    mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
    std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
    normalized_C = (C_raw - mean_Array)./std_Array;
    
    %spatial
    subplot(2,6,7)
    imagesc(reshape(neuron.A(:,snipped_indexMap(z,1)),size(neuron.Cn)))
    title(['Neuron Num: ' num2str(snipped_indexMap(z,1))])
    
    neuronNum = snipped_indexMap(z,1);
    
    %% full bout graph
    subplot(2,6,[8:9])
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
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF (z score)');
    title({['714 MED feeding Bout NeuronNum : ' num2str(neuronNum)]; ...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numTotalBout)];...
        ['Interval = ' num2str(boutWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',6)
    
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
    subplot(2,6,11)
    
    mseb(firstBoutTimeV,meanFirstBout,steFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF (z score)');
    title('First Lick','FontSize',8)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
    %% firstlick heatmap
    subplot(2,6,12)
    imagesc(firstBoutTimeV,1:1:numTotalBout,firstBoutDffArray);
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
    %     %% last lick
    %     LastBoutRangeIdx =[videoLickingIdx(:,2) videoLickingIdx(:,2)] +repmat(examRangeIdx,[numTotalBout 1]);
    %     lastBoutDffArray = [];
    %     for boutNum = 1:numTotalBout
    %         if LastBoutRangeIdx(boutNum,2) > numOfFrames || LastBoutRangeIdx(boutNum,1) >numOfFrames
    %         else
    %             lastBoutDffArray(boutNum,:) = dFF(LastBoutRangeIdx(boutNum,1):LastBoutRangeIdx(boutNum,2));
    %         end
    %     end
    %     lastBoutTimeV = linspace(examRange(1),examRange(2),size(lastBoutDffArray,2));
    %     meanLastBout = mean(lastBoutDffArray,1);
    %     steLastBout = std(lastBoutDffArray,0,1)/sqrt(size(lastBoutDffArray,1));
    %
    %     subplot(2,4,7)
    %     mseb(lastBoutTimeV,meanLastBout,steLastBout);
    %     hold on
    %     set(gca,'linewidth',1.6,'FontSize',10,'FontName','Arial')
    %     set(gca, 'box', 'off')
    %     set(gca,'TickDir','out');
    %     set(gcf,'Color',[1 1 1])
    %     xlim(examRange);
    %
    %     xlabel('Time (s)')
    %
    %     ylabel('\DeltaF (z score)');
    %     title('Last Lick','FontSize',8)
    %     plot([0 0],ylim,'Color',[1 0 0]);
    %     plot([0 0],ylim,'Color',[1 0 0]);
    %
    %
    %
    %     %% lastlick heatmap
    %     subplot(2,4,8)
    %
    %     imagesc(firstBoutTimeV,1:1:numTotalBout,lastBoutDffArray);
    %     hold on
    %
    %     plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    %
    %     h = gca;
    %     cm = colormap(gca,'hot');
    %     c2 = colorbar(...
    %         'Location',         'eastoutside');
    %     hL = ylabel(c2,'\DeltaF (z score)');
    %
    %     xlabel('Time (s)');
    %     ylabel('Bout Num');
    %
    %     set(gca,...
    %         'linewidth',           2.0,...
    %         'FontSize',            10,...
    %         'FontName',          'Arial',...
    %         'TickDir',            'out',...
    %         'box',               'off')
    %     set(gcf,'Color',[1 1 1])
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
    subplot(2,6,10)
    
    boutBar = bar(2,meanDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    hold on
    nonBoutBar = bar(1,meanNonDff,'EdgeColor',[0 0 0],'FaceColor',[.3 .3 .3]);
    plot(2,meanBoutDff,'.','MarkerSize',10,'Color',[.5 .5 .5])
    plot(1,meanNonBoutDff,'.','MarkerSize',10,'Color',[.5 .5 .5])
    errorbar(2,meanDff,steDff ,'Color','k','LineWidth',1.5)
    errorbar(1,meanNonDff,steNonDff,'Color','k','LineWidth',1.5)
    sigstar({[1,2]},p(neuronNum))
    %Xlabel
    set(gca,'xtick',[])
    Labels = { 'NonBout(-2s)','Bout(+2s)'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF (z score)');
    
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out');
    title(['P-Value = ' num2str(round(p(neuronNum),6))],'FontSize',8)
    
    export_fig(gcf,['714_CellReg_01202018_' num2str(z) '.jpg'])
%     pause
    %     end
    clf
end


%% Shock

cellClassification_shock = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum = 0;
samplingRate = 5;
examRange = [-2 2];
examRangeIdx = samplingRate *examRange;
numTotalShock = msObjShock_1.numTotalShock;
videoShockIdx = msObjShock_1.videoShockIdx;
firstShockRangeIdx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);
neuron = msObjShock_1.msData.neuron;
timeStamp = msObjShock_1.msData.timeStamp;
C_raw = neuron.C_raw;
numOfFrames = msObjShock_1.msData.numOfFrames;
timeIdx = msObjShock_1.timeIdx;
mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
normalized_C = (C_raw - mean_Array)./std_Array;

for z = 1: size(snipped_indexMap,1)
    neuronNum = snipped_indexMap(z,2);
    
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
        cellClassification_shock(z,1) = 1;
        cellClassification_shock(z,2) = pval;
        cellClassification_shock(z,3) = mean(diff_data);
        
    elseif pval >= 0.95 %inhibited
        inhibitiedCellNum = inhibitiedCellNum +1;
        cellClassification_shock(z,1) = -1;
        cellClassification_shock(z,2) = pval;
        cellClassification_shock(z,3) = mean(diff_data);
        
    else
        nonResponsiveCellNum = nonResponsiveCellNum +1;
        cellClassification_shock(z,1) = 0;
        cellClassification_shock(z,2) = pval;
        cellClassification_shock(z,3) = mean(diff_data);
        
    end
    
end


%% permutation test BOUT
neuron =  msObjFeeding.msData.neuron;
C_raw = msObjFeeding.msData.neuron.C_raw;
timeStamp = msObjFeeding.msData.timeStamp;
numOfFrames = msObjFeeding.msData.numOfFrames;
numTotalNeuron = msObjFeeding.msData.numTotalNeuron;
numTotalBout = msObjFeeding.boutData.numTotalBout;
numLicking = msObjFeeding.boutData.numLicking;
videoLickingEveryIdx = msObjFeeding.boutData.videoLickingEveryIdx;
videoLickingIdx = msObjFeeding.boutData.videoLickingIdx;
boutWindow =msObjFeeding.boutData.bout_criteria.boutWindow;
numWindow = msObjFeeding.boutData.bout_criteria.numWindow;

%% z score normalization
mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
normalized_C = (C_raw - mean_Array)./std_Array;
examRangeIdx = [-15 15];
firstBoutRangeIdx =[videoLickingIdx(:,1) videoLickingIdx(:,1)] +repmat(examRangeIdx,[numTotalBout 1]);
cellClassification_bout = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum=0;
for z = 1: size(snipped_indexMap,1)
    neuronNum = snipped_indexMap(z,1);    dFF = normalized_C(neuronNum,:);
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
        cellClassification_bout(z,1) = 1;
        cellClassification_bout(z,2) = pval;
        cellClassification_bout(z,3) = mean(diff_data);
        
    elseif pval >= 0.95 %inhibited
        inhibitiedCellNum = inhibitiedCellNum +1;
        cellClassification_bout(z,1) = -1;
        cellClassification_bout(z,2) = pval;
        cellClassification_bout(z,3) = mean(diff_data);
        
    else
        nonResponsiveCellNum = nonResponsiveCellNum +1;
        cellClassification_bout(z,1) = 0;
        cellClassification_bout(z,2) = pval;
        cellClassification_bout(z,3) = mean(diff_data);
        
    end
    
end

%%


  neuron_feeding =  msObjFeeding.msData.neuron;
  neuron_shock =  msObjShock_1.msData.neuron;

spatial_footprints_feeding = [];
spatial_footprints_shock = [];
edge_feeding = [];
edge_shock = [];
for z = 1: size(snipped_indexMap,1)
    %feeding
    neuronNum_feeding = snipped_indexMap(z,1);
    neuronNum_shock = snipped_indexMap(z,2);
    
    [d1 d2] = size(neuron_feeding.Cn);
        spatial_footprints_feeding(:,:,z) = reshape(neuron_feeding.A(:,neuronNum_feeding), d1 , d2);
        edge_feeding(:,:,z) = edge(spatial_footprints_feeding(:,:,z), 'canny');
    
%     spatial_footprints_feeding(:,:,z) = cell_registered_struct.spatial_footprints_corrected{1,1}(z,:,:);
%     edge_feeding(:,:,z) = edge(spatial_footprints_feeding(:,:,z), 'canny');
    
        [d1 d2] = size(neuron_shock.Cn);
            spatial_footprints_shock(:,:,z) = reshape(neuron_shock.A(:,neuronNum_shock), d1 , d2);
        edge_shock(:,:,z) = edge(spatial_footprints_shock(:,:,z), 'canny');
%     spatial_footprints_shock(:,:,z) = cell_registered_struct.spatial_footprints_corrected{2,1}(z,:,:);
%     edge_shock(:,:,z) = edge(spatial_footprints_shock(:,:,z), 'canny');
end
%% adapted from CellReg
numOverlappingCells = size(cellClassification_shock,1);

feeding_responsive = 0;
feeding_nonResponsive = 0;
shock_responsive = 0;
shock_nonResponsive = 0;
both_responsive = 0;
both_responsive_Idx=[];
shock_responsive_Idx = [];
feeding_responsive_Idx = [];
for i = 1:numOverlappingCells
    %feeding
    if cellClassification_bout(i,1) ~=0
        feeding_responsive = feeding_responsive +1;
        feeding_responsive_Idx(feeding_responsive) = snipped_indexMap(i,1);
    else
        feeding_nonResponsive = feeding_nonResponsive +1;
        feeding_nonResponsive_Idx(feeding_nonResponsive) =  snipped_indexMap(i,1);
    end
    %shock
    if cellClassification_shock(i,1) ~= 0
        shock_responsive = shock_responsive +1;
        shock_responsive_Idx(shock_responsive) = snipped_indexMap(i,2);
    else
        shock_nonResponsive = shock_nonResponsive +1;
        shock_nonResponsive_Idx(shock_nonResponsive) =  snipped_indexMap(i,2);
    end
    %both
    if  cellClassification_bout(i,1) ~=0 && cellClassification_shock(i,1) ~=0
        both_responsive = both_responsive +1;
        both_responsive_Idx(both_responsive,:) =[snipped_indexMap(i,1) snipped_indexMap(i,2)];
    end
end




spatial_footprints = cell_registered_struct.spatial_footprints_corrected;
cell_to_index_map = cell_registered_struct.cell_to_index_map;
number_of_sessions=size(spatial_footprints,1);

pixel_weight_threshold=0.5; % for better visualization of cells
all_projections_partial=cell(1,number_of_sessions);
mutual_projections_partial=cell(1,number_of_sessions);
cells_in_all_days=find(sum(cell_to_index_map'>0)==number_of_sessions);
other_cells=cell(1,number_of_sessions);
for n=1:number_of_sessions
    logical_1=sum(cell_to_index_map'>0)<number_of_sessions;
    other_cells{n}=find(cell_to_index_map(:,n)'>0 & logical_1);
end
 
disp('Calculating spatial footprints projections:')
for n=1:2%:number_of_sessions
    display_progress_bar('Terminating previous progress bars',true)
    display_progress_bar(['Calculating projections for session #' num2str(n) ' - '],false)
    this_session_spatial_footprints=spatial_footprints{n};
    num_spatial_footprints=size(this_session_spatial_footprints,1);
    normalized_spatial_footprints=zeros(size(this_session_spatial_footprints));
    for k=1:num_spatial_footprints
        display_progress_bar(100*(k)/(num_spatial_footprints),false)
        this_spatial_footprint=this_session_spatial_footprints(k,:,:);
        this_spatial_footprint(this_spatial_footprint<pixel_weight_threshold*max(max(this_spatial_footprint)))=0;
        if max(max(this_spatial_footprint))>0
            normalized_spatial_footprints(k,:,:)=this_spatial_footprint/max(max(this_spatial_footprint));
        end
    end
    display_progress_bar(' done',false);
    
    %     all_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
    %     mutual_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
    %     all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(cells_in_all_days,n),:,:),1));
    %     all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1));
    %     all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1))+squeeze(sum(normalized_spatial_footprints(cell_to_index_map(cells_in_all_days,n),:,:),1));
    %     all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1));
    %     mutual_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(cells_in_all_days,n),:,:),1));
    %     all_projections_partial{n}(all_projections_partial{n}>1)=1;
    
    %% I have to visualize excited/excited, inhibit/inhibit cells.
    if n == 1
        all_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
%         all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1)) +squeeze(sum(normalized_spatial_footprints(feeding_responsive_Idx,:,:),1)); %feeding
%         all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1))+squeeze(sum(normalized_spatial_footprints(both_responsive_Idx(:,n),:,:),1)); %both
%         all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1)) +squeeze(sum(normalized_spatial_footprints(feeding_nonResponsive_Idx,:,:),1));
        
        
        all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(feeding_responsive_Idx,:,:),1)); %feeding
        all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(both_responsive_Idx(:,n),:,:),1)); %both
%         all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(feeding_nonResponsive_Idx),:,:),1));% +squeeze(sum(normalized_spatial_footprints(feeding_nonResponsive_Idx,:,:),1));
        all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(feeding_nonResponsive_Idx,:,:),1)); %both

        all_projections_partial{n}(all_projections_partial{n}>1)=1;

    else
        all_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
        all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(shock_responsive_Idx,:,:),1)); %shock
        all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(both_responsive_Idx(:,n),:,:),1)); %bothResponsive
        all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(shock_nonResponsive_Idx,:,:),1)); %nonResponsive
        all_projections_partial{n}(all_projections_partial{n}>1)=1;

    end
end
%%
%  edge(spatial_footprints_shock(:,:,z), 'canny');
    hello=ones([162 169 3]);

figure('units','normalized','outerposition',[0.1 0.2 0.8 0.5],'Visible','on')
set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')')
for n=1:number_of_sessions
    subplot(1,number_of_sessions,n)
%     imagesc(all_projections_partial{n})
    hold on
    imagesc(hello)
    alphamask(edge(all_projections_partial{n}(:,:,1),'Roberts'),[1 0 0],1);%responsive
    alphamask(edge(all_projections_partial{n}(:,:,2),'Roberts'), [.9 .9 .5], 1);%both
    alphamask(edge(all_projections_partial{n}(:,:,3),'Roberts'), [0 1 1], 1);%non


%     imagesc(edge(all_projections_partial{n}(:,:,1),'canny'))

    set(gca,'xtick',[])
    set(gca,'ytick',[])
    colormap('gray')
    if n==1
        title(['Feeding 0120 933'],'fontsize',14,'fontweight','bold')
        
        text(0.01*size(all_projections_partial{n},1),0.02*size(all_projections_partial{n},2),'Feeding Only','fontsize',14,'color','r','fontweight','bold')
        text(0.01*size(all_projections_partial{n},1),0.10*size(all_projections_partial{n},2),'NonResponsive','fontsize',14,'color','c','fontweight','bold')
    else
        title(['Shock 0120 933'],'fontsize',14,'fontweight','bold')
        
        text(0.01*size(all_projections_partial{n},1),0.02*size(all_projections_partial{n},2),'Shock Only','fontsize',14,'color','r','fontweight','bold')
        text(0.01*size(all_projections_partial{n},1),0.10*size(all_projections_partial{n},2),'NonResponsive','fontsize',14,'color','c','fontweight','bold')
    end
    text(0.01*size(all_projections_partial{n},1),0.06*size(all_projections_partial{n},2),'Both','fontsize',14,'color',[.9 .9 .5],'fontweight','bold')
    %     text(0.01*size(all_projections_partial{n},1),0.11*size(all_projections_partial{n},2),'Responsive','fontsize',14,'color',[1 1 0],'fontweight','bold')
end


