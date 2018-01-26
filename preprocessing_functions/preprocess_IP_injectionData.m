function fpObj = preprocess_IP_injectionData(fpObj,examRange) %this function retrim data according to TTL pulses that signal 15min window. 
%initialize
totalMouseNum = fpObj.totalMouseNum;
samplingRate = round(fpObj.samplingRate);
examRangeIdx = examRange*samplingRate;
mouseID = [];

for numMouse = 1:totalMouseNum
    %initialization
    dFF = fpObj.idvData(numMouse).dFF;
    TTLOnIdx = fpObj.idvData(numMouse).TTLOnIdx{1,1};
    %Idx
    baselineIdx = [TTLOnIdx+examRangeIdx(1) TTLOnIdx-1];
    afterIPIdx =  [TTLOnIdx TTLOnIdx+examRangeIdx(2)];
    %dFF
    baseline_dFF(numMouse,:) = dFF(baselineIdx(1):baselineIdx(2));
    afterIP_dFF(numMouse,:) =  dFF(afterIPIdx(1):afterIPIdx(2));
    total_dFF(numMouse,:) = dFF(baselineIdx(1):afterIPIdx(2));
    %mouseID for legend
    mouseID =[mouseID;fpObj.idvData(numMouse).mouseID];
end

timeV = linspace(examRange(1),examRange(2),size(total_dFF,2));
mean_total_dFF = mean(total_dFF);
ste_total_dFF = std(total_dFF,0,1)/sqrt(totalMouseNum);

%% plotting
left = 0;bottom = 2;width = 10;height = 6;%figure spec

figure('Units','inch','Position',[left bottom width height],'visible','on');
hold on
plot(timeV,total_dFF);%plotting data
plot([0 0],ylim,'--','Color','k','LineWidth',2);

xlim(examRange);
xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF/ F(%)');
set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')
set(gcf,'Color',[1 1 1])
set(gca,'TickDir','out'); % The only other option is 'in'
title(fpObj.expDescription ,'FontSize',10)
legend(num2str(mouseID),'Location','northeastoutside')

%% mean plot
left = 0;bottom = 2;width = 10;height = 6;%figure spec
figure('Units','inch','Position',[left bottom width height],'visible','on');
lineProps.width = .2;
mseb(timeV,mean_total_dFF,ste_total_dFF,lineProps);%plotting data
hold on

plot([0 0],ylim,'--','Color','k','LineWidth',2);

xlim(examRange);
xlabel('Time (s)')%,'FontSize',18)
ylabel('\DeltaF/ F(%)');
set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')
set(gcf,'Color',[1 1 1])
set(gca,'TickDir','out'); % The only other option is 'in'
title([fpObj.expDescription ' mean trace'],'FontSize',10)

end