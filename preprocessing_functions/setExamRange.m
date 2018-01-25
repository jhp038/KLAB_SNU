function fpObj = setExamRange(fpObj, examRange)
%% setExamRange
%Written by Han Heol Park
% 09/15/2017
% Recorded given examRange, time window with matching indices, and get required number of indices.

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1: totalfpObjNum
 
    fpObj(fpObjNum).examRange = examRange;
    fpObj(fpObjNum).timeWindow = examRange(1):(1/fpObj(fpObjNum).samplingRate):examRange(2);
    fpObj(fpObjNum).examRangeIdx = round(examRange*fpObj(fpObjNum).samplingRate);

end

end