function fpObj=getNoldusPosition(fpObj)
% Get Recording Time, X center, Y center, Velocity from the noldus RawData
% Additional data can be extracted from the
% fpObj.idvData(mouseNum).noldusRawData
noldusHeader = fpObj.idvData(1).noldusHeader;
totalMouseNum = fpObj.totalMouseNum;
for mouseNum=1:totalMouseNum
    idvData = fpObj.idvData(mouseNum);
    recIdx = find(ismember(noldusHeader,'Recording time'));
    
    xPosIdx = find(ismember(noldusHeader,'X center'));
    yPosIdx =find(ismember(noldusHeader,'Y center'));
    velIdx = find(ismember(noldusHeader,'Velocity'));
    tempNoldusRawData = idvData.noldusRawData;
    
    % Find and remove row with NaN
    [row ~] = find(isnan(tempNoldusRawData));
    tempNoldusRawData(row,:)=[];
    
    fpObj.idvData(mouseNum).recTime = tempNoldusRawData(:,recIdx);
    fpObj.idvData(mouseNum).xPos = tempNoldusRawData(:,xPosIdx);
    fpObj.idvData(mouseNum).yPos = tempNoldusRawData(:,yPosIdx);
    fpObj.idvData(mouseNum).velocity = tempNoldusRawData(:,velIdx);
end

end