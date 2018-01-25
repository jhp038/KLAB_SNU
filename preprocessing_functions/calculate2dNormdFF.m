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
    STDdFF = fpObj.idvData(mouseNum).STDdFF;
    meandFF = fpObj.idvData(mouseNum).meandFF;
    MapWithNormDFF = (MapWithMeanDFF - meandFF)/STDdFF;
    
    fpObj.idvData(mouseNum).MapWithNormDFF = MapWithNormDFF;
    
    
end

%% JH's version
totalMouseNum = fpObj.totalMouseNum;

for mouseNum = 1:totalMouseNum
    %initialization
    intXPos = fpObj.idvData(mouseNum).intXPos;
    intYPos = fpObj.idvData(mouseNum).intYPos;
    timeVectors = fpObj.idvData(mouseNum).timeVectors;
    
    STDdFF = fpObj.idvData(mouseNum).STDdFF;
    meandFF = fpObj.idvData(mouseNum).meandFF;
    dFF = fpObj.idvData(mouseNum).dFF;
    ndFF = (dFF - meandFF)./STDdFF;
    

    %add abs(minValue)+1 
    intXPos = intXPos+abs(min(intXPos))+1;
    intYPos = intYPos+abs(min(intYPos))+1;
    %round and *10
% %     figure
%     intXPos = round(intXPos,1)*10;
%     intYPos = round(intYPos,1)*10;
    intXPos = round(intXPos);
    intYPos = round(intYPos);

    pos_occ = zeros(max(intYPos),max(intXPos));
    pos_cal = zeros(max(intYPos),max(intXPos));
%     pos_ncal = zeros(max(intYPos),max(intXPos));
    for i=1:length(intYPos)
        pos_occ(intYPos(i,1),intXPos(i))=pos_occ(intYPos(i),intXPos(i))+1;
        pos_cal(intYPos(i,1),intXPos(i))=pos_cal(intYPos(i),intXPos(i))+dFF(i);
%         pos_ncal(intYPos(i,1),intXPos(i))=pos_cal(intYPos(i),intXPos(i))+ndFF(i);
    end
    %calculate ratemate map
    cal_map=flipud(pos_cal./pos_occ);
%     ncal_map=flipud(pos_ncal./pos_occ);
    cal_map_smoothed = filter2DMatrices(cal_map,[]);
    f = figure;
    %% Visualize
    %NaN padding
    cal_map_smoothed_padded= padarray(cal_map_smoothed,[20 20],-1000,'both');
    cal_map_smoothed_padded(cal_map_smoothed_padded == -1000) = NaN;
    
    %show
    imagesc(cal_map_smoothed_padded)
    colormap('hot');
    
    %colorbar setting
    c2 = colorbar;
    c2.Label.String = '\DeltaF/F(%)';
%     c2.Box = 'off';
    %axis setting
    set(gca,...
        'linewidth',           2.0,...
        'FontSize',            15,...
        'FontName',          'Arial',...
        'box',                   'off', ...
        'xcolor',               'w',...
        'ycolor',               'w',...
        'xtick',                  [],...
        'ytick',                  [])
    %figure setting
    set(gcf,...
        'Color',                [1 1 1])

    title(strcat(fpObj.idvData(mouseNum).Description, {' heatmap JH version'}),'FontSize',10);    
    
    saveas(gcf,[fpObj.idvData(mouseNum).Description ' Heatmap JH version.jpg'])
    
    
end



end