function plotBoutInfo(fpObj,addedWindow,saveFigures)
left = 0;bottom = 6;width = 5;height = 4;

totalMouseNum = fpObj.totalMouseNum;
timeWindow =fpObj.timeWindow;
numWindow = fpObj.numWindow;
samplingRate = round(fpObj.samplingRate);
mouseID = [];

if exist('BoutInfoGraph') ~= 7
    [status, ~, ~] = mkdir('BoutInfoGraph');
    if status == 1
        cd('BoutInfoGraph');
    end
else
    cd('BoutInfoGraph');
end
figure('visible','off')

%% licking vs norm max dFF
for numMouse = 1:totalMouseNum
    figure('visible','on')

    %initialization
    dFF = fpObj.idvData(numMouse).dFF;
    timeV = fpObj.idvData(numMouse).timeVectors;
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    lickingIdx = fpObj.idvData(numMouse).lickingIdx;
    numLicking =  fpObj.idvData(numMouse).totalNumLicking;
    totalNumBout = fpObj.idvData(numMouse).totalNumBout;
    
    meanOfFirst180 = mean(dFF(1:180*samplingRate));
    stdOfFirst180 = std(dFF(1:180*samplingRate));
    normalizedDff = (dFF - meanOfFirst180)./stdOfFirst180;
    
    maxDff = [];
    maxNormDff = [];
    totalLickingBout = [];
    totalTimeBout = [];
    for boutNum = 1:totalNumBout
        startIdx = boutIdx(boutNum,1);
        endIdx = boutIdx(boutNum,2) + 5*addedWindow;
        maxDff = [maxDff;max(dFF(startIdx:endIdx))];
        maxNormDff =  [maxNormDff; max(normalizedDff(startIdx:endIdx))];
        
        totalLickingBout =[totalLickingBout; size(find(lickingIdx >=startIdx & lickingIdx <=endIdx),1)];
        
    end
    
    plot(totalLickingBout,maxNormDff,'.','MarkerSize',15)
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    set(gca,'TickDir','out');
    xlabel('Licking Number')%,'FontSize',18)
    ylabel('Normalized Max \DeltaF/F');
    %% Fitting polyfit(2nd degree) 
    
%     
%     p = polyfit(totalLickingBout,maxNormDff,2);
%     f1 = polyval(p,min(totalLickingBout): .1:max(totalLickingBout));
% 
%     %
%     hold on
%     plot(min(totalLickingBout): .1:max(totalLickingBout),f1,'r--')

% %% Exponential curve
% f2 = fit(totalLickingBout,maxNormDff,'exp2')
% % plot(f2,x,y)
% plot(f2,totalLickingBout,maxNormDff)
% 
%     
%     mouseID{numMouse,1} =num2str(fpObj.idvData(numMouse).mouseID);
%     
end
legend(mouseID,'Location','northeastoutside')
if saveFigures =='y' || saveFigures =='Y'
    
    saveas(gcf,['LickNum vs normMaxDFF.svg'])
    saveas(gcf,['LickNum vs normMaxDFF.jpg'])
end
%% time vs norm max dFF
figure('visible','off')

for numMouse = 1:totalMouseNum
    
    %initialization
    dFF = fpObj.idvData(numMouse).dFF;
    timeV = fpObj.idvData(numMouse).timeVectors;
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    lickingIdx = fpObj.idvData(numMouse).lickingIdx;
    numLicking =  fpObj.idvData(numMouse).totalNumLicking;
    totalNumBout = fpObj.idvData(numMouse).totalNumBout;
    
    meanOfFirst180 = mean(dFF(1:180*samplingRate));
    stdOfFirst180 = std(dFF(1:180*samplingRate));
    normalizedDff = (dFF - meanOfFirst180)./stdOfFirst180;
    
    maxDff = [];
    maxNormDff = [];
    totalLickingBout = [];
    totalTimeBout = [];
    for boutNum = 1:totalNumBout
        startIdx = boutIdx(boutNum,1);
        endIdx = boutIdx(boutNum,2) + 5*addedWindow;
        maxDff = [maxDff;max(dFF(startIdx:endIdx))];
        maxNormDff =  [maxNormDff; max(normalizedDff(startIdx:endIdx))];
        
        totalTimeBout = [totalTimeBout;timeV(endIdx) - timeV(startIdx)];
        
    end
    
    plot(totalTimeBout,maxNormDff,'.','MarkerSize',15)
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
    set(gca,'TickDir','out');
    xlabel('Time (s)')%,'FontSize',18)
    ylabel('Normalized Max \DeltaF/F');
    
    hold on
    
    
end

legend(mouseID,'Location','northeastoutside')

if saveFigures =='y' || saveFigures =='Y'
    
    saveas(gcf,['Time vs normMaxDFF.svg'])
    saveas(gcf,['Time vs normMaxDFF.jpg'])
end
cd ..
    

