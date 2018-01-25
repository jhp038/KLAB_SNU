function fpObj = setSamplingRate(fpObj,samplingRate)
totalfpObjNum = size(fpObj,2);
%Set samplingRate
for fpObjNum = 1:totalfpObjNum
    fpObj(fpObjNum).samplingRate = samplingRate;
end
disp(['Sampling Rate is setted : ' num2str(samplingRate) ' Hz']);

end