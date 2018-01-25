function []=plotIndividualData(fpObj)
totalMouseNum = fpObj.totalMouseNum;

for mouseNum=1:totalMouseNum;
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    display('drawing individual dF/F plot...');
    
    raw473 = fpObj.idvData(mouseNum).raw473;
    raw405 = fpObj.idvData(mouseNum).raw405;
    fitted405 = fpObj.idvData(mouseNum).fitted405;
    timeVectors = fpObj.idvData(mouseNum).timeVectors;
    dFF = fpObj.idvData(mouseNum).dFF;
    trimmingRange = fpObj.idvData(mouseNum).trimmingRange;
    %%
    subplot(2,2,1);
    %plot every data before trimming and analysis window
    hold on;
    plot(fpObj.idvData(mouseNum).RawData(:,1),fpObj.idvData(mouseNum).RawData(:,2),'r');
    plot(fpObj.idvData(mouseNum).RawData(:,1),fpObj.idvData(mouseNum).RawData(:,3),'b');
    plot([trimmingRange(1)/fpObj.samplingRate trimmingRange(1)/fpObj.samplingRate], ylim, 'k');
    plot([trimmingRange(2)/fpObj.samplingRate trimmingRange(2)/fpObj.samplingRate], ylim, 'k');
    legend('473','405','Analysis Window');
    
    %%
    subplot(2,2,2);
    %Plot raw trace and fitted data between analysis window
    hold on;
    plot(timeVectors,raw473,'r');
    plot(timeVectors,raw405,'b');
    plot(timeVectors,fitted405,'g');
    legend('473','405','fitted');
    set(gca,'xlim',trimmingRange/fpObj.samplingRate);

    % dFoverF
    subplot(2,2,3); 
    hold on;
    plot(timeVectors-timeVectors(1),dFF,'b');
    legendList = {'dF/F'};
    legend(legendList);
    set(gca,'xlim',[0 length(timeVectors)/fpObj.samplingRate]);
    ax=gca;
    Ylimit = ax.YLim;
    waveToDraw = {'pulse','repeat','continuous'};
    waveColorList=[1 0 0; 1 0.5 1; 1 1 0.5];
    for waveNum = 1:fpObj.waveNum
        if find(strcmp(fpObj.waveMode{waveNum},waveToDraw),1)
            xStart = fpObj.idvData(mouseNum).TTLOnTimes{waveNum};
            xEnd = fpObj.idvData(mouseNum).TTLOffTimes{waveNum};
            for i=1:length(xStart)
                rectangle(ax,'Position', [xStart(i) Ylimit(1) xEnd(i)-xStart(i) Ylimit(2)-Ylimit(1)], 'FaceColor',waveColorList(waveNum,:),'EdgeColor','none');
            end
            plot([0 0.1],[0 0.1],'Color',waveColorList(waveNum,:));
            legendList = [legendList fpObj.waveTitle(waveNum)];
            legend(legendList);
        end   
    end
    
    plot(timeVectors-timeVectors(1),dFF,'b');
    set(ax,'layer','top');
    
    
    
%     
%     
%     
%     imagesc(RawData_cut(:,1),[1:nEvents],SessionFnData');
%     colormap(gca,customColorMap);
%     plot(RawData_cut(:,1),1+RawData_cut(:,5)*0.01,'k');
%     legend('Center');
%     xlabel('Time (s)'); ylabel('dF/F');
%     set(gca,'YTickLabel',{' '})
%     xlim([analysisWindowS(1) analysisWindowS(end)]);
%     
%     % shaded bar plot
%     subplot(2,2,4); hold on;
%     meanFn1 = mean(SessionFnData,2);
%     steFn2 = std(SessionFnData,0,2) / sqrt(size(SessionFnData,2));
%     errBarFn = [steFn2';steFn2'];
%     shadedErrorBar(analysisWindowS,meanFn1,errBarFn,'b');
%     xlim([analysisWindowS(1) analysisWindowS(end)]);
%     set(gcf,'Color',[1 1 1]);
%     xlabel('Time (s)');
%     ylabel('\DeltaF/F(%)');
    
    title(fpObj.idvData(mouseNum).Description);
    saveas(gcf,[fpObj.idvData(mouseNum).Description 'IdvPlot.png'])
end
end