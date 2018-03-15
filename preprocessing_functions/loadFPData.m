function fpObj = loadFPData(fpObj)
%% LoadFPData
% Written by Jong Hwi Park
% 09/15/2017
% loads Dv and Wav file 

for fpObjNum = 1:size(fpObj,2)
    metaDir = fpObj(fpObjNum).metaDataFile;
    metaDir_WO_ext = fileparts(metaDir);
    cd(metaDir_WO_ext)

    for mouseNum = 1:fpObj(fpObjNum).totalMouseNum
        dataDir = strcat([metaDir_WO_ext filesep fpObj(fpObjNum).idvData(mouseNum).folder]);
        [fpObj(fpObjNum).idvData(mouseNum).RawData fpObj(fpObjNum).idvData(mouseNum).samplingRate]= Text2Array(dataDir);
        waveNum = size(fpObj(fpObjNum).idvData(1).RawData,2)-3; %3 is first three column of RawData
        fpObj(fpObjNum).waveNum = waveNum;

    end
end
end