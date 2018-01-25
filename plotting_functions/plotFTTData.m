% check lin 50 for session length setting

function []=plotTCTData(fpObj)
totalMouseNum = fpObj.totalMouseNum;
dFF = {};
for mouseNum=1:totalMouseNum
    fpObj = readTempData(fpObj);
    % synchronizing 2 data
    timeVectors_reset = fpObj.idvData(mouseNum).timeVectors - fpObj.idvData(mouseNum).timeVectors(1);
    fpObj.idvData(mouseNum).IntTemp = interp1(fpObj.idvData(mouseNum).TempTimeStamp,fpObj.idvData(mouseNum).TempData, timeVectors_reset,'linear','extrap');
    
    display(['synchronizing data... / ID #', num2str(fpObj.idvData(mouseNum).mouseID)] );

    raw473 = fpObj.idvData(mouseNum).raw473;
    raw405 = fpObj.idvData(mouseNum).raw405;
    fitted405 = fpObj.idvData(mouseNum).fitted405;
    timeVectors = fpObj.idvData(mouseNum).timeVectors;
    dFF{mouseNum} = [fpObj.idvData(mouseNum).dFF];
    trimmingRange = fpObj.idvData(mouseNum).trimmingRange;
    
    figure;
    subplot(2,2,1);
    %plot every data before trimming and analysis window
    hold on;
    plot(fpObj.idvData(mouseNum).RawData(:,1),fpObj.idvData(mouseNum).RawData(:,2),'r');
    plot(fpObj.idvData(mouseNum).RawData(:,1),fpObj.idvData(mouseNum).RawData(:,3),'b');
    plot([trimmingRange(1)/fpObj.samplingRate trimmingRange(1)/fpObj.samplingRate], ylim, 'k');
    plot([trimmingRange(2)/fpObj.samplingRate trimmingRange(2)/fpObj.samplingRate], ylim, 'k');
    legend('473','405','Analysis Window');
    
    subplot(2,2,2);
    %Plot raw trace and fitted data between analysis window
    hold on;
    plot(timeVectors,raw473,'r');
    plot(timeVectors,raw405,'b');
    plot(timeVectors,fitted405,'g');
    legend('473','405','fitted');
    set(gca,'xlim',trimmingRange/fpObj.samplingRate);

    % dFoverF
    subplot(2,2,3); 
    hold on;
    [axes, line1, line2] = plotyy(timeVectors_reset, dFF{mouseNum}, fpObj.idvData(mouseNum).TempTimeStamp,fpObj.idvData(mouseNum).TempData); 
    set(axes,'xlim',[0 length(timeVectors)/fpObj.samplingRate])
    set(line1,'linestyle','-','color', 'blue', 'linewidth', 0.5)
    set(line2,'linestyle','-','color', 'red', 'linewidth', 1)
    ylabel('dF/F')
    xlabel('time(s)')
%     set(X(1), 'ylim', [0 max(fpObj.idvData(mouseNum).TempData)*1.2])
%     set(X(2), 'ylim', [0 max(fpObj.idvData(mouseNum).TempData)*1.2])

    title(fpObj.idvData(mouseNum).Description);
    
%     subplot(2,2,4);
%     hold on;
%     bar(blockPeak);
%     title('Peaks from each session');
    
end
%% Plotting Group Data
for mouseNum = 1:totalMouseNum
    dFFarray(:,mouseNum) = dFF{1,mouseNum};
end

dFF_mean = mean(dFFarray,2);
dFF_ste = std(dFFarray,0,2)/sqrt(size(dFFarray,2));
dFF_UpErr = [dFF_mean + dFF_ste];
dFF_DownErr = [dFF_mean - dFF_ste];

figure;

hold on;

