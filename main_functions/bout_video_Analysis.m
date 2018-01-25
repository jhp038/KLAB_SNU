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
[boutArray ~]= videoAnalysisGUI;



%After you finish, please run this.
fpObj = plotVIdeoBout(fpObj);


