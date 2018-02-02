%% Initialization
clear all;clc
fileNames = uipickfiles('REFilter','\.mat$|\.dat$|\.txt$');
checkRawData = 0;
%loading files

for numFIles = 1;size(fileNames,2)
    [pathstr,name,ext] = fileparts(fileNames{1,numFIles}) ;
    switch ext
        case '.dat'
            fid = fopen(filename,'r');
            datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1);
            fclose(fid);
            raw_timeV = datacell{1,3};%%
            raw_timeV(isnan(raw_timeV)) = [];
            raw_timeV = raw_timeV./1000;
        case '.txt'
            if checkRawData == 0
                RawData = Text2Array_miniscope(pathstr);
                checkRawData = 1;
            end
        case '.mat'
            load(filename);
            data = neuron.C;
            data_raw = neuron.C_raw;
    end
end
  


RawData = Text2Array_miniscope(folder_name);
%load dat file
filename = uigetfile('*.dat','Select the timestamp file');
fid = fopen(filename,'r');
datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1);
fclose(fid);
raw_timeV = datacell{1,3};%%
raw_timeV(isnan(raw_timeV)) = [];
raw_timeV = raw_timeV./1000;
%cut first 50 sec
trimmed_timeV = raw_timeV(1001:end);

% loaded timeV, and cut first 50 sec
timeV = downsample(trimmed_timeV,4);
timeV = timeV - raw_timeV(1000);

% now dealing with wave file
timeVectorS = RawData(:,1);
ExtEvent = RawData(:,2);
TTLThresh = (max(ExtEvent) + min(ExtEvent)) / 2;

% Now we want to figure out when the stimulation signal goes ON.
TTLeventON = ExtEvent >= TTLThresh;
TTLThreshCrossings = diff(TTLeventON);      % Find threshold crossings by taking the first order difference

TTLOnIdx = find(TTLThreshCrossings == 1);      % Find crossings from below
TTLOnTimes = timeVectorS(TTLOnIdx);         % TTLPulseTimeS

TTLOffIdx = find(TTLThreshCrossings == -1);  
TTLOffTimes = timeVectorS(TTLOffIdx);         % TTLPulseTimeS

if size(TTLOffIdx,1)>1
    RawData_trimmed = RawData(TTLOnIdx:end,:);
else
    RawData_trimmed = RawData(TTLOnIdx:TTLOffIdx,:);
end
% RawData_trimmed(:,1) = RawData_trimmed(:,1) - RawData_trimmed(1,1);

k = dsearchn(RawData_trimmed(:,1),raw_timeV(1001));
RawData_processed = RawData_trimmed(k:end,:);
RawData_processed(:,1) = RawData_processed(:,1) - RawData_trimmed(k-1,1);
timeVectorS = RawData_processed(:,1);

%load neuron
filename = uigetfile('*.mat','Select the NEURON file');
load(filename);
data = neuron.C;
data_raw = neuron.C_raw;


%%

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
TTLOffIdx = find(TTLThreshCrossings == -1);      % Find crossings from below

timeIdx = [timeVectorS(TTLOnIdx) timeVectorS(TTLOffIdx)];

% samplingRate = 102;

%% Load neuron data and find timepoint

data = neuron.C;
data_raw = neuron.C_raw;
last_timeV = timeV(end);
totalNeuronNum = size(data,1);
videoShockIdx = [];
videoShockIdx(:,1) = dsearchn(timeV,timeIdx(:,1));
videoShockIdx(:,2) = dsearchn(timeV,timeIdx(:,2));
totalNumShock = length(TTLOnIdx);

if videoShockIdx(end) > size(timeV,1)
    videoShockIdx(end) =  size(timeV,1);
end


%% Figure
figure('Units','inch','Position',[1 1 10 5],'Visible','on');

for z = 1%: totalNeuronNum
    
    % left = left + width+2+.2;
    % figure
    %     timeV = linspace(0,last_timeV,size(data_raw,2));
    plot(timeV,data_raw(z,:));
    hold on
    xlim([timeV(1) timeV(end)]);
    yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    
    %Shading bout as light red
    for i = 1: totalNumShock
        r = patch([timeV(videoShockIdx(i,1)) timeV(videoShockIdx(i,2)) timeV(videoShockIdx(i,2)) timeV(videoShockIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
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
    title({['714 Shock Bout NeuronNum : ' num2str(z)]; ...
        ['numShock = ' num2str(totalNumShock)]},...
        'FontSize',10)
    %     title({[['714 MED drinking Bout NeuronNum :' num2str(z)'];...
    %         ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numBout)];...
    %         ['Interval = ' num2str(timeWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks']},...
    %         'FontSize',10)
    %     saveas(gcf,['714 MED drinking Bout RAW NeuronNum ' num2str(z) '.jpg'])
    %     clf
    % pause
    % clf
end
%%

examRange = [-5 15];
examRangeIdx = 5 *examRange;
idx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[totalNumShock 1]);
%%

for z = 1%:totalNeuronNum
    %first neuron's data
    neuronData = data(z,:);
    neuronData_raw = data_raw(z,:);
    
    for i = 1:totalNumShock%heating num
        df_neuron(i,:) = neuronData(idx(i,1):idx(i,2));
        df_neuron_raw(i,:) = neuronData_raw(idx(i,1):idx(i,2));
        
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
    imagesc(timeV,1:1:totalNumShock,df_neuron);
    hold on
    
    plot([0,0],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    plot([1,1],ylim, 'LineStyle', '--', 'Color', [1 1 1], 'LineWidth', 2);
    
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
    ylabel('Shock Num');
    titleString =['Shock 933 neuron number ' num2str(z)];
    title(titleString);
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            15,...
        'FontName',          'Arial',...
        'TickDir',            'out',...
        'box',               'off')
    set(gcf,'Color',[1 1 1])
    %     export_fig(titleString,'-jpg')
    saveas(gcf, [titleString '.jpg']);
%     close
    %%
    mean_df = mean(df_neuron_raw);
    std_df = std(df_neuron_raw,0,1);
    ste_df = std_df./sqrt(10);
    figure('Units','inch','Position',[2 2 4 3],'visible','on');
    mseb(timeV,mean_df,ste_df);
    hold on
    
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    yRange = ylim;
    titleString =['Shock neuron number ' num2str(z) ' mean df'];
    
    r = patch([0 1 1 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    uistack(r,'up')
    set(gca,'TickDir','out'); % The only other option is 'in'
    saveas(gcf, [titleString '.jpg']);
%     close

    
end
