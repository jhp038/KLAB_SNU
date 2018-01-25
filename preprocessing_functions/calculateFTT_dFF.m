%% calculateFTT_dFF
%Created by Jonghwi Park and Sieun Jung
%10/2/2017
%Description:

%This code reads in fpObj calculate necessary variables for plotting FTT
%test.

function fpObj = calculateFTT_dFF(fpObj)
%% Initialization
totalMouseNum = fpObj.totalMouseNum;
fpObj = readTempData(fpObj);
TempData = fpObj.TempData;
TempDataIdx = size(TempData,2);


%creating concatenated dff array
for mouseNum = 1:totalMouseNum
%     TTLOnIdx = fpObj.idvData(mouseNum).TTLOnIdx{1,1};
    dFF(mouseNum,:) = movmean(fpObj.idvData(mouseNum).dFF(1:TempDataIdx)',5);
end


%this is similar to examRangeVector
timeVector = fpObj.idvData(1).offsetTimeVectors(1:TempDataIdx)'./60;
%get mean and ste for standard error bar graph
groupmean = mean(dFF,1);
groupste = std(dFF,1) ./ sqrt(size(dFF,1));


%smoothing temp

smoothedTempData = smooth(timeVector,TempData,0.01,'rloess')';
fpObj.smoothedTempData = smoothedTempData;
fpObj.FTTdFF = dFF;
fpObj.FTTtimeVector = timeVector;
fpObj.FTTgroupmean = groupmean;
fpObj.FTTgroupste = groupste;

end