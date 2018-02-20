function fpObj = processVideoAnalysisData(fpObj)
totalMouseNum = fpObj.totalMouseNum;
samplingRate = round(fpObj.samplingRate);
examRange = [-5 15];
examRangeIdx = examRange*samplingRate;

meanDffStack = [];
meanNonDffStack = [];

[FileName] = uipickfiles('FilterSpec','*.mat'); %this has to search for .mat files
%%
for mouseNum = 1:totalMouseNum
LEDOnIdx = fpObj.idvData(mouseNum).LEDOnIdx;
% [FileName,PathName] = uigetfile('*.mat','Select the MATLAB data file');

loaded_frame = load(FileName{1,mouseNum});
% time = time.ans./30;
%Just for SR's data...
time = loaded_frame.ans;

%align via subtracting first LEDOn Idx
time = time - LEDOnIdx(1);

%divide by 30 since frame rate is 30
time = time./30;



TTLOnIdx = fpObj.idvData(mouseNum).TTLOnIdx{1,1};
disp(['Mouse ID : ' num2str(fpObj.idvData(mouseNum).mouseID)]);
data = fpObj.idvData(mouseNum).trimmedRawData(TTLOnIdx(1):TTLOnIdx(2),:);
dFF = fpObj.idvData(mouseNum).dFF;
timeV = fpObj.idvData(mouseNum).offsetTimeVectors;
dFF_inRange = dFF(TTLOnIdx(1):TTLOnIdx(2));
timeV_inRange = timeV(TTLOnIdx(1):TTLOnIdx(2));
timeV_inRange = timeV_inRange -timeV_inRange(1);





boutOnIdx =dsearchn(timeV_inRange,time(:,1));
boutOffIdx = dsearchn(timeV_inRange,time(:,2));
totalNumBout = size(boutOnIdx,1);
boutIdx = [boutOnIdx boutOffIdx] ;
plottingIdx = [boutOnIdx boutOffIdx] + repmat(examRangeIdx,[totalNumBout,1]);
plottingIdx_firstLick = [boutOnIdx boutOnIdx] + repmat(examRangeIdx,[totalNumBout,1]);
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
stackmeanFBDA(mouseNum,:) = meanFBDA;
figure
mseb(linspace(examRange(1),examRange(2),size(meanFBDA,2)),meanFBDA,steFirstBout)
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
% saveas(gcf,[fpObj.idvData(mouseNum).Description ' first Lick.jpg']);
% The only other option is 'in'

%% Plotting dFF with bout

% 
figure('Units','inch','Position',[1 1 10 5]);
% left = left + width+2+.2;
% figure

plot(timeV_inRange,dFF_inRange,'k')
hold on
xlim([timeV_inRange(1) timeV_inRange(end)]);
ylim([-3 5])
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
  set(gca,'TickDir','out'); % The only other option is 'in'

xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF/F (%)');
title([fpObj.idvData(mouseNum).Description ' Bout'],'FontSize',10)
%% Calculate bout and nonBout mean

    %% bar graph
    %initialize for each mouse
    meanBoutDff = [];
    hozconcatDff = [];
    hozconcat_nonDff = [];

    for boutNum = 1:totalNumBout
        meanBoutDff(boutNum,1) = mean(dFF(boutIdx(boutNum,1):boutIdx(boutNum,2)));
        steBoutDff(boutNum,1) = std(dFF(boutIdx(boutNum,1):boutIdx(boutNum,2)),0,1)/length(dFF(boutIdx(boutNum,1):boutIdx(boutNum,2)));
        hozconcatDff = [hozconcatDff dFF(boutIdx(boutNum,1):boutIdx(boutNum,2))'];
        hozconcat_nonDff = (sum(dFF) - sum(hozconcatDff)) / (size(dFF,1) - size(hozconcatDff,2));
    end
   
    meanDff = mean(hozconcatDff);
    meanNonDff = mean(hozconcat_nonDff);
    %store meanDff and meanNonDff
    
    meanDffStack = [meanDffStack; meanDff];
    meanNonDffStack = [meanNonDffStack;meanNonDff];
    
    figure('visible','on');
    boutBar = bar(1,meanDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    hold on
    nonBoutBar = bar(2,meanNonDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
    
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Bout', 'NonBout'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF/F (%)');
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    
    title([fpObj.idvData(numMouse).Description '  bar'],'FontSize',6)
    
%     if saveFigures =='y' || saveFigures =='Y'
%         saveas(gcf,[fpObj.idvData(numMouse).Description '  bar.jpg'])
%         saveas(gcf,[fpObj.idvData(numMouse).Description '  bar.svg'])
%     end

end


%% stack mean
figure
mOmFBDA = mean(stackmeanFBDA);
sOmFBDA = std(stackmeanFBDA,0,1)/sqrt(totalMouseNum);
mseb(linspace(examRange(1),examRange(2),size(mOmFBDA,2)),mOmFBDA,sOmFBDA)
hold on
set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')

set(gcf,'Color',[1 1 1])

xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF/F');
%     title([fpObj.idvData(numMouse).Description ' (Norm) First Lick'],'FontSize',6)
ylim([-3 5])

plot([0 0],ylim,'Color',[1 0 0],'LineWidth',1);
yRange = ylim;
set(gca,'TickDir','out');

export_fig(gcf,'slatRock_meanOfmean.pdf', '-dpdf', '-painters');
fpObj.stackmeanFBDA = stackmeanFBDA;

%% Now, I need to calculate bout vs non bout
%% total mean
mOmDff = mean(meanDffStack);
ste_mOmDff = std(meanDffStack)/sqrt(totalMouseNum);
mOmNoneDff = mean(meanNonDffStack);
ste_mOmNoneDff = std(meanNonDffStack)/sqrt(totalMouseNum);
%
figure('visible','on');
hold on
b_1 = bar(1,mOmDff,'FaceColor',[1 1 1],'LineWidth',1.6);
b_2 = bar(2,mOmNoneDff,'FaceColor',[1 1 1],'LineWidth',1.6);
errorbar(1:2,[mOmDff mOmNoneDff],[ste_mOmDff ste_mOmNoneDff],'.','Color','k','linewidth',1.3)

% hold on
% h2 = barwitherr(ste_mOmNoneDff, mOmNoneDff)

set(gca,'xtick',[])
Labels = {'Bout', 'NonBout'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
ylim([-1 1])
% set(h(1),'FaceColor','b');
% set(h(2),'FaceColor','k');

%Ylabel
ylabel('\DeltaF/F (%)');
%ylim,other stuff
set(gcf,'Color',[1 1 1])
set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
set(gca,'box','off')
set(gca,'TickDir','out'); % The only other option is 'in'


p = ranksum(meanDffStack,meanNonDffStack)
sigstar([1 2],p)


