function fpObj = calculatedFF_choice(fpObj)
%% fpObj = calculatedFF_choice(fpObj)
%Written by Jong Hwi Park
% 02/27/2018 (date when this comment was written by PJH)
%
% asks for analysis choice and performs df/f calculation. 

analysisChoice = chooseAnalysis;
if analysisChoice == 1
    fpObj = calculatedFF(fpObj);
elseif analysisChoice == 2
    fpObj = calculate473dFF(fpObj); 
end
end


    