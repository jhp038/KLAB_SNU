function fpObj = calculate2dMeandFF(fpObj)

totalMouseNum = fpObj.totalMouseNum;

for mouseNum = 1:totalMouseNum
    
    intXPos = fpObj.idvData(mouseNum).intXPos;
    intYPos = fpObj.idvData(mouseNum).intYPos;
    timeVectors = fpObj.idvData(mouseNum).timeVectors;
    dFF = fpObj.idvData(mouseNum).dFF;
    
    leftend = -(max(abs(min(intXPos)),abs(max(intXPos)))+3);
    lowerend = -(max(abs(min(intYPos)),abs(max(intYPos)))+3);
    
    y = floor(lowerend):1:ceil(-lowerend);
    x = floor(leftend):1:ceil(-leftend);
    
    assignedRow = round(length(y)-(intYPos-lowerend))+1;
    assignedCol = round(intXPos-leftend)+1;
    
    Map = zeros(length(y),length(x));
    MapCount = zeros(length(y),length(x));
    MapWithMeanDFF = nan(length(y),length(x));
    
    display(['calculating dFF on ElevatedPlusMaze... / ID #', num2str(fpObj.idvData(mouseNum).mouseID)] );
    
    for i = 1:length(timeVectors);
        Map(assignedRow(i),assignedCol(i)) = Map(assignedRow(i),assignedCol(i))+dFF(i);
        MapCount(assignedRow(i),assignedCol(i)) = MapCount(assignedRow(i),assignedCol(i))+1;
    end
    
    for space = 1:length(y)*length(x);
        MapWithMeanDFF(space) = Map(space)/MapCount(space);
    end
    
    
    
    fpObj.idvData(mouseNum).MapWithMeanDFF = MapWithMeanDFF;
    
end
end