%% Processing Video data
function fpObj = plotVideoBout(fpObj)
% fpObj = getVideoOnOffIdx(fpObj);
%initialize video data
LEDOnIdx = fpObj.idvData(1).LEDOnIdx;
% [FileName,PathName] = uigetfile('*.mat','Select the MATLAB data file');
[FileName] = uipickfiles('FilterSpec','*.mat'); %this has to search for .xlsx files

loaded_frame = load([PathName '\' FileName]);
% time = time.ans./30;
%Just for SR's data...
time = loaded_frame.ans;

%align via subtracting first LEDOn Idx
time = time - LEDOnIdx(1);

%divide by 30 since frame rate is 30
time = time./30;




%% Processing dFF data
%initialize
totalMouseNum = fpObj.totalMouseNum;
samplingRate = round(fpObj.samplingRate);
examRange = [-5 15];
examRangeIdx = examRange*samplingRate;


numMouse = 1;%:totalMouseNum; %U HAVE TO CHANGE THIS

TTLOnIdx = fpObj.idvData(numMouse).TTLOnIdx{1,1};
disp(['Mouse ID : ' num2str(fpObj.idvData(numMouse).mouseID)]);
data = fpObj.idvData(numMouse).trimmedRawData(TTLOnIdx(1):TTLOnIdx(2),:);
dFF = fpObj.idvData(numMouse).dFF;
timeV = fpObj.idvData(numMouse).offsetTimeVectors;
dFF_inRange = dFF(TTLOnIdx(1):TTLOnIdx(2));
timeV_inRange = timeV(TTLOnIdx(1):TTLOnIdx(2));
timeV_inRange = timeV_inRange -timeV_inRange(1);





boutOnIdx =dsearchn(timeV_inRange,time(:,1));
boutOffIdx = dsearchn(timeV_inRange,time(:,2));
totalNumBout = size(boutOnIdx,1);
boutIdx = [boutOnIdx boutOffIdx] ;
plottingIdx = [boutOnIdx boutOffIdx] + repmat(examRangeIdx,[totalNumBout,1]);
plottingIdx_firstLick = [boutOnIdx boutOnIdx] + repmat(examRangeIdx,[totalNumBout,1]);

%%

% for boutNum = 1:totalNumBout
%     figure
%     startIdx = plottingIdx(boutNum,1);
%     endIdx = plottingIdx(boutNum,2);
%     plot(timeV_inRange(startIdx:endIdx),dFF_inRange(startIdx:endIdx))
%     hold on
%     set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
%     set(gca, 'box', 'off')
%     
%     set(gcf,'Color',[1 1 1])
%     
%     xlabel('Time (s)')%,'FontSize',18)
%     ylabel('n\DeltaF/F');
% %     title([fpObj.idvData(numMouse).Description ' (Norm) First Lick'],'FontSize',6)
%     
%     plot([timeV_inRange(boutOnIdx(boutNum)) timeV_inRange(boutOnIdx(boutNum))],ylim,'Color',[1 0 0]);
%     plot([timeV_inRange(boutOffIdx(boutNum)) timeV_inRange(boutOffIdx(boutNum))],ylim,'Color',[1 0 0]);
%     
% %     xlim([examRange(1) examRange(2)])
%     set(gca,'TickDir','out'); % The only other option is 'in'
% end

%% fist lick mean
firstBoutDffArray = [];
for boutNum = 1: totalNumBout
    if plottingIdx_firstLick(boutNum,1) < 0
        return
    else
        firstBoutDffArray = [firstBoutDffArray;dFF_inRange(plottingIdx_firstLick(boutNum,1):plottingIdx_firstLick(boutNum,2))'];
    end
end
steFirstBout = std(firstBoutDffArray,0,1)/sqrt(size(firstBoutDffArray,1));

meanFBDA = mean(firstBoutDffArray);

figure
mseb(linspace(-15,30,size(meanFBDA,2)),meanFBDA,steFirstBout)
hold on
set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')

set(gcf,'Color',[1 1 1])

xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF/F');
%     title([fpObj.idvData(numMouse).Description ' (Norm) First Lick'],'FontSize',6)

plot([0 0],ylim,'Color',[1 0 0]);

xlim([examRange(1) examRange(2)])
set(gca,'TickDir','out');
saveas(gcf,[fpObj.idvData(numMouse).Description ' first Lick.jpg']);
% The only other option is 'in'

%% Plotting dFF with bout

% 
figure('Units','inch','Position',[1 1 10 5]);
% left = left + width+2+.2;
% figure

plot(timeV_inRange,dFF_inRange)
hold on
xlim([timeV_inRange(1) timeV_inRange(end)]);
yRange = ylim;
xRange = xlim;
ylim([yRange(1),yRange(2)]);


%Shading bout as light red
for i = 1: totalNumBout
    r = patch([timeV(boutIdx(i,1)) timeV(boutIdx(i,2)) timeV(boutIdx(i,2)) timeV(boutIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
    uistack(r,'up')
end


% setting font size, title
set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')
set(gcf,'Color',[1 1 1])

xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF/F (%)');
title([fpObj.idvData(numMouse).Description ' Bout'],'FontSize',10)
saveas(gcf,[fpObj.idvData(numMouse).Description ' Bout.jpg']);