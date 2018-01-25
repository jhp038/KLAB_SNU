function  plotCorrelation( fpObj )
%%
figure
x = fpObj.loomingData.percentTimeFreezing;
y = fpObj.loomingData.normFreezingMean;
x = snip(x,'0');
y(isnan(y)) = 0; 
y = snip(y,'0');


plot(x,y,'*')
xlim([0 1])
ylim([min(y)-1 max(y)+1])

P = polyfit(x,y,1);
yfit = P(1)*x+P(2);
hold on;
plot(x,yfit,'r-');

xlabel('Freezing Duration (%)')
ylabel('n \DeltaF/F (%)'); 


title([fpObj.expDescription{1,1} ' ' fpObj.groupInfo{1,1} ' '...
fpObj.idvData.folder ' n\DeltaF/F vs Freezing Duration %']);
saveas(gcf,[fpObj.expDescription{1,1} ' ' fpObj.groupInfo{1,1} ' '...
fpObj.idvData.folder ' ndff vs Freezing Duration.jpg'])


end

