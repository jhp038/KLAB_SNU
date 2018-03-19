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

boutArray = [309 27309; 645 27646];
for i = 1: size(boutArray,1)
    fpObj.idvData(i).LEDOnIdx = boutArray(i,:);
end

% tic
% fpObj = getVideoOnOffIdx(fpObj);
% toc
%After you finish, please run this.
fpObj = processVideoAnalysisData(fpObj)

fpObj = plotVideoBout(fpObj);


