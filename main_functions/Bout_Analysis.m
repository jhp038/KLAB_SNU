clear all;close all

%load data if directory/file does not exist
% checkFPObj
fpObj = FPObjMake;
%data pre processing
guiOut = fpGUI_2;
fpObj = applyParameters(fpObj,guiOut);

fpObj = getTTLOnOffTime(fpObj);
fpObj = getEventWindowIdx(fpObj);
trimGuiOut = trimmingGUI_2;
%trimming data and get dFF
fpObj = setDataTrimming(fpObj,trimGuiOut);
fpObj = getTimeVectors(fpObj);
fpObj = applyTrimmingOffset(fpObj); 
fpObj = calculatedFF_choice(fpObj);
% saveFPObj



%%
% parameter initialization .. 
timeWindow = 3; %sec
numWindow = 3; %number of licks
normalizeWindow = 3; %normalize window in sec
manualExamRange = [-20 15]; %in sec
fpObj = calculateBout(fpObj,timeWindow,numWindow,normalizeWindow,manualExamRange);

%% Visualization
plotBout(fpObj,'N');
plotBoutInfo(fpObj,5,'Y');
plotLick(fpObj,manualExamRange,'Y');

inspectRange = [-20 15];
plotBar(fpObj,inspectRange,'Y');

% plotEachBout(fpObj,[-5 15],'Y');

% saveFPObj(fpObj)



% plotFirstLickHeatmap(fpObj,15);
% plotLastLickHeatmap(fpObj,15);
% plotBarEachBout(fpObj);
