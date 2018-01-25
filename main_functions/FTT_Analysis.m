clear all

%load data
fpObj = FPObjMake;

%data pre processing
guiOut = fpGUI_2;
fpObj = applyParameters(fpObj,guiOut.subsamplingRate,... %sub sample
    [guiOut.start_examRange guiOut.end_examRange],...    %set exam Range
    guiOut.waveMode,...                                  %set wave mode
    guiOut.alignMode);                                   %set align mode

fpObj = getTTLOnOffTime(fpObj);

%trimming data and get dFF
fpObj = dataTrimming(fpObj,guiOut.trimmingOption,guiOut.duration);
fpObj = getEventWindowIdx(fpObj);
fpObj = getTimeVectors(fpObj);
fpObj = applyTrimmingOffset(fpObj);
fpObj = calculatedFF_choice(fpObj);

%visualize
fpObj = calculateFTT_dFF(fpObj);
plotFTTHeatmap(fpObj);

