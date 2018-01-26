function fpObj = FPObjMake
%% FPObjMake 
% Written by Jong Hwi Park
% 09/15/2017
% Creates fpObj (createFPObj)
% and loads Dv and Wav file (loadFPData) 


close all
clear all
disp(['Loading FP data']);
fpObj = createFPObj;

if isempty(fpObj)
    return
end
%Load data
tic;
fpObj = loadFPData_dual(fpObj);
disp(['Finished loading data']);
toc;

% saveFPObj(fpObj);


end