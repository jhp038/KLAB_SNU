function []=plotGroupStatistics(fpObj)
totalMouseNum = fpObj.totalMouseNum;
totalWaveNum = fpObj.waveNum;
examRange = fpObj.examRange;
group_trialArray = [];
timeRange = round(fpObj.idvData(1).TTLOffTimes{1,1}(1,1) ...
    - fpObj.idvData(1).TTLOnTimes{1,1}(1,1));

for mouseNum = 1:totalMouseNum
        for waveNum = 1:totalWaveNum
            if fpObj.dispBoolean(waveNum)
                idvData = cell2mat(fpObj.idvData(mouseNum).trialArray);
                group_trialArray = [group_trialArray ;idvData];
            end
        end
end


groupmean = mean(group_trialArray,1)
groupste = std(group_trialArray,1) / sqrt(size(group_trialArray,1));

examRangeLength = length(fpObj.idvData(mouseNum).mean{waveNum});
examRangeVector = [examRange(1):(examRange(2)-examRange(1))/examRangeLength:examRange(2)];
examRangeVector = examRangeVector(1:end-1);


figure;
hold on;

shadedErrorBar(examRangeVector,groupmean,groupste,'b');
%plot([0 0],ylim,'Color',[1 0 0]);
xlim(examRange);
set(gcf,'Color',[1 1 1]);
title([' Group Data : ', fpObj.groupInfoArray{mouseNum}, ', Response to ' fpObj.waveTitle{waveNum}]);
xlabel('Time (s)');
ylabel('\DeltaF/F(%)');

%%IR shading
% Shading passive IR as light red
yRange = ylim;
r = patch([0 timeRange timeRange 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
    [.1,.1,.1,.1],[1,.7,.7]);
set(r, 'FaceAlpha', 0.2,'LineStyle','none');
uistack(r,'top')
%%


saveas(gcf,[fpObj.expDescription{1} 'GroupStatistics'],'png')


end