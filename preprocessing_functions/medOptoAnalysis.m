%% MED optogenetics analysis
% Plot cumulative lick curve, lick rate, bout number, bout duration, cumulative bout curve,
% raster plot of bouts.

% Written by Kyunghoe Kim, February 15, 2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        This code requires specific xlsx template to run.                                  % 
%        Please refer to Kyunghoe for questions regarding the format                 %
%        or code related questions.                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set parameters for analysis
% Change the variables below to make sure this code can properly analyze the data

param.xlimRange = [-50 10850]; % Modify x axis range in sec. to see 0 ~1500, set as [-50 1550]
param.timeBin = 500; % Size of a time bin in seconds
param.timeWindow = 1; % Change to maximum inter-lick interval for bout detection
param.numWindow = 10; % Change to minimum lick number for bout detection
param.numBottle = 1; % If it's two-bottled, change it to 2


%% Read in Excel file & load the data to struct
% This code uses a struct named medObj for data storage

[info.fileName,info.pathName,~] = uigetfile('*.xlsx','Select the excel  file'); cd(info.pathName)
[excelNumOnly, ~, excelRaw] = xlsread(info.fileName);

info.ctrlIdx = find(strcmp(excelRaw(6, 2:end), 'Ctrl'));
info.expIdx = find(strcmp(excelRaw(6, 2:end), 'Exp'));
info.totalNumMouse = size([info.ctrlIdx info.expIdx], 2);
info.leftLickStart = find(strcmp(excelRaw(:, 1), 'Left lick timepoint'));
info.rightLickStart = find(strcmp(excelRaw(:, 1), 'Right lick timepoint'));

medObj(info.totalNumMouse).mouseNum = 0; % Preallocation

% The big for loop begins here
for ii = 1:info.totalNumMouse
    medObj(ii).mouseNum = excelNumOnly(1, ii);
    medObj(ii).group = excelRaw(6, ii+1); % You have to use index ii+1 for excelRaw
    medObj(ii).numLeftLick = excelNumOnly(9, ii);
    medObj(ii).leftLicks = snip(excelNumOnly(info.leftLickStart : info.rightLickStart - 2, ii), '0');
    % If it's two-bottled, load right lick data
    if param.numBottle == 2
        medObj(ii).numRightLick = excelNumOnly(10, ii);
        medObj(ii).rightLicks = snip(excelNumOnly(info.rightLickStart : end, ii), '0');
    end
    
    
%% Bout detection step 1
% We're still in the for loop (ii = 1:info.totalNumMouse)
% Step 1: bout offset detection - interlick interval is greater than param.timeWindow
    medObj(ii).leftLickInterval = diff(medObj(ii).leftLicks);
    medObj(ii).leftBoutOffset = find(medObj(ii).leftLickInterval >= param.timeWindow);
    if medObj(ii).numLeftLick - medObj(ii).leftBoutOffset(end) >= param.timeWindow
        medObj(ii).leftBoutOffset(end+1) = medObj(ii).numLeftLick;
    end
    medObj(ii).leftNumPossibleBout = size(medObj(ii).leftBoutOffset, 1);
    medObj(ii).leftOnOffIdx = ones(medObj(ii).leftNumPossibleBout, 2);
    medObj(ii).leftOnOffIdx(2:end, 1) = medObj(ii).leftBoutOffset(1:end-1)+1;
    medObj(ii).leftOnOffIdx(:, 2) = medObj(ii).leftBoutOffset;
    
    % If it's two-bottled, ...
    if param.numBottle == 2
        medObj(ii).rightLickInterval = diff(medObj(ii).rightLicks);
        medObj(ii).rightBoutOffset = find(medObj(ii).rightLickInterval >= param.timeWindow);
        if medObj(ii).numRightLick - medObj(ii).rightBoutOffset(end) >= param.timeWindow
            medObj(ii).rightBoutOffset(end+1) = medObj(ii).numRightLick;
        end
        medObj(ii).rightNumPossibleBout = size(medObj(ii).rightBoutOffset, 2);
        medObj(ii).rightOnOffIdx = ones(medObj(ii).rightNumPossibleBout, 2);
        medObj(ii).rightOnOffIdx(2:end, 1) = medObj(ii).rightBoutOffset(1:end-1)+1;
        medObj(ii).rightOnOffIdx(:, 2) = medObj(ii).rightBoutOffset;
    end
    
    
