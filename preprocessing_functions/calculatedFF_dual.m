function fpObj = calculatedFF_dual(fpObj)

totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        trimmedRawData = fpObj(fpObjNum).idvData(mouseNum).trimmedRawData;

        %% 
        %first part
        bls1 = polyfit (trimmedRawData(:,3),trimmedRawData(:,2),1);
        y_fit_1 = polyval(bls1,trimmedRawData(:,3)); %fitted 405nm
        df_sig1 = 100*((trimmedRawData(:,2)-y_fit_1)./(y_fit_1)); % Df/f
        fpObj(fpObjNum).idvData(mouseNum).dFF(:,1) = df_sig1;
        fpObj(fpObjNum).idvData(mouseNum).raw405(:,1) = trimmedRawData(:,3);
        fpObj(fpObjNum).idvData(mouseNum).fitted405(:,1) = y_fit_1;
        fpObj(fpObjNum).idvData(mouseNum).raw473(:,1) = trimmedRawData(:,2);
        %second part
        
        bls2 = polyfit (trimmedRawData(:,5),trimmedRawData(:,4),1);
        y_fit_2 = polyval(bls2,trimmedRawData(:,5)); %fitted 405nm
        df_sig2 = 100*((trimmedRawData(:,4)-y_fit_2)./(y_fit_2)); % Df/f
        fpObj(fpObjNum).idvData(mouseNum).dFF(:,2) = df_sig2;
        fpObj(fpObjNum).idvData(mouseNum).raw405(:,2) = trimmedRawData(:,5);
        fpObj(fpObjNum).idvData(mouseNum).fitted405(:,2) = y_fit_2;
        fpObj(fpObjNum).idvData(mouseNum).raw473(:,2) = trimmedRawData(:,4);
        
        
    end
    fpObj(fpObjNum).analysisChoice = '473n405';
    
end
end