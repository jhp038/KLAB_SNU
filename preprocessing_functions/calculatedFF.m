function fpObj = calculatedFF(fpObj)

totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        trimmedRawData = fpObj(fpObjNum).idvData(mouseNum).trimmedRawData;
        %% Trying new method
        %         fp473 = trimmedRawData(:,2);
        %         fp405 = trimmedRawData(:,3);
        %         fp473_a = fp473(fpObj.samplingRate*61:fpObj.samplingRate*180)
        %         plot(fp473_a)
        
        %%
        bls1 = polyfit (trimmedRawData(:,3),trimmedRawData(:,2),1);
        y_fit_1 = polyval(bls1,trimmedRawData(:,3)); %fitted 405nm
        df_sig1 = 100*((trimmedRawData(:,2)-y_fit_1)./(y_fit_1)); % Df/f
        fpObj(fpObjNum).idvData(mouseNum).dFF = df_sig1;
        fpObj(fpObjNum).idvData(mouseNum).raw405 = trimmedRawData(:,3);
        fpObj(fpObjNum).idvData(mouseNum).fitted405 = y_fit_1;
        fpObj(fpObjNum).idvData(mouseNum).raw473 = trimmedRawData(:,2);
    end
    fpObj(fpObjNum).analysisChoice = '473n405';
    
end
end