function plotBout(fpObj,saveFigures)
%initialization
%check directory and make dir if does not exists

if exist('BoutGraph') ~= 7  
    [status, msg, msgID] = mkdir('BoutGraph');
    if status == 1
        cd('BoutGraph');
    end
else 
    cd('BoutGraph');
end
left = 0;bottom = 6;width = 5;height = 4;

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
    
    %% Plotting dFF with bout
    
    
    figure('Units','inch','Position',[left bottom width+2 height],'visible','off');
    set(gcf,'renderer','Painters')

    left = left + width+2+.2;
    
    plot(timeV,dFF,'Color','k')
    hold on
    xlim([timeV(1) timeV(end)]);
    yRange = ylim;
    xRange = xlim;
    ylim([yRange(1),yRange(2)]);
    
    yValLicking = repmat(yRange(2),numLicking,1);
    %Shading licking as dark red
    %     plot(timeV(lickingIdx),yValLicking,'s','MarkerSize',2,'Color','r')
    for i = 1:numLicking
    line([timeV(lickingIdx(i)) timeV(lickingIdx(i))], [yRange(2)*9/10 yRange(2)],'Color','r')
%     set(r1, 'FaceAlpha', 0.5,'LineStyle','none');
%     uistack(r1,'up')
    end
    %Shading bout as light red
    for i = 1:size(boutIdx,1)
        r = patch([timeV(boutIdx(i,1)) timeV(boutIdx(i,2)) timeV(boutIdx(i,2)) timeV(boutIdx(i,1))], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
            [1,0,0]);
        set(r, 'FaceAlpha', 0.2,'LineStyle','none');
        uistack(r,'up')
    end
    
    
    % setting font size, title
    set(gcf,'renderer','Painters')

    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca, 'box', 'off')
    set(gcf,'Color',[1 1 1])
        set(gca,'TickDir','out'); % The only other option is 'in'

    xlabel('Time (s)')%,'FontSize',18)
    ylabel('\DeltaF/F (%)');
    title({[fpObj.idvData(numMouse).Description ' Bout'];...
        ['numLick = ' num2str(numLicking) '     numBout = ' num2str(numBout)];...
        ['Interval = ' num2str(timeWindow) 's'  '     Interlick =  >' num2str(numWindow) ' licks' ]},...
        'FontSize',10)
    
    % save
    if saveFigures =='y' || saveFigures =='Y'
        saveas(gcf,[fpObj.idvData(numMouse).Description ' Bout' '.svg'])
        saveas(gcf,[fpObj.idvData(numMouse).Description ' Bout' '.jpg'])
    end
end

if saveFigures =='y' || saveFigures =='Y'
    cd ..
end
