function fpObj=calculateMeanandSTDofdFF(fpObj)
% Get Recording Time, X center, Y center, Velocity from the noldus RawData
% Additional data can be extracted from the
% fpObj.idvData(mouseNum).noldusRawData

totalMouseNum = fpObj.totalMouseNum;
for mouseNum=1:totalMouseNum
fpObj.idvData(mouseNum).meandFF = mean(fpObj.idvData(mouseNum).dFF);
fpObj.idvData(mouseNum).STDdFF = std(fpObj.idvData(mouseNum).dFF);
end

end