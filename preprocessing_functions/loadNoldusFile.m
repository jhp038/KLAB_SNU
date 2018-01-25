function fpObj = loadNoldusFile(fpObj, colNum)
if colNum==0
    return;
end
filePathList = fpObj.metaData(3:end,colNum);
totalMouseNum = fpObj.totalMouseNum;
noldusRawData = cell(6,1);
% 
% for mouseNum = 1:totalMouseNum
%     disp(['Loading noldus data from : ' filePathList{mouseNum}]);
%     [currentData, text, ~]  = xlsread([pwd filesep fpObj.idvData(mouseNum).folder filesep filePathList{mouseNum}]);
%     idx = find(strcmp(text,'Trial time'));
%     fpObj.idvData(mouseNum).noldusHeader = text(idx,:);
%     fpObj.idvData(mouseNum).noldusRawData = currentData;
% end

%new version
for mouseNum = 1:totalMouseNum
    LEDOnIdx = fpObj.idvData(mouseNum).LEDOnIdx;
    disp(['Loading noldus data from : ' filePathList{mouseNum}]);
    [currentData, text, ~]  = xlsread([pwd filesep fpObj.idvData(mouseNum).folder filesep filePathList{mouseNum}]);
    idx = find(strcmp(text,'Trial time'));
    fpObj.idvData(mouseNum).noldusHeader = text(idx,:);
    %modified Raw Data's idx. Use LEDOn Idx to crop data.
    noldusRawData = currentData(LEDOnIdx(1):LEDOnIdx(end),:);
%     noldusRawData(:,1) = noldusRawData(:,1) - noldusRawData(1,1);
    fpObj.idvData(mouseNum).noldusRawData = currentData(LEDOnIdx(1):LEDOnIdx(end),:);
    
end

end