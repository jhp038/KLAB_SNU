function fpObj = applyTrimmingOffset(fpObj)

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
 
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    totalWaveNum = fpObj(fpObjNum).waveNum;
    for mouseNum = 1:totalMouseNum
        trimmingOffset = fpObj(fpObjNum).idvData(mouseNum).trimmingRange(1)-1;
%         
%         trimmingRange = [fpObj(fpObjNum).trimmingRange{mouseNum,1} ...
%             fpObj(fpObjNum).trimmingRange{mouseNum,2}];
        trimmingRange = fpObj(fpObjNum).idvData(mouseNum).trimmingRange-1;
        for waveNum = 1:totalWaveNum
            fpObj(fpObjNum).idvData(mouseNum).offsetTimeVectors = fpObj(fpObjNum).idvData(mouseNum).timeVectors-trimmingOffset/fpObj(fpObjNum).samplingRate;
            trimmedTTLOnIdx = fpObj(fpObjNum).idvData(mouseNum).TTLOnIdx{waveNum};
            trimmedTTLOffIdx = fpObj(fpObjNum).idvData(mouseNum).TTLOffIdx{waveNum};
            trimmedTTLOnIdx = trimmedTTLOnIdx(trimmingRange(1)<trimmedTTLOnIdx);
            trimmedTTLOnIdx = trimmedTTLOnIdx(trimmedTTLOnIdx<trimmingRange(2));
            trimmedTTLOffIdx = trimmedTTLOffIdx(trimmedTTLOffIdx<trimmingRange(2));
            trimmedTTLOffIdx = trimmedTTLOffIdx(trimmingRange(1)<trimmedTTLOffIdx);
            fpObj(fpObjNum).idvData(mouseNum).TTLOnIdx{waveNum} = trimmedTTLOnIdx-trimmingOffset;
            fpObj(fpObjNum).idvData(mouseNum).TTLOffIdx{waveNum} = trimmedTTLOffIdx-trimmingOffset;
            fpObj(fpObjNum).idvData(mouseNum).TTLOnTimes{waveNum} = fpObj(fpObjNum).idvData(mouseNum).TTLOnTimes{waveNum}-trimmingOffset/fpObj(fpObjNum).samplingRate;
            fpObj(fpObjNum).idvData(mouseNum).TTLOffTimes{waveNum} = fpObj(fpObjNum).idvData(mouseNum).TTLOffTimes{waveNum}-trimmingOffset/fpObj(fpObjNum).samplingRate;
            fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum} = fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum}-trimmingOffset;
            %fpObj.idvData(mouseNum).displayWindowIdx{waveNum} = fpObj.idvData(mouseNum).displayWindowIdx{waveNum}-trimmingOffset;
        end
    end
end


end