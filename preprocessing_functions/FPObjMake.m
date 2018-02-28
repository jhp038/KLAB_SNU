function fpObj = FPObjMake
%% FPObjMake
% Written by Jong Hwi Park
% 09/15/2017
% Creates fpObj (createFPObj)
% and loads Dv and Wav file (loadFPData)

disp(['Please choose metadata.xlsx file']);

fpObj = checkFPObj;


if isempty(fpObj)
    return
end
%Load data


% saveFPObj(fpObj);


end