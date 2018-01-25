function fpObj = setTTLAlign(fpObj,mode)
totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
    fpObj(fpObjNum).TTLAlign = mode;
end
end