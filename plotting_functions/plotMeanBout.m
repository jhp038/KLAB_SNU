function plotMeanBout(fpObj)
%initialization
left = 0;bottom = 6;width = 4;height = 3;
%iterate through all mice data
totalMouseNum = fpObj.totalMouseNum;

for numMouse = 1:totalMouseNum
    figure
    hold on
    
    meanBoutDff = fpObj.idvData(numMouse).meanBoutDff;
    meanNonBoutDff = fpObj.idvData(numMouse).meanNonBoutDff;
    
    boutBar = bar(1,meanBoutDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
    nonBoutBar = bar(2,meanNonBoutDff,'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
    
    %Xlabel
    set(gca,'xtick',[])
    Labels = {'Bout', 'NonBout'}
    set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
    %Ylabel
    ylabel('\DeltaF/F (%)');
    %ylim,other stuff
    set(gcf,'Color',[1 1 1])
    set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
    title([fpObj.idvData(numMouse).Description '  bar'],'FontSize',10)
    saveas(gcf,[fpObj.idvData(numMouse).Description '  bar.jpg'])

end

end