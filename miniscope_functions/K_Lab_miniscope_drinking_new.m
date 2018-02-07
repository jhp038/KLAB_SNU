%% Initialization
clear all;clc
fileNames = uipickfiles('REFilter','\.mat$|\.dat$|\.txt$');
checkRawData = 0;
frameRate = 5;
%loading files
nameString = '01202018 feeding 933'
for numFIles = 1:size(fileNames,2)
    [pathstr,name,ext] = fileparts(fileNames{1,numFIles}) ;
    switch ext
        case '.dat'
            cd(pathstr)
            fid = fopen([name ext],'r');
            datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1);
            fclose(fid);
            raw_timeV = datacell{1,3};%%
            raw_timeV(isnan(raw_timeV)) = [];
            raw_timeV = raw_timeV./1000;
        case '.txt'
            cd(pathstr)      
            if checkRawData == 0
                [RawData samplingRate] = Text2Array_miniscope(pathstr);
                checkRawData = 1;
            end
        case '.mat'
            cd(pathstr)
            load([name ext]);
            data = neuron.C;
            data_raw = neuron.C_raw;
    end
end

%% data loaded: dealing with .dat file first
% cutting first 1000 frame
time_1000th_frame = raw_timeV(1000); % this will be used continuously.
trimmed_timeV = raw_timeV(1001:end);
% trimmed_timeV = trimmed_timeV - raw_timeV(1000);
trimmed_timeV = trimmed_timeV - trimmed_timeV(1);
timeV = downsample(trimmed_timeV,4);
% timeV = trimmed_timeV(1:4:end);
% make exception to control diff length
if length(timeV) > size(data,2)
    timeV = timeV(1: size(data,2));
end


%%  now dealing with wave file
timeVectorS = RawData(:,1);
ExtEvent = RawData(:,2);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
TTLOnIdx = TTLOnIdx +1;
TTLOnTimes = timeVectorS(TTLOnIdx);         % TTLPulseTimeS
% posslbeError = TTLOnTimes
TTLOffIdx = find(TTLThreshCrossings == -1);  
TTLOffTimes = timeVectorS(TTLOffIdx);         % TTLPulseTimeS

RawData_trimmed = RawData(TTLOnIdx:TTLOffIdx,:);
RawData_trimmed(:,1) = RawData_trimmed(:,1) - RawData_trimmed(1,1);

k = dsearchn(RawData_trimmed(:,1),raw_timeV(1001));
RawData_processed = RawData_trimmed(k:end,:);
% RawData_processed(:,1) = RawData_processed(:,1) - RawData_trimmed(k-1,1);
RawData_processed(:,1) = RawData_processed(:,1) - RawData_processed(1,1);

%algining end


if timeV(end) < RawData_processed(end,1)
    endIdx = dsearchn(RawData_processed(:,1),timeV(end));
    RawData_processed = RawData_processed(1:endIdx,:);
    timeVectorS = RawData_processed(:,1);
end




%% looking for drinking idx
ExtEvent = RawData_processed(:,3:end);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below


samplingRate = round(samplingRate);
boutWindow = 10;
numWindow = 10; %number of licks



%initialization
window = round(boutWindow *samplingRate);
lickingIdx =TTLOnIdx;
numLicking = size(lickingIdx,1);
%a drinking bout is defined as any set of ten or more licks in which no interlick
% interval is greater than one second

%% first threshold -> Interlick interval greater than timeWindow sec
lickingInterval = diff(lickingIdx);
boutOffset = find(lickingInterval >= window);
if size(lickingIdx,1) - boutOffset(end) >= window
    boutOffset(end+1) = size(lickingIdx,1);
end
numPossibleBout = size(boutOffset,1);
on_off_Idx = ones(numPossibleBout,2);
on_off_Idx(2:end,1) = boutOffset(1:end-1)+1;
on_off_Idx(:,2) = boutOffset;
%adding last row EDITED 9/25
on_off_Idx(size(on_off_Idx,1)+1,:) = [on_off_Idx(end,2)+1 size(lickingIdx,1)];

%% Second Threshold -> numWindow or more licks in each interval
for i = 1:numPossibleBout
    if (on_off_Idx(i,2) - on_off_Idx(i,1)) < numWindow % changed criteria
        on_off_Idx(i,:) = 0;
    end
end
on_off_Idx = snip(on_off_Idx,'0');

% Get bout index on dFF data
numActualBout = size(on_off_Idx,1);
% getting actual bout index
boutIdx = ones(numActualBout,2);
boutIdx(:,1) = lickingIdx(on_off_Idx(:,1));
boutIdx(:,2) = lickingIdx(on_off_Idx(:,2));

timeIdx = timeVectorS(boutIdx);
%% Load neuron data and find timepoint

data = neuron.C;
data_raw = neuron.C_raw;
last_timeV = timeV(end);
totalNeuronNum = size(data,1);
videoLickingIdx = [];
videoLickingIdx(:,1) = dsearchn(timeV,timeIdx(:,1));
videoLickingIdx(:,2) = dsearchn(timeV,timeIdx(:,2));

