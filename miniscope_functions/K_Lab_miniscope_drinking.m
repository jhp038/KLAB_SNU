%% Initialization
folder_name = uigetdir;

RawData = Text2Array_miniscope(folder_name);
RawData = downsample(RawData,10); %we have erased first 50 sec.

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

RawData = RawData(TTLOnIdx:TTLOffIdx,:);
RawData(:,1) = RawData(:,1) - RawData(1,1);

k = dsearchn(RawData(:,1),50);
RawData_processed = RawData(k+1:end,:);
RawData_processed(:,1) = RawData_processed(:,1) - RawData_processed(1,1);

%load neuron
data = neuron.C;
data_raw = neuron.C_raw;
timeV = (0:size(data,2))./5;
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

%find 50sec and erase

samplingRate = 102;
boutWindow = 10;
numWindow = 10; %number of licks



%initialization
%             disp([num2str(numMouse)]);
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
filename = uigetfile('*.mat','Select the NEURON file');
load(filename);
data = neuron.C;
data_raw = neuron.C_raw;
last_timeV = timeV(end);
totalNeuronNum = size(data,1);
videoLickingIdx = [];
videoLickingIdx(:,1) = dsearchn(timeV',timeIdx(:,1));
videoLickingIdx(:,2) = dsearchn(timeV',timeIdx(:,2));

videoLickingEveryIdx = dsearchn(timeV',timeVectorS(lickingIdx));

if videoLickingIdx(end) > size(timeV,2)
    videoLickingIdx(end) =  size(timeV,2)
end


%% Figure

for z = 1: totalNeuronNum
        figure('Units','inch','Position',[1 1 10 5],'Visible','off');

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
    
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF');
    title({['933 MED drinking Bout NeuronNum : ' num2str(z)]; ...
        ['numLick = ' num2str(size(videoLickingEveryIdx,1)) '     numBout = ' num2str(numActualBout)];...
        ['Interval = ' num2str(boutWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',10)
%     title({[['714 MED drinking Bout NeuronNum :' num2str(z)'];...
%         ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numBout)];...
%         ['Interval = ' num2str(timeWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks']},...
%         'FontSize',10)
    saveas(gcf,['933 MED drinking Bout RAW NeuronNum ' num2str(z) '.jpg'])
% pause
% clf
end