%% Bout detection step 2
% Step 2: non-bout detection - the number of licks in each interval is less than param.numWindow
    for jj = 1:medObj(ii).leftNumPossibleBout
        if (medObj(ii).leftOnOffIdx(jj, 2) - medObj(ii).leftOnOffIdx(jj, 1) + 1) < param.numWindow
            medObj(ii).leftOnOffIdx(jj, :) = 0;
        end
    end
    medObj(ii).leftOnOffIdx = snip(medObj(ii).leftOnOffIdx, '0');
    medObj(ii).leftNumBout = size(medObj(ii).leftOnOffIdx, 1);
    
    % If it's two-bottled, ...
    if param.numBottle == 2
        for jj = 1:medObj(ii).rightNumPossibleBout
            if (medObj(ii).rightOnOffIdx(jj, 2) - medObj(ii).rightOnOffIdx(jj, 1) + 1) < param.numWindow
            medObj(ii).rightOnOffIdx(jj, :) = 0;
            end
        end
        medObj(ii).rightOnOffIdx = snip(medObj(ii).rightOnOffIdx, '0');
        medObj(ii).rightNumBout = size(medObj(ii).rightOnOffIdx, 1);
    end

    
%% Cumulative number of licks
% Generates data for the cumulative lick curve
    param.edges = 0:param.timeBin:param.xlimRange(2)-50;
    medObj(ii).leftHistLicks = histcounts(medObj(ii).leftLicks, param.edges);
    medObj(ii).leftCumLicks = cumsum(medObj(ii).leftHistLicks);
    % Adds zeros to the first column for plot
    medObj(ii).leftCumLicks = [0 medObj(ii).leftCumLicks];
    
    % If it's two-bottled, ...
    if param.numBottle == 2
        medObj(ii).rightHistLicks = histcounts(medObj(ii).rightLicks, param.edges);
        medObj(ii).rightCumLicks = cumsum(medObj(ii).rightHistLicks);
        % Adds zeros to the first column for plot
        medObj(ii).rightCumLicks = [0 medObj(ii).rightCumLicks];
    end
    
    
%% Lick rate
% Generates data for the lick rate plot
    medObj(ii).leftLickRate = medObj(ii).leftHistLicks / param.timeBin;
    % Adds zeros to the first column for plot
    medObj(ii).leftLickRate = [0 medObj(ii).leftLickRate];

    % If it's two-bottled, ...
    if param.numBottle == 2
        medObj(ii).rightLickRate = medObj(ii).rightHistLicks / param.timeBin;
        % Adds zeros to the first column for plot
        medObj(ii).rightLickRate = [0 medObj(ii).rightLickRate];
    end
    
    
%% Cumulative bout
% Generates data for the cumulative bout curve
    
end

% idv cum lick
% group cum lick
% idv lick rate
% group lick rate
% num bout

%% Lick raster plot
% figure
% hold on
% ylim([0 info.totalNumMouse])
% xlim([0 param.xlimRange(2)-50])
% xlabel('Time (sec)')
% ylabel('Mouse')
% rasterTimeBin = 100;
% 

% for ii = 1:info.totalNumMouse
%     wholeIdx = [info.expIdx info.ctrlIdx];
%     kk = wholeIdx(ii)
%     for jj = 1:length(medObj(kk).leftLicks)
%         line([medObj(kk).leftLicks(jj) medObj(kk).leftLicks(jj)], [ii-1 ii])
%     end
% end
