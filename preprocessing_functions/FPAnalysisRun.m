%% Created by Jong Hwi Park 7/26/2017


%%
%function fpObj = FPAnalysisRun
clear all
% fpObj = loadFPObj;
fpObj = FPObjMake
% Set Parameters
% fpObj = setSamplingRate(fpObj, 1017.253); %read from file.
fpObj = subsamplingRawData(fpObj,10);
fpObj = setExamRange(fpObj, [-15 20]);

% chooseExperiment

% Set WaveMode and get TTL time

%setWaveMode(fpObj, Wave Number, 'Mode of Wav1', Mode of Wav2'...)
%Currently available mode : 'start','repeat','','pulse','switch'
%Wave mode determine how will event window index be defined
fpObj = setWaveMode(fpObj,'repeat');%,'repeat');%,'repeat');
%start auto trimming.

%set title of each wave for plotting and anlysis
%fpObj = setWaveTitle(fpObj,'active','inactive');

%'on' or 'off'
fpObj = setTTLAlign(fpObj, 'on');
fpObj = getTTLOnOffTime(fpObj);
fpObj = getEventWindowIdx(fpObj);


%fpObj = addCustomEventWindowIdx(fpObj);
% Process Data
%dataTrimming(fpObj, mode, sessionLength);
%mode = 'auto' or 'manual', sessionLength is available in auto mode
%auto mode detect TTL pulse with mode of 'start'
% fpObj = dataTrimming(fpObj,'manual',1500);
fpObj = dataTrimming(fpObj,'manual',600);


fpObj = getTimeVectors(fpObj);
fpObj = applyTrimmingOffset(fpObj);
% fpObj = calculatedFF(fpObj);
% fpObj = calculate473dFF(fpObj)

fpObj = calculatedFF_choice(fpObj);
% Experiment specific analysis and plotting
%Align Event to the TTL Pulse
fpObj = selectTTLtoDisplay(fpObj);
fpObj = createIdvDataArray(fpObj);
fpObj = calculateIdvStatistic(fpObj);
% boutAnalysis(fpObj);
% 
fpObj = normalize(fpObj);
plotOverlaying(fpObj);

% if size(fpObj) < 2
%     plotTrace(fpObj);
%     plotHeatmap(fpObj);
% else
% end
% %
% end

%% Noldus analysis for SR

% fpObj = loadNoldusFile(fpObj,6);
% fpObj = getNoldusPosition(fpObj);
% fpObj = interpolatingNoldusPosition(fpObj);
% fpObj = calculateMeanandSTDofdFF(fpObj);
% fpObj = calculate2dNormdFF(fpObj);
% fpObj = getZoneTime(fpObj,2,[16 17]);
% fpObj = getFPDataIdx(fpObj);
% plot2dHeatmap(fpObj);




