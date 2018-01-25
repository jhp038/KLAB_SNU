function fpObj = getFPDataIdx(fpObj)
totalMouseNum = fpObj.totalMouseNum;
totalZoneNum = fpObj.noldusZoneNum;
for mouseNum = 1:totalMouseNum
    display(['Calculating Zone normalized dFF... / ID #', num2str(fpObj.idvData(mouseNum).mouseID)] );
    offsetTimeVectors = fpObj.idvData(mouseNum).offsetTimeVectors;

    STDdFF = fpObj.idvData(mouseNum).STDdFF;
    meandFF = fpObj.idvData(mouseNum).meandFF;
    totaldFF = fpObj.idvData(mouseNum).dFF;
    outZoneNum = length(totaldFF);
    outZoneSum = sum(totaldFF);
    
    for zoneNum = 1:totalZoneNum
        zonedFF=[];
        EventOnTimes = fpObj.idvData(mouseNum).noldusEventOnTimes{zoneNum};
        EventOffTimes = fpObj.idvData(mouseNum).noldusEventOffTimes{zoneNum};
        
        OnIntTimeVector = interp1(offsetTimeVectors,offsetTimeVectors,EventOnTimes,'nearest','extrap');
        OffIntTimeVector = interp1(offsetTimeVectors,offsetTimeVectors,EventOffTimes,'nearest','extrap');
        
        for i=1:length(OnIntTimeVector)
            OnTimeIdx = find(offsetTimeVectors==OnIntTimeVector(i));
            OffTimeIdx = find(offsetTimeVectors==OffIntTimeVector(i));
            extracteddFF=totaldFF(OnTimeIdx:OffTimeIdx);
            zonedFF = [zonedFF; extracteddFF];
        end
        
        zoneAverage = mean(zonedFF);
        NormalizedZonedFF = (zoneAverage - meandFF)/STDdFF;
        fpObj.idvData(mouseNum).NormalizedZonedFF{zoneNum} = NormalizedZonedFF;
        fpObj.idvData(mouseNum).zoneAveragedFF{zoneNum} = zoneAverage;
        
        outZoneNum = outZoneNum - length(zonedFF);
        outZoneSum = outZoneSum-sum(zonedFF);
    end
    % To calculate out zone dFF
    fpObj.idvData(mouseNum).NormalizedZonedFF{zoneNum+1} = (outZoneSum/outZoneNum-meandFF)/STDdFF;
end
end