clear all;clc

%load data
fpObj = FPObjMake;

if   fpObj(1).loaded == 0
    %data pre processing0
    guiOut = fpGUI_2;
    fpObj = applyParameters(fpObj,guiOut);
    
    
    fpObj = getTTLOnOffTime(fpObj);
    fpObj = getEventWindowIdx(fpObj);
    
    %trimming data and get dFF
    trimGuiOut = trimmingGUI_2;
    fpObj = setDataTrimming(fpObj,trimGuiOut);
    fpObj = getTimeVectors(fpObj);
    fpObj = applyTrimmingOffset(fpObj);
    fpObj = calculatedFF_choice(fpObj);
    
    %get IR indices and normalize via selected examRange
    fpObj = selectTTLtoDisplay(fpObj);
    fpObj = createIdvDataArray(fpObj);
    fpObj = calculateIdvStatistic(fpObj);
    fpObj = normalize(fpObj);
    saveFPObj(fpObj)
end
%%
% visualization
saveChoice = chooseSave; %yes = 1 ; No = 2
% plotOverlaying_1(fpObj,saveChoice); %overlaying Trace
plotOverlaying(fpObj,saveChoice);
plotTrace(fpObj,saveChoice); %individual Trace
plotHeatmap(fpObj,saveChoice); %individual Heatmap
plotauROC(fpObj,saveChoice); %plot auROC for individual mouse





