function fpObj = getTimeVectors(fpObj)

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        fpObj(fpObjNum).idvData(mouseNum).timeVectors = fpObj(fpObjNum).idvData(mouseNum).trimmedRawData(:,1);
    end
end
end