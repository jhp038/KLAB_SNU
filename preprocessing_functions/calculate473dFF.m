function fpObj = calculate473dFF(fpObj)
%This function only uses 473...

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        trimmedRawData = fpObj(fpObjNum).idvData(mouseNum).trimmedRawData;
        
        data_473 = trimmedRawData(:,2);
        dff_473 = (data_473 - median(data_473))./median(data_473)*100;%dff
        
        fpObj(fpObjNum).idvData(mouseNum).dFF = dff_473;
        fpObj(fpObjNum).idvData(mouseNum).raw473 = trimmedRawData(:,2);
    end
    fpObj(fpObjNum).analysisChoice = '473';
    
end

end