[axes, line1, line2] = plotyy(timeVectors_reset, dFF_mean, fpObj.idvData(mouseNum).TempTimeStamp,fpObj.idvData(mouseNum).TempData);
set(axes,'xlim',[0 length(timeVectors)/fpObj.samplingRate])
hold on;
h1 = area(timeVectors_reset, dFF_UpErr, min(dFF_DownErr));
h1.LineStyle = 'none';
h1.FaceColor = [1 0 0];
h1.FaceAlpha = [0.4];
h2 = area(timeVectors_reset, dFF_DownErr, min(dFF_DownErr));
h2.LineStyle = 'none';
h2.FaceColor = [1 1 1];
legend('temperature', 'dF/F');
% set(axes(1),'YTick',[-20:5:20]);
% set(axes(2),'YTick',[20:5:60]);
set(gca,'fontsize',14);
%% Plotting block average
% check here for session length setting
%% Up session
UpStart = [240 720 1200]; 
UpDuration = [60 60 60];
    
for i = 1:length(UpStart)    
    UpOnIdx(i) = UpStart(i) * fpObj.samplingRate;
    UpOffIdx(i) = (UpStart(i) + UpDuration(i))*fpObj.samplingRate;
end
    

for i = 1:length(UpStart)
    UpdFF(i,1) = mean(dFF_mean(UpOnIdx(i):UpOffIdx(i)));
    UpSTE(i,1) = mean(dFF_ste(UpOnIdx(i):UpOffIdx(i)));
end

figure;
hold on;
subplot(1,3,1);hold on;
bar(UpdFF)
errorbar(UpdFF, UpSTE)
title('Warming session block average')
set(gca,'fontsize',14);  

%% Flat session
FlatStart = [300 780 1260];
FlatDuration = [240 240 240];
    
for i = 1:length(FlatStart)    
    FlatOnIdx(i) = FlatStart(i) * fpObj.samplingRate;
    FlatOffIdx(i) = (FlatStart(i) + FlatDuration(i))*fpObj.samplingRate;
end
    

for i = 1:length(FlatStart)
    FlatdFF(i,1) = mean(dFF_mean(FlatOnIdx(i):FlatOffIdx(i)));
    FlatSTE(i,1) = mean(dFF_ste(FlatOnIdx(i):FlatOffIdx(i)));
end
subplot(1,3,2);hold on;
bar(FlatdFF)
errorbar(FlatdFF, FlatSTE)
title('Plateau session block average')
set(gca,'fontsize',14);

%% Down session
DownStart = [540 1020 1500];
DownDuration = [60 60 60];
    
for i = 1:length(DownStart)    
    DownOnIdx(i) = DownStart(i) * fpObj.samplingRate;
    DownOffIdx(i) = (DownStart(i) + DownDuration(i))*fpObj.samplingRate;
end
    

for i = 1:length(DownStart)
    DowndFF(i,1) = mean(dFF_mean(DownOnIdx(i):DownOffIdx(i)));
    DownSTE(i,1) = mean(dFF_ste(DownOnIdx(i):DownOffIdx(i)));
end

subplot(1,3,3);hold on;
bar(DowndFF)
errorbar(DowndFF, DownSTE)
title('Cooling session block average')
set(gca,'fontsize',14);

%     
%     
%     imagesc(RawData_cut(:,1),[1:nEvents],SessionFnData');
%     colormap(gca,customColorMap);
%     plot(RawData_cut(:,1),1+RawData_cut(:,5)*0.01,'k');
%     legend('Center');
%     xlabel('Time (s)'); ylabel('dF/F');
%     set(gca,'YTickLabel',{' '})
%     xlim([analysisWindowS(1) analysisWindowS(end)]);
%     
%     % shaded bar plot
%     subplot(2,2,4); hold on;
%     meanFn1 = mean(SessionFnData,2);
%     steFn2 = std(SessionFnData,0,2) / sqrt(size(SessionFnData,2));
%     errBarFn = [steFn2';steFn2'];
%     shadedErrorBar(analysisWindowS,meanFn1,errBarFn,'b');
%     xlim([analysisWindowS(1) analysisWindowS(end)]);
%     set(gcf,'Color',[1 1 1]);
%     xlabel('Time (s)');
%     ylabel('\DeltaF/F(%)');
    
    
    
end