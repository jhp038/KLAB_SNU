clear all;close all

%load data
fpObj = FPObjMake;

%data pre processing
guiOut = fpGUI_2;
fpObj = applyParameters(fpObj,guiOut.subsamplingRate,... %su b sample
    [guiOut.start_examRange guiOut.end_examRange],...    %set exam Range
    guiOut.waveMode,...                                  %set wave mode
    guiOut.alignMode);                                   %set align mode

fpObj = getTTLOnOffTime(fpObj);
fpObj = getEventWindowIdx(fpObj);
trimGuiOut = trimmingGUI_2;
%trimming data and get dFF
 fpObj = setDataTrimming(fpObj,trimGuiOut);
fpObj = getTimeVectors(fpObj);
fpObj = applyTrimmingOffset(fpObj); 
fpObj = calculatedFF_choice(fpObj);

%%


% Bout analysis 
% parameter initialization .. 
timeWindow = 3; %sec
numWindow = 3; %number of licks
normalizeWindow = 3; %normalize window in sec
manualExamRange = [-20 15]; %in sec
fpObj = calculateBout(fpObj,timeWindow,numWindow,normalizeWindow,manualExamRange);

%% Visualization
plotBout(fpObj,'Y');
plotBoutInfo(fpObj,5,'Y');
plotLick(fpObj,manualExamRange,'Y');
plotBar(fpObj,'Y');
% plotEachBout(fpObj,[-5 15],'Y');

% saveFPObj(fpObj)



% plotFirstLickHeatmap(fpObj,15);
% plotLastLickHeatmap(fpObj,15);
% plotBarEachBout(fpObj);
