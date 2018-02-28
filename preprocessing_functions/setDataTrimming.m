function fpObj = setDataTrimming(fpObj,trimGuiOut)
%% fpObj = setDataTrimming(fpObj)
%Written by Han Heol Park and Jong Hwi Park
% 02/27/2018 (date when this comment was written by PJH)
%
% takes input from trimmingGui_2's output and applies the trimming range

trimmingRange = trimGuiOut.trimmingRange;
mouseNum = trimGuiOut.mouseNum;
choiceArray = trimGuiOut.choiceArray;
totalfpObjNum = size(fpObj,2);
k = size(trimmingRange,1);



for fpObjNum = totalfpObjNum:-1:1
    for j = mouseNum(fpObjNum):-1:1
        RawData_cut = fpObj(fpObjNum).idvData(j).RawData;
        
        %record choice to fpObj
        fpObj(fpObjNum).idvData(j).choice = choiceArray(k);
        
        %set trimming range in fpObj struct
        fpObj(fpObjNum).trimmingRange{j,1} = trimmingRange(k,1);
        fpObj(fpObjNum).trimmingRange{j,2} = trimmingRange(k,2);
        %set trimming range in fpObj.idvData struct
        fpObj(fpObjNum).idvData(j).trimmingRange = trimmingRange(k,:);
        %save data into excel file
        fpObj(fpObjNum).metaData(3:end,4:5) = fpObj(fpObjNum).trimmingRange;
        xlswrite(fpObj(fpObjNum).metaDataFile,fpObj(fpObjNum).metaData);
        %find 0 and erase the whole field in fpObj.idvData struct.
        if sum(fpObj(fpObjNum).idvData(j).trimmingRange) == 0
            fpObj(fpObjNum).idvData(j) = [];
            fpObj(fpObjNum).totalMouseNum = fpObj(fpObjNum).totalMouseNum - 1;
            fpObj(fpObjNum).groupCount = fpObj(fpObjNum).groupCount - 1;
            fpObj(fpObjNum).groupIdx(j) = [];
            fpObj(fpObjNum).groupInfoArray(j)=[];
        else
            fpObj(fpObjNum).idvData(j).trimmedRawData = ...
                RawData_cut((trimmingRange(k,1):trimmingRange(k,2)),:);
            
        end
        
        k = k - 1;
    end
    
end



%find if fpObj has 0 data.
for fpObjNum = totalfpObjNum:-1:1
    if fpObj(fpObjNum).totalMouseNum == 0
        fpObj(fpObjNum) = [];
    end
end



end