  function fpObj = setWaveMode(fpObj,waveMode)
%% setWaveMode
%Written by Han Heol Park
% 09/15/2017
% Recorded selected wavemode

availableWaveMode = {'continuous','start','repeat'};

totalfpObjNum = size(fpObj,2);

for fpObjNum = 1:totalfpObjNum
    %fpObj(fpObjNum).availableWaveMode = {'continuous','start','repeat'};
    %calculating wave Number
    waveNum = fpObj(fpObjNum).waveNum;
    for i=1:waveNum
       if find(ismember(availableWaveMode,waveMode{i})==1);
       else
           error('Wave mode must be a member of following list : \n ''continuous'' ''start'' ''repeat'' ');
       end
    end

    fpObj(fpObjNum).waveMode=waveMode;
end
end