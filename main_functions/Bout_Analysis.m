clear all;close all


fpObj = FPObjMake;
if   fpObj(1).loaded == 0
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
    saveFPObj(fpObj)
end
    %%
    % parameter initialization ..
    timeWindow = 3; %sec
    numWindow = 3; %number of licks
    
    normalizeWindow = 3; %normalize window in sec
    manualExamRange = [-5 5]; %in sec
    fpObj = calculateBout(fpObj,timeWindow,numWindow,normalizeWindow,manualExamRange);

%% Visualization

manualExamRange = [-5 5]; %in sec
plotBout(fpObj,manualExamRange,'n');
plotBoutInfo(fpObj,5,'N');

inspectRange = [-5 15];
plotBar(fpObj,inspectRange,'n');

% plotEachBout(fpObj,[-5 15],'Y');
% plotFirstLickHeatmap(fpObj,15);
% plotLastLickHeatmap(fpObj,15);
% plotBarEachBout(fpObj);
