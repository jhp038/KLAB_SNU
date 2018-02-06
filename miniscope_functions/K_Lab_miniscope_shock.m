%% Initialization
clear all;clc
fileNames = uipickfiles('REFilter','\.mat$|\.dat$|\.txt$');
checkRawData = 0;
%loading files
nameString = '01202018 shock 933'
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
                RawData = Text2Array_miniscope(pathstr);
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

timeVectorS = RawData_processed(:,1);
time_error = timeVectorS(end) - timeV(end)
timeVectorS = timeVectorS-time_error;


%%

% if timeV(end) < RawData_processed(end,1)
%     endIdx = dsearchn(RawData_processed(:,1),timeV(end));
%     RawData_processed = RawData_processed(1:endIdx,:);
%     timeVectorS = RawData_processed(:,1);
% end



%% looking for shock idx
ExtEvent = RawData_processed(:,3);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
TTLOffIdx = find(TTLThreshCrossings == -1);      % Find crossings from below

timeIdx = [timeVectorS(TTLOnIdx) timeVectorS(TTLOffIdx)];
% timeIdx = timeIdx - posslbeError;
% samplingRate = 102;

%% Load neuron data and find timepoint


last_timeV = timeV(end);
totalNeuronNum = size(data,1);
videoShockIdx = [];
videoShockIdx(:,1) = dsearchn(timeV,timeIdx(:,1));
videoShockIdx(:,2) = dsearchn(timeV,timeIdx(:,2));
totalNumShock = length(TTLOnIdx);

if videoShockIdx(end) > size(timeV,1)
    videoShockIdx(end) =  size(timeV,1);
end


%normalizating data
numOfFrames = size(data_raw,2);

max_df = max(data_raw,[],2); max_df_array = repmat(max_df,[1,numOfFrames]);
min_df= min(data_raw,[],2); min_df_array = repmat(min_df,[1,numOfFrames]);


data_normalized =(data_raw - min_df_array)./(max_df_array-min_df_array);
%% Figure
figure('Units','inch','Position',[1 1 10 5],'Visible','on');
full_timeV = timeV;
for z = 1%: totalNeuronNum
    
    % left = left + width+2+.2;
    % figure
