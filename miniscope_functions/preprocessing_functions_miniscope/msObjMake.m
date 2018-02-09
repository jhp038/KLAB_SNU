function msObj = msObjMake

fileNames = uipickfiles('REFilter','\.mat$|\.dat$|\.txt$|\.xlsx$');
checkRawData = 0;
frameRate = 5;
%loading files
% nameString = '01202018 feeding 933'
for numFIles = 1:size(fileNames,2)
    [pathstr,name,ext] = fileparts(fileNames{1,numFIles}) ;
    switch ext       
        case '.dat'            
            cd(pathstr)
            fid = fopen([name ext],'r');
            datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1);
            fclose(fid);
            raw_timeV = datacell{1,3};%%
            raw_timeV(isnan(raw_timeV)) = [];
            raw_timeV = raw_timeV./1000;
            msObj.msData.timeStamp = raw_timeV; 
            
        case '.txt'
            cd(pathstr)
            if checkRawData == 0
                [RawData samplingRate] = Text2Array_miniscope(pathstr);
                checkRawData = 1;       
                msObj.wavData.RawData = RawData;
                msObj.wavData.samplingRate = samplingRate;
            end
            
        case '.mat'     
            cd(pathstr)
            load([name ext]);
            msObj.msData.neuron = neuron;
            msObj.msData.numTotalNeuron = size(neuron.C_raw,1);
            msObj.msData.numOfFrames = size(neuron.C_raw,2);
        case '.xlsx'
            cd(pathstr)
            [num,txt,raw] = xlsread([name ext]);
            msObj.medData.num = num;
            msObj.medData.txt = txt;
            msObj.medData.raw = raw;
    end
end

end
