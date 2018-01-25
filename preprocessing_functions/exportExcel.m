function []=exportExcel(fpObj)
totalMouseNum = fpObj.totalMouseNum;
totalWaveNum = fpObj.waveNum;
examRange = fpObj.examRange;
group_trialArray = [];

for mouseNum = 1:totalMouseNum
        for waveNum = 1:totalWaveNum
            if fpObj.dispBoolean(waveNum)
                group_trialArray = [group_trialArray ;fpObj.idvData(mouseNum).trialArray];
            end
        end
end

for mouseNum = 1:totalMouseNum;
    SheetNum = strcat('Sheet', num2str(mouseNum))
    xlswrite('datafile.xls', group_trialArray{mouseNum}', SheetNum)
end

end