videoLickingEveryIdx = dsearchn(timeV,timeVectorS(lickingIdx));
activatedCellNum =0;
nonResponsiveCellNum=0;
% if videoLickingIdx(end) > size(timeV,2)
%     videoLickingIdx(end) =  size(timeV,2)
% end


%% Figure
for z = 52%: totalNeuronNum
    
    % left = left + width+2+.2;
    % figure
    %     timeV = linspace(0,last_timeV,size(data_raw,2));
    f1 = figure('Units','inch','Position',[1 1 10 5],'Visible','on');

    plot(timeV,data_raw(z,:));
    hold on
    xlim([timeV(1) timeV(end)]);
    yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    
    %Shading bout as light red
    for i = 1: numActualBout
        r = patch([timeV(videoLickingIdx(i,1)) timeV(videoLickingIdx(i,2)) timeV(videoLickingIdx(i,2)) timeV(videoLickingIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    for i = 1:size(videoLickingEveryIdx,1)
        line([timeV(videoLickingEveryIdx(i)) timeV(videoLickingEveryIdx(i))], [yRange(2)*9/10 yRange(2)],'Color','r')
        %     set(r1, 'FaceAlpha', 0.5,'LineStyle','none');
        %     uistack(r1,'up')
    end
    
    % setting font size, title
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    set(gca,'TickDir','out');
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title({['714 MED feeding Bout NeuronNum : ' num2str(z)]; ...
        ['numLick = ' num2str(size(videoLickingEveryIdx,1)) '     numBout = ' num2str(numActualBout)];...
        ['Interval = ' num2str(boutWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',10)

        saveas(gcf,['714 MED feeding Bout RAW NeuronNum ' num2str(z) '.jpg'])
    %     clf
    % pause
%     close    
    %% first lick
    % Plotting mean first lick exam Range = -15 15
    
    %examRange = fpObj.examRange;
    examRange = [-15 15];
    examRangeIdx = examRange * 5;
    firstBoutRangeIdx =[videoLickingIdx(:,1) videoLickingIdx(:,1)] +repmat(examRangeIdx,[numActualBout 1]);
    dFF = data_raw(z,:);
    numOfFrames = size(data_raw,2);
    firstBoutDffArray = [];
    for boutNum = 1:numActualBout
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
    f2 = figure('Units','inch','Position',[1 1 5 4],'Visible','on');

    mseb(firstBoutTimeV,meanFirstBout,steFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);

    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title(['714 MED feeding First Lick neuronNum ' num2str(z)],'FontSize',10)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
%     saveas(gcf,['714 MED feeding firstLick NeuronNum ' num2str(z) '.jpg'])
%     close
%% plot LastLick
    %examRange = fpObj.examRange;
    LastBoutRangeIdx =[videoLickingIdx(:,2) videoLickingIdx(:,2)] +repmat(examRangeIdx,[numActualBout 1]);
    lastBoutDffArray = [];
    for boutNum = 1:numActualBout
        if LastBoutRangeIdx(boutNum,2) > numOfFrames || LastBoutRangeIdx(boutNum,1) >numOfFrames
        else
            lastBoutDffArray(boutNum,:) = dFF(LastBoutRangeIdx(boutNum,1):LastBoutRangeIdx(boutNum,2));
            %                 firstBoutDffArray(boutNum,:) = [firstBoutDffArray;dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2))];
        end
    end
    lastBoutTimeV = linspace(examRange(1),examRange(2),size(lastBoutDffArray,2));
    meanFirstBout = mean(lastBoutDffArray,1);
    steFirstBout = std(lastBoutDffArray,0,1)/sqrt(size(lastBoutDffArray,1));
    %     figure('Units','inch','Position',[left bottom width height]);
    %     left = left + width+.2;
    f2 = figure('Units','inch','Position',[1 1 5 4],'Visible','on');

    mseb(lastBoutTimeV,meanFirstBout,steFirstBout);
    hold on
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gca,'TickDir','out');
    set(gcf,'Color',[1 1 1])
    xlim(examRange);

    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title(['714 MED feeding Last Lick neuronNum ' num2str(z)],'FontSize',10)
    plot([0 0],ylim,'Color',[1 0 0]);
    plot([0 0],ylim,'Color',[1 0 0]);
%     saveas(gcf,['714 MED feeding firstLick NeuronNum ' num2str(z) '.jpg'])
%     close
%% FirstLick Heatmap
    fig2 = figure('visible','on')      ;
    % fig2 = figure;
    % title(titleString)
    sub3 = subplot(2,2,3:4);
    set(sub3,...
        'Position',         [0.13 0.3 0.7 0.4])
    imagesc(firstBoutTimeV,1:1:numActualBout,firstBoutDffArray);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside')
    hL = ylabel(c2,'\DeltaF');
    %     set(c2,'YTick',[-3 3]);
    % c2.Label.String = 'n\DeltaF';
    % set(hL,'Rotation',-90);
    
    % caxis([-3 3])
    % h.YTick = 1:numMouse;
    xlabel('Time (s)');
    ylabel('Bout Num');
    titleString =[nameString ' FirstLick neuron number ' num2str(z)];
    title(titleString);
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            11,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])

    %% LastLick Heatmap
    fig2 = figure('visible','on')      ;
    % fig2 = figure;
    % title(titleString)
    sub3 = subplot(2,2,3:4);
    set(sub3,...
        'Position',         [0.13 0.3 0.7 0.4])
    imagesc(firstBoutTimeV,1:1:numActualBout,lastBoutDffArray);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside')
    hL = ylabel(c2,'\DeltaF');
    %     set(c2,'YTick',[-3 3]);
    % c2.Label.String = 'n\DeltaF';
    % set(hL,'Rotation',-90);
    
    % caxis([-3 3])
    % h.YTick = 1:numMouse;
    xlabel('Time (s)');
    ylabel('Bout Num');
    titleString =[nameString ' LastLick neuron number ' num2str(z)];
    title(titleString);
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            11,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])
end
%% bar plots 
%lets make this and functionalize it.
videoLickingIdx
numActualBout 

