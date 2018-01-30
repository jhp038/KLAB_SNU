function fpObj = createIdvDataArray(fpObj)


totalMouseNum = fpObj.totalMouseNum; 
totalWaveNum = fpObj.waveNum; 
for mouseNum = 1:totalMouseNum
    dFF=fpObj.idvData(mouseNum).dFF;
    for waveNum = 1:totalWaveNum
        %Work only when wave mode is 'repeat'
        trialArray=[];
        if strcmp('repeat',fpObj.waveMode{waveNum})
            WindowIdx=fpObj.idvData(mouseNum).eventWindowIdx{waveNum};
            for i=1:size(WindowIdx,1)
                if WindowIdx(i,1) > 0 && WindowIdx(i,2) < length(dFF)
                    trialArray=[trialArray dFF(WindowIdx(i,1):WindowIdx(i,2))];
                end
            end
            
            
        end
        fpObj.idvData(mouseNum).trialArray{waveNum}=trialArray';
    end
end
end