%         timeV = linspace(0,last_timeV,size(data_raw,2));
    plot(full_timeV,data_normalized(z,:));
    hold on
    xlim([full_timeV(1) full_timeV(end)]);
    yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    
    %Shading bout as light red
    for i = 1: totalNumShock
        r = patch([full_timeV(videoShockIdx(i,1)) full_timeV(videoShockIdx(i,2)) full_timeV(videoShockIdx(i,2)) full_timeV(videoShockIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    
    % setting font size, title
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title({[nameString ' Bout NeuronNum :'  num2str(z)]; ...
        ['numShock = ' num2str(totalNumShock)]},...
        'FontSize',10)
    %     title({[['714 MED drinking Bout NeuronNum :' num2str(z)'];...
    %         ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numBout)];...
    %         ['Interval = ' num2str(timeWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks']},...
    %         'FontSize',10)
        saveas(gcf,['714 MED drinking Bout RAW NeuronNum ' num2str(z) '.jpg'])
    %     clf
    % pause
    % clf
end
%%

examRange = [-5 5];
examRangeIdx = 5 *examRange;
idx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[totalNumShock 1]);
numOfFrames = size(data_raw,2);


%%

for z = 1%:totalNeuronNum
    %first neuron's data
    neuronData = data(z,:);
    neuronData_raw = data_raw(z,:);
    neuronData_normalized = data_normalized(z,:);
    
    for i = 1:totalNumShock%heating num
        df_neuron(i,:) = neuronData(idx(i,1):idx(i,2));
        df_neuron_raw(i,:) = neuronData_raw(idx(i,1):idx(i,2));
        df_neuron_normalized(i,:) = neuronData_normalized(idx(i,1):idx(i,2));
    end
    
    timeV = linspace(examRange(1),examRange(2),size(df_neuron,2));
%for extracting timeV, we need to load timestamp file.

    
    %% SECOND
    fig2 = figure('visible','on')      ;
    % fig2 = figure;
    % title(titleString)
    sub3 = subplot(2,2,3:4);
    set(sub3,...
        'Position',         [0.13 0.3 0.7 0.4])
    imagesc(timeV,1:1:totalNumShock,df_neuron_normalized);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    plot([1,1],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
    h = gca;
    cm = colormap(gca,'hot');
    c2 = colorbar(...
        'Location',         'eastoutside')
    hL = ylabel(c2,'Normalized \DeltaF');
    %     set(c2,'YTick',[-3 3]);
    % c2.Label.String = 'n\DeltaF';
    % set(hL,'Rotation',-90);
    
    % caxis([-3 3])
    % h.YTick = 1:numMouse;
    xlabel('Time (s)');
    ylabel('Shock Num');
    titleString =[nameString ' neuron number ' num2str(z)];
    title(titleString);
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            15,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])
    %     export_fig(titleString,'-jpg')
%     saveas(gcf, [titleString '.jpg']);
%     close
    %%
%     mean_df = mean(df_neuron_raw);
%     std_df = std(df_neuron_raw,0,1);
%     ste_df = std_df./sqrt(totalNumShock);

    mean_df = mean(df_neuron_normalized);
    std_df = std(df_neuron_normalized,0,1);
    ste_df = std_df./sqrt(totalNumShock);

    figure('Units','inch','Position',[2 2 4 3],'visible','on');
    mseb(timeV,mean_df,ste_df);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('Normalized \DeltaF');
    ylim([0 1])
    yRange = ylim;
    titleString =['Shock neuron number ' num2str(z) ' mean df'];
    
    r = patch([0 1 1 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    set(gca,'TickDir','out'); % The only other option is 'in'
    title(titleString,'FontSize',10);

%     saveas(gcf, [titleString '.jpg']);
%     close

    
end

%%
shockCellNum = 0;
nonShockCellNum = 0;

examRange = [-5 5];
examRangeIdx = 5 *examRange;
samplingRate = 5;
for z =1:totalNeuronNum
    %first neuron's data    
%     dFF = df_neuron;
    neuronData = data(z,:);
    neuronData_raw = data_raw(z,:);
    neuronData_normalized = data_normalized(z,:);
    for i = 1:totalNumShock%heating num
        df_neuron(i,:) = neuronData(idx(i,1):idx(i,2));
        df_neuron_raw(i,:) = neuronData_raw(idx(i,1):idx(i,2));
        df_neuron_normalized(i,:) = neuronData_normalized(idx(i,1):idx(i,2));
    end
    
    dFF = df_neuron_raw;%_normalized;
    index_pointOneSec = round(samplingRate/10);
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baselineStartIdx = abs(examRangeIdx(1))-2*samplingRate;
    baselineEndIdx = abs(examRangeIdx(1))-1;
    baseline = dFF(:,baselineStartIdx:baselineEndIdx);
    meanBaseline = mean(baseline,2);
    
    shockStartIdx = abs(examRangeIdx(1));
    shockendIdx = abs(examRangeIdx(1)) + 2*samplingRate;
    shock =  dFF(:,shockStartIdx:shockendIdx);
    meanShock = mean(shock,2);
    numBin = floor(length(dFF(1,baselineStartIdx:end))/index_pointOneSec);
%     areaUnderROC = zeros(1,numBin);
%     binStart = baselineStartIdx;
% %     set edges with dFF resolution of .1
%     minDff = min(min(dFF)); maxDff = max(max(dFF));
%     edge = minDff:.1:maxDff;
%     %reference of ROC curve
%     reference= 0:.1:1;
%     
% %     figure
%     for t =1:numBin
%         %
%     
%         binEnd = binStart + index_pointOneSec;
%         if binEnd > size(dFF,2)
%             break
%         end
%         r = dFF(:,binStart:binEnd);
%         binStart = binEnd + 1;
%     
%         try
%             b = histcounts(meanBaseline,edge,'Normalization','probability');
%             r = histcounts(meanShock,edge,'Normalization','probability');
%         catch
%             return
%         end
%     
%         for i = 1:length(b)  %1001
%             FA(i) = sum(b(1,i:length(b)));
%             HIT(i) = sum(r(1,i:length(b)));
%         end
%     
%     
%     
%         flip_FA = fliplr(FA);
%         flip_HIT = fliplr(HIT);
%         areaUnderROC(t) = trapz(flip_FA,flip_HIT);
%     
%     end
%     
%     Permutation test
    
    pval = permtest(meanShock,meanBaseline,5000);
    if pval <= 0.05
        shockCellNum = shockCellNum + 1;
    else
        nonShockCellNum = nonShockCellNum +1;
    end
    
end
shockCellNum
nonShockCellNum

% subplot(2,2,1)
figure
data = [shockCellNum nonShockCellNum];
h1 = pie(data); % 2D pie chart
h1(1).FaceColor =[255/255 165/255 165/255];
h1(2).Position = 0.5*h1(2).Position;
h1(3).FaceColor = [165/255 165/255 165/255];
h1(4).Position = 0.5*h1(4).Position;



legend({'Shock-responsive';'Shock-non-responsive'},'Location','southeastoutside','Orientation','vertical')


