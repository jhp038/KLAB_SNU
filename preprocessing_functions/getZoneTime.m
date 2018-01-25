function fpObj = getZoneTime(fpObj,zoneNum,varargin)
totalMouseNum = fpObj.totalMouseNum;
colVector = cell2mat(varargin);
fpObj.noldusZoneNum = zoneNum;
for mouseNum = 1:totalMouseNum
    noldusRawData = fpObj.idvData(mouseNum).noldusRawData;
    noldusTimeVectors = fpObj.idvData(mouseNum).recTime;
    colCount=1;
    display(['Calculating Zone time... / ID #', num2str(fpObj.idvData(mouseNum).mouseID)] );
    for colNum = colVector
        ExtEvent = noldusRawData(:,colNum);
        
        if ~isempty(find(ExtEvent==1))
            inZoneIdx = find(ExtEvent==1);
            
            inZoneIdxDiff = diff(inZoneIdx);
            inZoneIdxVector = [inZoneIdx(1); inZoneIdx(find(inZoneIdxDiff>1)+1)];
            outZoneIdxVector = [inZoneIdx(inZoneIdxDiff>1); inZoneIdx(end)];
            
            EventOnTimes = noldusTimeVectors(inZoneIdxVector);
            EventOffTimes = noldusTimeVectors(outZoneIdxVector);
            
            fpObj.idvData(mouseNum).noldusEventOnTimes{colCount} = EventOnTimes;
            fpObj.idvData(mouseNum).noldusEventOffTimes{colCount} = EventOffTimes;
        end
        colCount=colCount+1;
    end
    
end
end