function []=plotIndividualStatistics(fpObj)
totalMouseNum = fpObj.totalMouseNum;
totalWaveNum = fpObj.waveNum;
examRange = fpObj.examRange;

for mouseNum = 1:totalMouseNum
    for waveNum = 1:totalWaveNum
        if fpObj.dispBoolean(waveNum)
            figure;
            hold on;
            
            mean = fpObj.idvData(mouseNum).mean{waveNum};
            ste = fpObj.idvData(mouseNum).ste{waveNum};
            
            examRangeLength = length(fpObj.idvData(mouseNum).mean{waveNum});
            examRangeVector = [examRange(1):(examRange(2)-examRange(1))/examRangeLength:examRange(2)];
            examRangeVector = examRangeVector(1:end-1);
            
            shadedErrorBar(examRangeVector,mean,ste,'b');
            plot([0 0],ylim,'Color',[1 0 0]);
            xlim(examRange);
            set(gcf,'Color',[1 1 1]);
            title([fpObj.idvData(mouseNum).Description ' Response to ' fpObj.waveTitle{waveNum}]);
            xlabel('Time (s)');
            ylabel('\DeltaF/F(%)');
        end
    end
        saveas(gcf,[fpObj.idvData(mouseNum).Description 'IdvStatistics.png'])
end



end