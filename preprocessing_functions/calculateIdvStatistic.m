function fpObj=calculateIdvStatistic(fpObj)
totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    totalWaveNum = fpObj(fpObjNum).waveNum;
    for mouseNum = 1:totalMouseNum
        for waveNum = 1:totalWaveNum
           array = fpObj(fpObjNum).idvData(mouseNum).trialArray{waveNum};
           meanFn = mean(array);
           steFn = std(array,0,1) / sqrt(size(array,1));
           fpObj(fpObjNum).idvData(mouseNum).mean{waveNum}=meanFn;
           fpObj(fpObjNum).idvData(mouseNum).ste{waveNum}=steFn;
           
           %for DY's optogenetic data...
           oddArray = array(1:2:end,:);
           evenArray = array(2:2:end,:);
           mean_odd = mean(oddArray,1);
           mean_even = mean(evenArray,1);
           
           ste_odd = std(oddArray,0,1) / sqrt(size(oddArray,1));
           ste_even = std(evenArray,0,1) / sqrt(size(evenArray,1));
           
           fpObj(fpObjNum).idvData(mouseNum).mean_odd = mean_odd;
           fpObj(fpObjNum).idvData(mouseNum).ste_odd = ste_odd;
           fpObj(fpObjNum).idvData(mouseNum).mean_even = mean_even;
           fpObj(fpObjNum).idvData(mouseNum).ste_even = ste_even;
        end
    end

end
end