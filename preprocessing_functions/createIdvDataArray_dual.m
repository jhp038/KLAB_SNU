function fpObj = createIdvDataArray_dual(fpObj)


totalWaveNum = fpObj.waveNum;
for mouseNum = 1:totalMouseNum
    dFF=fpObj.idvData(mouseNum).dFF;
    for waveNum = 1:totalWaveNum
        %Work only when wave mode is 'repeat'
        for numdFF = 1:2
            trialArray=[];
            if strcmp('repeat',fpObj.waveMode{waveNum})
                WindowIdx=fpObj.idvData(mouseNum).eventWindowIdx{waveNum};
                for i=1:size(WindowIdx,1)
                    if WindowIdx(i,1) > 0 && WindowIdx(i,2) < length(dFF)
                        trialArray=[trialArray dFF(WindowIdx(i,1):WindowIdx(i,2),numdFF)];
                    end
                end
            end
            fpObj.idvData(mouseNum).trialArray{waveNum,numdFF}=trialArray';
        end
    end
end
end
