function fpObj = preprocess_IP_injectionData(fpObj,examRange) %this function retrim data according to TTL pulses that signal 15min window. 
%initialize
totalMouseNum = fpObj.totalMouseNum;
samplingRate = round(fpObj.samplingRate);
examRangeIdx = examRange*samplingRate;

timeV = linspace(-60,900,274665+6120+1);

for numMouse = 1:totalMouseNum
    dFF = fpObj.idvData(numMouse).dFF;
    
    TTLOnIdx = fpObj.idvData(numMouse).TTLOnIdx{1,1};
%     TTLOffIdx = fpObj.idvData(numMouse).TTLOffIdx{1,1};
    
    baselineIdx = [TTLOnIdx+examRangeIdx(1) TTLOnIdx-1];
    afterIPIdx =  [TTLOnIdx TTLOnIdx+examRangeIdx(2)];
    
    baseline_dFF(numMouse,:) = dFF(baselineIdx(1):baselineIdx(2));
    afterIP_dFF(numMouse,:) =  dFF(afterIPIdx(1):afterIPIdx(2));
    
end

numMouse = 4
plot(timeV,[baseline_dFF{numMouse}' afterIP_dFF{numMouse}']);




end