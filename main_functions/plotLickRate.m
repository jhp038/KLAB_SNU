function plotLickRate(fpObj,manualExamRange, binSize)
%Input
%fpObj : fpObj struct after processing calculateBout step
%manualExamRange : exam range that you want to plot
%binSize : seconds (sec) you want to calculate the lick rate

totalMouseNum = fpObj.totalMouseNum;
samplingRate = round(fpObj.samplingRate);

histBoutLickStack = [];

edge = manualExamRange(1)*samplingRate:round(binSize*samplingRate):manualExamRange(2)*samplingRate;

for numMouse = 1:totalMouseNum
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    lickingIdx = fpObj.idvData(numMouse).lickingIdx;
    totalNumBout = fpObj.idvData(numMouse).totalNumBout;
    for boutNum = 1:totalNumBout
        startIdx = boutIdx(boutNum,1) + (manualExamRange(1) * samplingRate);
        endIdx = boutIdx(boutNum,1) + (manualExamRange(2) * samplingRate);
        lickIdxRange = lickingIdx(lickingIdx>=startIdx & lickingIdx <= endIdx) - boutIdx(boutNum,1);
        histBoutLick = histcounts(lickIdxRange,edge);
        histBoutLickStack = [histBoutLickStack; histBoutLick];
    end
end

%% Figure
timeV = linspace(manualExamRange(1),manualExamRange(2),size(histBoutLickStack,2));
meanLickRate = mean(histBoutLickStack,1);
steLickRate = std(histBoutLickStack,0,1)./sqrt(size(histBoutLickStack,1));

figure;
lineProps.col = {[1 0 0]};
mseb(timeV,meanLickRate,steLickRate,lineProps)

hold on
set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')

set(gcf,'Color',[1 1 1])

xlabel('Time (s)')%,'FontSize',18)
ylabel(['Lick Rate (' num2str(1./binSize) ' s^{-1})']);
title([fpObj.expDescription ' Lick Rate'],'FontSize',16)

xlim([manualExamRange(1) manualExamRange(2)])
set(gca,'TickDir','out');