dFF = dFF';
meanBoutDff = [];
hozconcatDff = [];
hozconcat_nonDff = [];

    for boutNum = 1:numActualBout
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
    figure('visible','on');
    boutBar = bar(1,meanDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    hold on
    nonBoutBar = bar(2,meanNonDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
    
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Bout', 'NonBout'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF/F (%)');
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out');
    %% Linear Regression (MEAN)
    x = 1:numActualBout;
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
    figure('visible','on');
    plot(x,y,'.','MarkerSize',20,'Color','k')
    hold on
    
    plot(x,yfit,'lineWidth',2);
    %graph spec
    xlim([.5 numActualBout+.5])
    xlabel('Bout Number');
    ylabel('\DeltaF');
    
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial','box','off')
    set(gca,'TickDir','out');
    dim = [.7 .5 .3 .4];
    str = ['pearson cor = ' num2str(r(1,2))];
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    title('MEAN')

       %% Linear Regression (MAX)
    x = 1:numActualBout;
%     y = meanBoutDff';
    y = maxBoutDff';
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
    figure('visible','on');
    plot(x,y,'.','MarkerSize',20,'Color','k')
    hold on
    
    plot(x,yfit,'lineWidth',2);
    %graph spec
    xlim([.5 numActualBout+.5])
    xlabel('Bout Number');
    ylabel('\DeltaF');
    
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial','box','off')
    set(gca,'TickDir','out');
    dim = [.7 .5 .3 .4];
    str = ['pearson cor = ' num2str(r(1,2))];
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
        title('MAX')

%% permutation test
firstBoutRangeIdx =[videoLickingIdx(:,1) videoLickingIdx(:,1)] +repmat(examRangeIdx,[numActualBout 1]);
cellClassification = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum=0;
for z = 1: totalNeuronNum
    dFF = data_raw(z,:);
    numOfFrames = size(data_raw,2);
    firstBoutDffArray = [];
    for boutNum = 1:numActualBout
        if firstBoutRangeIdx(boutNum,2) > numOfFrames || firstBoutRangeIdx(boutNum,1) >numOfFrames
        else
            firstBoutDffArray(boutNum,:) = dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2));
            %                 firstBoutDffArray(boutNum,:) = [firstBoutDffArray;dFF(firstBoutRangeIdx(boutNum,1):firstBoutRangeIdx(boutNum,2))];
        end
    end
    index_pointOneSec = round(frameRate/10);
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baselineStartIdx = abs(examRangeIdx(1))-5*frameRate+1;
    baselineEndIdx = abs(examRangeIdx(1))-1;
    baseline = firstBoutDffArray(:,baselineStartIdx:baselineEndIdx);
    meanBaseline = mean(baseline,2);
%     meanBaseline = max(baseline,[],2);
    
    shockStartIdx = abs(examRangeIdx(1));
    shockendIdx = abs(examRangeIdx(1)) + 5*frameRate;
    shock =  firstBoutDffArray(:,shockStartIdx:shockendIdx);
    meanShock = mean(shock,2);
%     meanShock= max(shock,[],2);
    %     numBin = floor(length(firstBoutDffArray(1,baselineStartIdx:end))/index_pointOneSec);
    %     numBin = floor(length(firstBoutDffArray(1,baselineStartIdx:end))/2);
    
    %     figure
    %     histogram(meanBaseline,10)
    %     hold on
    %     histogram(meanShock,10)
    %     legend('baseline','feeding')
    diff_data = meanShock-meanBaseline ;
    mu = mean(meanBaseline);
    %function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)

    [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1([meanShock meanBaseline],5000,0,0.05,mean(meanBaseline),0);
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


legend({'Feeding-activated';'Feeding-inhibited';'non-responsive'},'Location','southeastoutside','Orientation','vertical')