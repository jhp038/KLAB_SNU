function [saveChoice savePath] = chooseSave


choice = questdlg('Would you like to save figures?', ...
	'Save Choice', ...
	'Yes','No','No');
%Handle response
switch choice
    case 'Yes'
        saveChoice = 1;
        savePath = uigetdir;
        cd(savePath)
    case 'No'
        saveChoice = 2;
        savePath = [];
end



end