function fpObj = getTimeVectors(fpObj)
%% fpObj = getTimeVectors(fpObj)
%Written by Han Heol Park and Jong Hwi Park
% 02/27/2018 (date when this comment was written by PJH)
%
% simply initializing timeVectors from trimmedRawData's first column data

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        fpObj(fpObjNum).idvData(mouseNum).timeVectors = fpObj(fpObjNum).idvData(mouseNum).trimmedRawData(:,1);
    end
end
end