function setplotSpec(titleString,yUnitString,lineWidth,fontName,fontSize,titleFontSize,xRange,yRange,timeRange)
%1.6,Arial,13,10
%patch
r = patch([0 timeRange timeRange 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
    [.1,.1,.1,.1],[1,.7,.7]);
set(r, 'FaceAlpha', 0.2,'LineStyle','none');
uistack(r,'up')

set(gca,'linewidth',lineWidth,'FontSize',fontSize,'FontName',fontName)
%setting title, label, and gcf color
% xlim(examRange);
title(titleString,'FontSize',titleFontSize);

xlim([xRange(1) xRange(2)]);
xlabel('Time (s)');
ylabel(yUnitString);
% yticks([yRange(1):2:yRange(2)])
set(gcf,'Color',[1 1 1]);

end