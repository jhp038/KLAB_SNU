function plotBarEachBout(fpObj)

totalMouseNum = fpObj.totalMouseNum;

[status, msg, msgID] = mkdir('BarGraph');
if status == 1
    cd('BarGraph');
end
for numMouse = 1:totalMouseNum
    %% bar graph
    %initialize for each mouse
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    totalNumBout = fpObj.idvData(numMouse).totalNumBout;
    dFF = fpObj.idvData(numMouse).dFF; 
    meanBoutDff = [];
    hozconcatDff = [];
    hozconcat_nonDff = [];
    for boutNum = 1:totalNumBout
        meanBoutDff(boutNum,1) = mean(dFF(boutIdx(boutNum,1):boutIdx(boutNum,2)));
        steBoutDff(boutNum,1) = std(dFF(boutIdx(boutNum,1):boutIdx(boutNum,2)),0,1)/length(dFF(boutIdx(boutNum,1):boutIdx(boutNum,2)));
        hozconcatDff = [hozconcatDff dFF(boutIdx(boutNum,1):boutIdx(boutNum,2))'];
        hozconcat_nonDff = (sum(dFF) - sum(hozconcatDff)) / (size(dFF,1) - size(hozconcatDff,2));
    end
    
    meanDff = mean(hozconcatDff);
    meanNonDff = mean(hozconcat_nonDff);
    figure
    boutBar = bar(1,meanDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    hold on
    nonBoutBar = bar(2,meanNonDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
    
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Bout', 'NonBout'};
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF/F (%)');
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    set(gca,'box','off')
    set(gca,'TickDir','out'); % The only other option is 'in'
    
    
    title([fpObj.idvData(numMouse).Description '  bar'],'FontSize',6)
    saveas(gcf,[fpObj.idvData(numMouse).Description '  bar.jpg'])
    
    
    %%
    
    figure
    hold on
    bar(meanBoutDff)
    xlabel('Bout Number');    
    ylabel('\DeltaF/F (%)');
    xlim([0 totalNumBout+1])
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial','box','off')
    title({[fpObj.idvData(numMouse).Description ' bout bar'];...
        ['numBout = ' num2str(totalNumBout)]}, 'FontSize',10)
    hold off
    saveas(gcf,[fpObj.idvData(numMouse).Description ' bout bar.jpg'])
    %% Linear Regression
    x = 1:totalNumBout;
    y = meanBoutDff';
    % get regression coefficient
    p = polyfit(x,y,1);
    yfit = polyval(p,x);
    yresid = y - yfit;

    SSresid = sum(yresid.^2);
    SStotal = (length(y)-1) * var(y);
    rsq = 1 - SSresid/SStotal;
    r = round(corrcoef(x,y),2);%pearson cor

    %standard error
    
    
    %plot
    figure
    plot(x,y,'o')    
    hold on

    plot(x,yfit);
    %graph spec
    xlim([.5 totalNumBout+.5])
    xlabel('Bout Number');
    ylabel('\DeltaF/F (%)');
    
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial','box','off')
    
    dim = [.7 .5 .3 .4];
    str = ['pearson cor = ' num2str(r(1,2))];
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    
    title({[fpObj.idvData(numMouse).Description ' correlation'];...
        ['numBout = ' num2str(totalNumBout)]}, 'FontSize',10)
    saveas(gcf,[fpObj.idvData(numMouse).Description ' bout correlation.jpg'])

end


end