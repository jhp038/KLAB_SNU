function fpObj = trimdFF_TTLOnset(fpObj)
totalMouseNum = fpObj.totalMouseNum;
for mouseNum = 1:totalMouseNum

    trimmedRawData = fpObj.idvData(mouseNum).trimmedRawData;
    dFF =  fpObj.idvData(mouseNum).dFF;
    timeVectors =  fpObj.idvData(mouseNum).timeVectors;
    offsetTimeVectors = fpObj.idvData(mouseNum).offsetTimeVectors;
    raw405 =  fpObj.idvData(mouseNum).raw405;
    raw473 =  fpObj.idvData(mouseNum).raw473;
    fitted405 =  fpObj.idvData(mouseNum).fitted405;
    
    TTLOnIdx = fpObj.idvData(mouseNum).TTLOnIdx{1,1};

    on = TTLOnIdx(1);
    off = TTLOnIdx(2);
    
    fpObj.idvData(mouseNum).trimmedRawData = trimmedRawData(on:off);
    fpObj.idvData(mouseNum).dFF=dFF(on:off);
    fpObj.idvData(mouseNum).timeVectors=timeVectors(on:off);
    fpObj.idvData(mouseNum).offsetTimeVectors=offsetTimeVectors(on:off);
    fpObj.idvData(mouseNum).raw405=raw405(on:off);
    fpObj.idvData(mouseNum).raw473=raw473(on:off);
    fpObj.idvData(mouseNum).fitted405=fitted405(on:off);
end
end