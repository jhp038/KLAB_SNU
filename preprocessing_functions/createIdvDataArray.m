function fpObj = createIdvDataArray(fpObj)
totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    
    totalMouseNum = fpObj(fpObjNum).totalMouseNum; %3
    totalWaveNum = fpObj(fpObjNum).waveNum; %2
    for mouseNum = 1:totalMouseNum
        dFF=fpObj(fpObjNum).idvData(mouseNum).dFF;
        for waveNum = 1:totalWaveNum
           %Work only when wave mode is 'repeat'
           trialArray=[];
           if strcmp('repeat',fpObj(fpObjNum).waveMode{waveNum})
               WindowIdx=fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum};
               for i=1:size(WindowIdx,1)                 
                     if WindowIdx(i,1) > 0 && WindowIdx(i,2) < length(dFF)
                            trialArray=[trialArray dFF(WindowIdx(i,1):WindowIdx(i,2))];
                            
                     end
               end
               
               
           end
           fpObj(fpObjNum).idvData(mouseNum).trialArray{waveNum}=trialArray';
        end
    end
end
end