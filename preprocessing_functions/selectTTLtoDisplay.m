function fpObj = selectTTLtoDisplay(fpObj)
totalfpObjNum = size(fpObj,2);
    for fpObjNum = 1:totalfpObjNum

    totalWaveNum = fpObj.waveNum;
    dispBoolean = [];
    for waveNum = 1:totalWaveNum
       % disp(['Do you want to plot wave 1 : ' fpObj.waveTitle{1}]);
        %ans = input('Y / N : ','s');
        ans = 'y';
        if strcmp('y',lower(ans))
            dispBoolean = [dispBoolean true];
        elseif strcmp('n',lower(ans))
            dispBoolean = [dispBoolean false];
        else
            error('Answers must be Y or N');
        end
    end
    fpObj(fpObjNum).dispBoolean = dispBoolean;

    end

end