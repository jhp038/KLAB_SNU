function fpObj = getEventWindowIdx(fpObj)
%% fpObj = getEventWindowIdx(fpObj)
%Written by Han Eol Park and Jong Hwi Park
% 02/27/2018 (date when this comment was written by PJH)
%
% get event window idx on repeat case. 
% other case need to be implemented.

totalfpObjNum = size(fpObj,2);
for fpObjNum = 1:totalfpObjNum
    totalMouseNum = fpObj(fpObjNum).totalMouseNum;
    totalWaveNum = fpObj(fpObjNum).waveNum;
    
    for mouseNum = 1:totalMouseNum
        fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx=cell(1,totalWaveNum);
       for waveNum = 1:totalWaveNum
           TTLOnIdx = fpObj(fpObjNum).idvData(mouseNum).TTLOnIdx{waveNum};
           TTLOffIdx = fpObj(fpObjNum).idvData(mouseNum).TTLOffIdx{waveNum};
           if strcmp(fpObj(fpObjNum).TTLAlign,'on')
               TTLIdx = TTLOnIdx;
%                disp('on')
           else
               TTLIdx = TTLOffIdx;
%                disp('off')
           end
           switch fpObj(fpObjNum).waveMode{waveNum}
%                case 'pulse'
%                    fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum} = ...
%                        [TTLIdx+fpObj(fpObjNum).examRangeIdx(1) TTLIdx+fpObj(fpObjNum).examRangeIdx(2)];
               case 'repeat'
                   %Caculate mean difference between TTL on and off
                   %This is needed to match the window length
                  fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum} = ...
                      [TTLIdx+fpObj(fpObjNum).examRangeIdx(1) TTLIdx+fpObj(fpObjNum).examRangeIdx(2)];
%                    fpObj.idvData(mouseNum).displayWindowIdx{waveNum} = [TTLIdx-floor(length(fpObj.timeWindow)/2) TTLIdx+floor(length(fpObj.timeWindow)/2)];
                   
%                case 'continuous'
%                    fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum} = ...
%                        [TTLIdx+fpObj(fpObjNum).examRangeIdx(1) TTLIdx+fpObj(fpObjNum).examRangeIdx(2)];
%                case 'switch'
%                    fpObj(fpObjNum).idvData(mouseNum).eventWindowIdx{waveNum} = ...
%                        [TTLIdx+fpObj(fpObjNum).examRangeIdx(1) TTLIdx+fpObj(fpObjNum).examRangeIdx(2)];
%                case 'start'
                   
               otherwise
                   error('');
           end
       end 
    end
end
end