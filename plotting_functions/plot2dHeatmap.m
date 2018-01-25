function []=plot2dHeatmap(fpObj)
totalMouseNum = fpObj.totalMouseNum;
for iMouse = 1:totalMouseNum;
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    display(['plotting Heatmap... / ID #', num2str(fpObj.idvData(iMouse).mouseID)] );
    
    colormap('hot');
    imagesc(fpObj.idvData(iMouse).MapWithNormDFF);
    ax=gca;
    ax.XTick = [];
    ax.YTick = [];
    colorbar;
    title(strcat(fpObj.idvData(iMouse).Description, {'heatmap'}));    
    
    saveas(gcf,[fpObj.idvData(iMouse).Description 'Heatmap.png'])
    
%     subplot(1,2,2);
%     hold on;
%     bar(Result(iMouse).NormArmDatastd, 0.5);
%     Labels = {'Center' 'Surround'};
%     set(gca,'Xtick', 1:2, 'XTickLabel', Labels);
%     title(strcat({'Normalized dF/F'}));
%     ylabel('Normalized dF/F')
    
%     filename = [Result(iMouse).Experiment,'_',Result(iMouse).Group,'_',num2str(Result(iMouse).MouseID), '_heatmap']
%     saveas(gcf,[filename,'.jpg']);
end
end