function fpObj = calculate473dFF_dual(fpObj)
%This function only uses 473...

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        trimmedRawData = fpObj(fpObjNum).idvData(mouseNum).trimmedRawData;
        %first
        data_473_first = trimmedRawData(:,2);
        dff_473_first = (data_473_first - median(data_473_first))./median(data_473_first)*100;%dff
        
        fpObj(fpObjNum).idvData(mouseNum).dFF(:,1) = dff_473_first;
        fpObj(fpObjNum).idvData(mouseNum).raw473(:,1) = trimmedRawData(:,2);
        %second
        
        data_473_second = trimmedRawData(:,4);
        dff_473_second = (data_473_second - median(data_473_second))./median(data_473_second)*100;%dff
        
        fpObj(fpObjNum).idvData(mouseNum).dFF(:,2) = dff_473_second;
        fpObj(fpObjNum).idvData(mouseNum).raw473(:,2) = trimmedRawData(:,4);
        
        
        
    end
    fpObj(fpObjNum).analysisChoice = '473';
    
end

end