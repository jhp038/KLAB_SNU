function fpObj = calculatedFF_choice(fpObj)
analysisChoice = chooseAnalysis;
if analysisChoice == 1
    fpObj = calculatedFF(fpObj);
elseif analysisChoice == 2
    fpObj = calculate473dFF(fpObj); 
%elseif analysisChoice == 3  
end
end
%%

    