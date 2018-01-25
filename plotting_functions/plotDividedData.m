function []=plotDividedData(fpObj)
totalMouseNum = fpObj.totalMouseNum;

for mouseNum=1:totalMouseNum
    timeVectors = fpObj.idvData(mouseNum).timeVectors;
    dFF = fpObj.idvData(mouseNum).dFF;
    OnIdx = fpObj.idvData(mouseNum).TTLOnIdx(1);
    OffIdx = fpObj.idvData(mouseNum).TTLOffIdx(1);
    timeVectors_Veh = timeVectors(1:OffIdx{1,1}(1)-OnIdx{1,1}(1));
    timeVectors_Cap = timeVectors(OnIdx{1,1}(2)-OnIdx{1,1}(1):OffIdx{1,1}(2)-OnIdx{1,1}(1));
    dFF_Veh = dFF(1:OffIdx{1,1}(1)-OnIdx{1,1}(1));
    dFF_Cap = dFF(OnIdx{1,1}(2)-OnIdx{1,1}(1):OffIdx{1,1}(2)-OnIdx{1,1}(1));
    % trimmingRange의 1항을 더해줘야 할 듯;;
    figure;
    hold on;
    display('drawing individual dF/F plot...');
    plot(timeVectors_Veh-timeVectors_Veh(1),dFF_Veh,'b')
    plot(timeVectors_Cap-timeVectors_Cap(1),dFF_Cap,'r')
    legend('Vehicle', 'Capsaicin');
    set(gca,'xlim',[0 length(timeVectors_Veh)/fpObj.samplingRate]);
    ax=gca;
    Ylimit = ax.YLim;
    title(fpObj.idvData(mouseNum).Description);
end
end

