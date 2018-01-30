clear all; clc

%load data
fpObj = FPObjMake_dual;

%data pre processing0
guiOut = fpGUI_2;
fpObj = applyParameters(fpObj,guiOut);
fpObj = getTTLOnOffTime_dual(fpObj);
fpObj = getEventWindowIdx(fpObj);

%trimming data and get dFF
trimGuiOut = trimmingGUI_dual;
%%
fpObj = setDataTrimming(fpObj,trimGuiOut);
fpObj = getTimeVectors(fpObj);
fpObj = applyTrimmingOffset(fpObj);
fpObj = calculatedFF_choice_dual(fpObj);

%get IR indices and normalize via selected examRange
fpObj = selectTTLtoDisplay(fpObj);
fpObj = createIdvDataArray_dual(fpObj);
fpObj = calculateIdvStatistic_dual(fpObj);
fpObj = normalize_dual(fpObj,[-10 0]);

%%
% visualization
 plotPCorrAnalysis(fpObj)
% saveChoice = chooseSave; %yes = 1 ; No = 2
% % plotOverlaying_1(fpObj,saveChoice); %overlaying Trace
% plotOverlaying(fpObj,saveChoice);
% plotTrace(fpObj,saveChoice); %individual Trace
% plotHeatmap(fpObj,saveChoice); %individual Heatmap
% plotauROC(fpObj,saveChoice); %plot auROC for individual mouse