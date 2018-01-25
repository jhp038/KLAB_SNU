
%%
function plotauROC(fpObj,saveChoice)
totalfpObjNum = size(fpObj,2);
left = 0;bottom = 4;width = 4;height = 2;


for fpObjNum = 1:totalfpObjNum  
    timeRange = round(fpObj(fpObjNum).idvData(1).TTLOffTimes{1,1}(1,1) ...
        - fpObj(fpObjNum).idvData(1).TTLOnTimes{1,1}(1,1));
    for mouseNum = 1:fpObj(fpObjNum).totalMouseNum
        dFF = fpObj(fpObjNum).idvData(mouseNum).trialArray{1,1};
        samplingRate = round(fpObj(fpObjNum).samplingRate);
        examRange = fpObj(fpObjNum).examRange;
        examRangeIdx = fpObj(fpObjNum).examRangeIdx;
        index_pointOneSec = round(samplingRate/10);
        
        %baseline = 1sec before onset to 0sec
        %examRange = up to 20 sec
        baselineStartIdx = abs(examRangeIdx(1))-samplingRate;
        baselineEndIdx = abs(examRangeIdx(1));
        baseline = dFF(:,baselineStartIdx:baselineEndIdx);
        numBin = floor(length(dFF(1,baselineStartIdx:end))/index_pointOneSec);
        % areaUnderROC = zeros(1,numBin);
        binStart = baselineStartIdx;
        %set edges with dFF resolution of .1
        minDff = min(min(dFF)); maxDff = max(max(dFF));
        edge = minDff:.1:maxDff;
        %reference of ROC curve
        reference= 0:.1:1;
        %
        % figure
        for t =1:numBin
            %    
            
            binEnd = binStart + index_pointOneSec;
            if binEnd > size(dFF,2)
                break
            end
            r = dFF(:,binStart:binEnd);
            binStart = binEnd + 1;
            
            b = histcounts(baseline,edge,'Normalization','probability');
            r = histcounts(r,edge,'Normalization','probability');
            
            
            
            for i = 1:length(b)  %1001
                FA(i) = sum(b(1,i:length(b)));
                HIT(i) = sum(r(1,i:length(b)));
            end
            
            
            
            flip_FA = fliplr(FA);
            flip_HIT = fliplr(HIT);
            areaUnderROC(t) = trapz(flip_FA,flip_HIT);
            %Graph part. 
%             clf
%             subplot(2,1,1)
%             bar(edge(1:end-1),b,'b');
%             hold on
%             bar(edge(1:end-1),r,'r');         
%             ylim([0 .1]);
%             xlabel('dFF');
%             ylabel('density');
%             titleString = ['t =' num2str(t)];
%             title(titleString);
%             subplot(2,1,2)
%             ar = area(FA,HIT);
%              xlim([0 1])
%              ylim([0 1])
%             hold on         
%             plot(reference,reference,'color','k')
%             auROCString = ['auROC = ' num2str(areaUnderROC(t))];
%             title(auROCString);           
%             pause
        end
        %%
        figure('Units','inch','Position',[left bottom width height]);
        left = left + width/2;
        timeV = linspace(-1,20,length(areaUnderROC));
        h = imagesc(timeV,1,areaUnderROC);
        
        % hold on
        % cm = colormap(gca,'hot');
        cm = colormap(othercolor('BuDRd_18'));
        caxis([0 1]);
        hold on
        plot([0,0],ylim, 'LineStyle', '--', 'Color', [0 0 0], 'LineWidth', 1);
        plot([timeRange,timeRange],ylim, 'LineStyle', '--', 'Color', [0 0 0], 'LineWidth', 1);
        colorbar;
        
        set(gca,'YTick',0:1);
        set(gca,'linewidth',1.6,'FontSize',13,'FontName','Arial')
        set(gcf,'Color',[1 1 1])
        set(gca, 'box', 'off')
        
        xlabel('Time (s)')%,'FontSize',18)
        mouseID = num2str(fpObj(fpObjNum).idvData(mouseNum).mouseID);
        titleString = [fpObj(fpObjNum).expDescription{1} ' ' fpObj(fpObjNum).groupInfo{1} ' ' mouseID ' auROC Plot'];
        title(titleString,'FontSize',10);
        if saveChoice == 1
            saveas(gcf,[titleString '.jpg'])      
        end
    end
end
end

