function saveFPObj(fpObj)
%% fpObj = saveFPObj(fpObj)
%Written Jong Hwi Park
% 02/27/2018
%
%  saves processed fpObj data in a directory .
totalfpObjNum = size(fpObj,2);
processed_list = dir('*processed*');

if size(processed_list,1) < 1
    %no previous iteration.
    fprintf (['There is no previous run on this data. Would you like to save the processed fpObj?\n'])
    choice = input('[y / n]\n','s');
else
    %there is previous iteration. would u like to save?
    fprintf(['There is(are) ' num2str(size(processed_list,1))  ' run on this data. Would you like to save the processed fpObj?\n']);
    choice = input('[y / n]\n','s');
end

if choice == 'y'
    %change save status to 1
    fpObj(1).loaded = 1;
    
    listing = dir('*processed*');
    fpObjNum = 1;
    metaDir = fpObj(fpObjNum).metaDataFile;
    metaDir_WO_ext = fileparts(metaDir);
    cd(metaDir_WO_ext)
    
    %export clock data to name dirctory
    timeV = datestr(now, 'yymmdd_HHMM');    % create folder
    dirName = ['processed_' timeV];
    [status, ~, ~] = mkdir(dirName);
    if status
        cd(dirName)
    end
    
    if totalfpObjNum == 1
        save(['fpObj_' timeV '.mat'],'-struct','fpObj')
    else
        save(['fpObj_' timeV '.mat'],'fpObj')
    end
    fprintf(['##### fpObj is successfully saved at : ' dirName ' #####\n'])
    %     cd ..
else
    fprintf (['fpObj is not saved. \n'])
end
end

