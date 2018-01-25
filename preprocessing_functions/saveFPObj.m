function saveFPObj(fpObj)

for fpObjIdx = 1:size(fpObj,2)
    metaDir = fpObj(fpObjIdx).metaDataFile;
    metaDir_WO_ext = fileparts(metaDir);
    cd(metaDir_WO_ext)
    
    % 
    
    % create folder
    [status, msg, msgID] = mkdir('');
    
    
    
    if status == 1
        cd('BoutGraph');
    end
    save('fpObj.mat','tempfpObj')
end

end