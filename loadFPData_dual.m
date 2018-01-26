function fpObj = loadFPData_dual(fpObj)
%% LoadFPData
% Written by Jong Hwi Park
% 09/15/2017
% loads Dv and Wav file 

for fpObjIdx = 1:size(fpObj,2)
    metaDir = fpObj(fpObjIdx).metaDataFile;
    metaDir_WO_ext = fileparts(metaDir);
    cd(metaDir_WO_ext)
    for mouseNum = 1:fpObj(fpObjIdx).totalMouseNum
        dataDir = strcat([metaDir_WO_ext filesep fpObj(fpObjIdx).idvData(mouseNum).folder]);
        [fpObj(fpObjIdx).idvData(mouseNum).RawData fpObj(fpObjIdx).idvData(mouseNum).samplingRate]= Text2Array(dataDir);
        waveNum = size(fpObj(fpObjIdx).idvData(1).RawData,2)-5; %3 is first three column of RawData
        fpObj(fpObjIdx).waveNum = waveNum;
    end
end
end