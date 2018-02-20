function plotBoutGraph(fpObj)


totalMouseNum = fpObj.totalMouseNum;
timeWindow =fpObj.timeWindow;
numWindow = fpObj.numWindow;
for numMouse = 1:totalMouseNum
    %initialization
    dFF = fpObj.idvData(numMouse).dFF;
    timeV = fpObj.idvData(numMouse).timeVectors;
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    lickingIdx = fpObj.idvData(numMouse).lickingIdx;
    numLicking =  fpObj.idvData(numMouse).totalNumLicking;
    numBout = fpObj.idvData(numMouse).totalNumBout;
    timeV_paraStim = fpObj.timeV;
    
    meanFirstBout =fpObj.idvData(numMouse).meanFirstBout;
    steFirstBout =fpObj.idvData(numMouse).steFirstBout;
    
    meanNormFirstBout = fpObj.idvData(numMouse).meanNormFirstBout;
    steNormFirstBout = fpObj.idvData(numMouse).steNormFirstBout;
    
    
    %% Plotting dFF with bout
    subplot (4,2,1:2)
    plotGraph(timeV,dFF,'xLabel','Time(s)','yLabel','df')

    set(gcf,'renderer','Painters')
    yRange = ylim;
    yValLicking = repmat(yRange(2),numLicking,1);
    
    %Shading licking as dark red
    for i = 1:numLicking
    line([timeV(lickingIdx(i)) timeV(lickingIdx(i))], [yRange(2)*9/10 yRange(2)],'Color','r')
    end
    %Shading bout as light red
    for i = 1:size(boutIdx,1)
        r = patch([timeV(boutIdx(i,1)) timeV(boutIdx(i,2)) timeV(boutIdx(i,2)) timeV(boutIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    title({[fpObj.idvData(numMouse).Description ' Bout'];...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numBout)];...
        ['Interval = ' num2str(timeWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',10)
    %% normalized firstlick
        subplot (4,2,3)

        plotGraph(timeV_paraStim,meanNormFirstBout,steNormFirstBout,'xLabel','Time(s)','yLabel','zscore','stimRange',8)

    
    %% normalized laslick
    
    
end
