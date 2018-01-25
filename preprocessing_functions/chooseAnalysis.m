function analysisChoice = chooseAnalysis

choice = questdlg('Would you like use to 473nm and 405nm or 473nm only?', ...
	'Analysis Choice', ...
	'473nm and 405nm','473nm only','473nm and 405nm');
%Handle response
switch choice
    case '473nm and 405nm'
        disp([choice ' coming right up.'])
        analysisChoice = 1;
    case '473nm only'
        disp([choice ' coming right up.'])
        analysisChoice = 2;
%     case 'Both'
%         disp([choice ' coming right up.'])
%         analysisChoice = 3;
end



end

%% 

