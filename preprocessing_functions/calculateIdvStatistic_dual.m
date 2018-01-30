function fpObj=calculateIdvStatistic_dual(fpObj)
totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    
    totalMouseNum = fpObj.totalMouseNum;
    totalWaveNum = fpObj.waveNum;
    for mouseNum = 1:totalMouseNum
        for waveNum = 1:totalWaveNum
            for numdFF = 1:2
                array = fpObj.idvData(mouseNum).trialArray{waveNum,numdFF};
                meanFn = mean(array);
                steFn = std(array,0,1) / sqrt(size(array,1));
                fpObj.idvData(mouseNum).mean{waveNum,numdFF}=meanFn;
                fpObj.idvData(mouseNum).ste{waveNum,numdFF}=steFn;
                
%                 %for DY's optogenetic data...
%                 oddArray = array(1:2:end,:);
%                 evenArray = array(2:2:end,:);
%                 mean_odd = mean(oddArray,1);
%                 mean_even = mean(evenArray,1);
%                 
%                 ste_odd = std(oddArray,0,1) / sqrt(size(oddArray,1));
%                 ste_even = std(evenArray,0,1) / sqrt(size(evenArray,1));
%                 
%                 fpObj.idvData(mouseNum).mean_odd(numdFF) = mean_odd;
%                 fpObj.idvData(mouseNum).ste_odd(numdFF) = ste_odd;
%                 fpObj.idvData(mouseNum).mean_even(numdFF) = mean_even;
%                 fpObj.idvData(mouseNum).ste_even(numdFF) = ste_even;
            end
        end
    end
    
end
end