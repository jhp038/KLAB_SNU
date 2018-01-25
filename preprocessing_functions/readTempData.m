%% getTempData
%Created by Jonghwi Park and Sieun Jung
%7/5/2017
%Description:

%
%
function fpObj = readTempData(fpObj)
%%
[fileName, pathName, ~] = uigetfile('*.xlsx','Select the temperature data');
cd(pathName);
% totalMouseNum = fpObj.totalMouseNum;

%%

% folderpath = strcat(pathName, fpObj.idvData(mouseNum).folder);
TempData = xlsread(fileName,'B:B');
fpObj.TempData = TempData';
end