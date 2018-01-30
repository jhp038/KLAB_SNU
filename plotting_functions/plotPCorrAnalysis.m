
%%
function plotPCorrAnalysis(fpObj)

totalMouseNum = fpObj.totalMouseNum;
group_trialArray_normMean = fpObj.group_trialArray_normMean;
for mouseNum = 1:totalMouseNum
    %creating pearson correlation with z-scored fp data.
    %loading OFC and DS data.
    OFC_data  = group_trialArray_normMean{mouseNum,1};
    DS_data = group_trialArray_normMean{mouseNum,2};
    R{mouseNum}= corrcoef(OFC_data,DS_data);
    
    
    figure
    imagesc(R{mouseNum})
    
    %setting colorbar spec
    c=colorbar;
    cm = colormap(gca,jet);

    hL = ylabel(c,'r');
    set(hL,'Rotation',0,'FontSize',15);
    set(c,'Ytick',[0:1])
    set(c,'box','off')
    caxis([0 1])
    
    
    %setting figure spec
    set(gca,'TickDir','out'); % The only other option is 'in'
    set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
    set(gca,'TickLength',[0 0])
    set(gcf,'Color',[1 1 1])
    set(gca,'XTickLabel',[])
    set(gca,'Ytick',1:2)
    set(gca,'YTickLabel',{'OFC','DS'})

    title([fpObj.idvData(mouseNum).Description ' correlation matrix.jpg'],'FontSize',10)
    saveas(gcf,[fpObj.idvData(mouseNum).Description ' correlation matrix.jpg'])
    %%
end
end