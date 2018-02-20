clear all;close all

%load data
fpObj = FPObjMake;

%data pre processing
guiOut = fpGUI_2;
fpObj = applyParameters(fpObj,guiOut);
                        %set align mode

fpObj = getTTLOnOffTime(fpObj);
fpObj = getEventWindowIdx(fpObj);
trimGuiOut = trimmingGUI_2;
%trimming data and get dFF
 fpObj = setDataTrimming(fpObj,trimGuiOut);
fpObj = getTimeVectors(fpObj);
fpObj = applyTrimmingOffset(fpObj); 
fpObj = calculatedFF_choice(fpObj);
% [boutArray ~]= videoAnalysisGUI;

boutArray = [255 53989; 1776 54807;317 53183;376 51644;349 53962;1151 54834;355 53745]
for i = 1: size(boutArray,1)
    fpObj.idvData(i).LEDOnIdx = boutArray(i,:);
end

% tic
% fpObj = getVideoOnOffIdx(fpObj);
% toc
%After you finish, please run this.
fpObj = processVideoAnalysisData(fpObj)

fpObj = plotVIdeoBout(fpObj);


