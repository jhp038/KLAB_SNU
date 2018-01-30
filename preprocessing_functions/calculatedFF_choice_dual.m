function fpObj = calculatedFF_choice_dual(fpObj)
analysisChoice = chooseAnalysis;
if analysisChoice == 1
    fpObj = calculatedFF_dual(fpObj);
elseif analysisChoice == 2
    fpObj = calculate473dFF_dual(fpObj); 
%elseif analysisChoice == 3  
end
end
%%

    