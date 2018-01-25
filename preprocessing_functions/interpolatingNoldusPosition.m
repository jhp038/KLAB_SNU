function fpObj = interpolatingNoldusPosition(fpObj)
totalMouseNum = fpObj.totalMouseNum;
for mouseNum = 1:totalMouseNum
    disp(mouseNum);
    recTime = fpObj.idvData(mouseNum).recTime;
    recTime = recTime-recTime(1);
    fpObj.idvData(mouseNum).recTime=recTime;
 
    
    xPos = fpObj.idvData(mouseNum).xPos;
    yPos = fpObj.idvData(mouseNum).yPos;
    
    %to align via TTLOn Index, we cut Raw data and time vectors here.
    
    timeVectors = fpObj.idvData(mouseNum).timeVectors;
    timeVectors = timeVectors - timeVectors(1);
    fpObj.idvData(mouseNum).timeVectors= timeVectors; %save
    fpObj.idvData(mouseNum).intXPos = interp1(recTime,xPos,timeVectors,'linear','extrap');
    fpObj.idvData(mouseNum).intYPos = interp1(recTime,yPos,timeVectors,'linear','extrap');
    display(['synchronizing data... / ID #', num2str(fpObj.idvData(mouseNum).mouseID)] );
end
end