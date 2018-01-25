function fpObj = applyParameters(fpObj,factor,examRange,waveMode,alignMode)
%% applyParameters
%Written by Han Heol Park and Jong Hwi Park
% 09/15/2017
% 1.Subsamples the FP data via given factor. ex) 1017 Hz -> 101.7 Hz when subsampled by 10.
% 2.Records given examRange, time window with matching indices, and get required number of indices.
% 3.Records selected wavemode
% 4.Aligns exam Range on onset or offset

totalfpObjNum = size(fpObj,2);
availableWaveMode = {'continuous','start','repeat'};

for fpObjNum = 1: totalfpObjNum
    %% set sub sampling Rate
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    for mouseNum = 1:totalMouseNum
        fpObj(fpObjNum).idvData(mouseNum).RawData = downsample(fpObj(fpObjNum).idvData(mouseNum).RawData,factor);
    end
    fpObj(fpObjNum).samplingRate = fpObj(fpObjNum).idvData(mouseNum).samplingRate/factor;
    %% set examRange
    fpObj(fpObjNum).examRange = examRange;
    fpObj(fpObjNum).timeWindow = examRange(1):(1/fpObj(fpObjNum).samplingRate):examRange(2);
    fpObj(fpObjNum).examRangeIdx = round(examRange*fpObj(fpObjNum).samplingRate);
    
    %% set waveMode
    waveNum = fpObj(fpObjNum).waveNum;
    for i=1:waveNum
        if find(ismember(availableWaveMode,waveMode{i})==1);
        else
            error('Wave mode must be a member of following list : \n ''continuous'' ''start'' ''repeat'' ');
        end
    end
    fpObj(fpObjNum).waveMode=waveMode;
    
    %% set TTL align
    fpObj(fpObjNum).TTLAlign = alignMode;
    
end
%%
% outputString = ['#### Selected Parameters ####' ...
%     '\n Sub-samplingRate :\t' num2str(guiOut.subsamplingRate)  ...
%     '\n    Exam Range    :\t' examRange...
%     '\n    Wave Mode     :\t' guiOut.waveMode{:} ...
%     '\n    Align Mode    :\t' guiOut.alignMode...
%     '\n Trimming Option  :\t' guiOut.trimmingOption]  
% fprintf(outputString)


end