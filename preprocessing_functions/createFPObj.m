function fpObj = createFPObj()
%Load MetaData file
%% Trying new things..

file = uipickfiles('FilterSpec','*.xlsx'); %this has to search for .xlsx files
%
if iscell(file) == 0
    errordlg('Please select .xlsx files')
    fpObj = [];
    return
end
totalNumFiles = size(file,2);
%{
for numFiles = 1:totalNumFiles
    [a,name,ext] = fileparts(file(numFiles,:)); 
    pathName{numFiles} = a;
    fileName{numFiles} = [name ext];
end
%}


%[fileName, pathName, ~] = uigetfile('*.xlsx','Select the metadata.xlsx file');
%cd(pathName);

for selectedFile = 1:totalNumFiles
   fpObj(selectedFile).metaDataFile = file{1,selectedFile};
   [num, ~, metaData] = xlsread(strtrim(fpObj(selectedFile).metaDataFile));



    for i=size(metaData,1):-1:1

        if isnan(metaData{i,1})
            metaData = metaData(1:i-1,:);
        end
    end

%%
    %Create fpObj struct to store data be used following analysis
     fpObj(selectedFile).metaData = metaData;
     fpObj(selectedFile).totalMouseNum = size( fpObj(selectedFile).metaData,1)-2;
     fpObj(selectedFile).expDescription = metaData(1,2);
     fpObj(selectedFile).groupInfoArray = metaData(3:end,3);
     fpObj(selectedFile).trimmingRange = metaData(3:end,4:5);
    for mouseNum = 1: fpObj(selectedFile).totalMouseNum
        rowNum = mouseNum+2;
         fpObj(selectedFile).idvData(mouseNum).mouseID = cell2mat(metaData(rowNum,1));
         fpObj(selectedFile).idvData(mouseNum).folder = num2str(cell2mat(metaData(rowNum,2)));
         fpObj(selectedFile).idvData(mouseNum).groupInfo = cell2mat(metaData(rowNum,3));
         fpObj(selectedFile).idvData(mouseNum).trimmingRange = cell2mat(metaData(rowNum,4:5));
         fpObj(selectedFile).idvData(mouseNum).otherData = metaData(rowNum,6:end);
         fpObj(selectedFile).idvData(mouseNum).Description = cell2mat([ fpObj(selectedFile).expDescription ' ' ...
              fpObj(selectedFile).idvData(mouseNum).groupInfo ' ' num2str( fpObj(selectedFile).idvData(mouseNum).mouseID)]);
    end
    [ fpObj(selectedFile).groupInfo,  fpObj(selectedFile).groupStartingIdx,  fpObj(selectedFile).groupIdx] ...
        = unique( fpObj(selectedFile).groupInfoArray);
    [ fpObj(selectedFile).groupCount,  fpObj(selectedFile).groupIdx2] = hist( fpObj(selectedFile).groupIdx, ...
        unique( fpObj(selectedFile).groupIdx));
     fpObj(selectedFile).numGroup = length( fpObj(selectedFile).groupInfo);
end
end
