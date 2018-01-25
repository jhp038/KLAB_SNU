function fpObj = loomingAnalysis(fpObj)

load State.mat
%calculate 1sec's index
idx_per_sec = round(1017.253/10);
baseLineIdx = idx_per_sec*20;
%% ****************For the purpose of shock test...*********************
indexWindow = [fpObj.idvData.TTLOnIdx{1,1} fpObj.idvData.TTLOffIdx{1,1}];
indexWindow = [fpObj.idvData.TTLOnIdx{1,1} fpObj.idvData.TTLOffIdx{1,1} - 2*idx_per_sec];

State(:,4) = (State(:,2) - State(:,1))./18;



%%
totalNumLooming = length(fpObj.idvData.TTLOnIdx{1,1});
totalNumFreezing = size(State,1);
totalIndexLooming = indexWindow(1,2) - indexWindow(1,1)+1;

dFF = fpObj.idvData.dFF;


indexInfo = [];
for i = 1:totalNumLooming 
    temp_indexInfo = (State(:,3) == i)*fpObj.idvData.TTLOnIdx{1,1}(i);
    temp_indexInfo = repmat(snip(temp_indexInfo,'0'),1,2); %erasing 0
    indexInfo = [indexInfo;temp_indexInfo];
end

%%
indexInfo = indexInfo + State(:,1:2)*idx_per_sec;
indexInfo = [indexInfo State(:,3)];

% Erasing freezin Index that goes over looming disk index
for numLooming = 1:totalNumLooming
    for numFreezing  = 1:totalNumFreezing
        if indexInfo(numFreezing,3) == numLooming && ...
                indexInfo(numFreezing,1) > indexWindow(numLooming,2)
            indexInfo(numFreezing,:) = 0;
        elseif indexInfo(numFreezing,3) == numLooming && ...
                indexInfo(numFreezing,2) > indexWindow(numLooming,2)
            indexInfo(numFreezing,2) = indexWindow(numLooming,2);
        end
    end   
end
indexInfo = snip(indexInfo,'0');


totalNumFreezing = size(indexInfo,1); %re-initializing freezingNum

%% calculate freezingIndexNum and nonFreezingIndexNum
for numFreezing = 1:totalNumFreezing
    indexInfo(numFreezing,4) = indexInfo(numFreezing,2) - indexInfo(numFreezing,1) +1;
end

for numLooming = 1:totalNumLooming
    temp_indexSum = 0;
    temp_percentSum = 0;
    for numFreezing = 1:totalNumFreezing
        if indexInfo(numFreezing,3) == numLooming
            temp_indexSum = temp_indexSum + indexInfo(numFreezing,4);
            temp_percentSum = temp_percentSum + State(numFreezing,4);
        end
    end
    indexWindow(numLooming,3) = temp_indexSum;
    indexWindow(numLooming,4) = indexWindow(numLooming,2)-indexWindow(numLooming,1) + 1 - indexWindow(numLooming,3);
    fpObj.loomingData.percentTimeFreezing(numLooming,1) = temp_percentSum;
end

%% getting 

baselineWindow = 20;%sec
allBaselineDff = [];
allFreezingDff = [];
allAfterBaselineDff = [];
allNonfreezingDff = [];
allNormBaselineDff = [];
allNormFreezingDff = [];
allNormNonfreezingDff = [];
allNormAfterBaselineDff = [];

for numLooming = 1:totalNumLooming
    tempDff = []; %Freezing
    tempDff2 = []; %non Freezing
    tempDff3 = []; %base line
    tempDff4 = []; %afterbaseline
    tempDff2 = dFF(1:indexWindow(numLooming,2))';
    tempDff2(1:indexWindow(numLooming,1)-1) = 1000;
    
    for numFreezing  = 1:totalNumFreezing
        if indexInfo(numFreezing,3) == numLooming      
              tempDff = [tempDff dFF(indexInfo(numFreezing,1):indexInfo(numFreezing,2))'];
              tempDff2(indexInfo(numFreezing,1):indexInfo(numFreezing,2)) = 1000;
        end
    end  
    
    tempDff2 = snip(tempDff2,'1000');
    tempDff3 = dFF((indexWindow(numLooming,1)- baselineWindow*idx_per_sec):(indexWindow(numLooming,1)-1))';
    tempDff4 = dFF(indexWindow(numLooming,2) + 1 : indexWindow(numLooming,2) + 1 + baselineWindow*idx_per_sec)';
    
    fpObj.loomingData.baselineDff{numLooming,1} = tempDff3;
    fpObj.loomingData.freezingDff{numLooming,1} = tempDff;   
    fpObj.loomingData.nonfreezingDff{numLooming,1} = tempDff2;
    fpObj.loomingData.afterBaselineDff{numLooming,1} = tempDff4;
    
    %normalization via baseline
    fpObj.loomingData.baselineMean{numLooming,1} = mean(fpObj.loomingData.baselineDff{numLooming,1});
    fpObj.loomingData.baselineStd{numLooming,1} = std(fpObj.loomingData.baselineDff{numLooming,1},0,2); 
    
    fpObj.loomingData.normFreezingDff{numLooming,1} = (fpObj.loomingData.freezingDff{numLooming,1} - fpObj.loomingData.baselineMean{numLooming,1})...
        ./ fpObj.loomingData.baselineStd{numLooming,1};
    fpObj.loomingData.normNonfreezingDff{numLooming,1} = (fpObj.loomingData.nonfreezingDff{numLooming,1} - fpObj.loomingData.baselineMean{numLooming,1})...
        ./ fpObj.loomingData.baselineStd{numLooming,1};
    fpObj.loomingData.normBaselineDff{numLooming,1} = (fpObj.loomingData.baselineDff{numLooming,1} - fpObj.loomingData.baselineMean{numLooming,1})...
        ./ fpObj.loomingData.baselineStd{numLooming,1};
    fpObj.loomingData.normAfterBaselineDff{numLooming,1} = (fpObj.loomingData.afterBaselineDff{numLooming,1} - fpObj.loomingData.baselineMean{numLooming,1})...
        ./ fpObj.loomingData.baselineStd{numLooming,1};   
    
    %normalized freezing dff's mean(need this to see Corr)
    fpObj.loomingData.normFreezingMean(numLooming,1) = mean(fpObj.loomingData.normFreezingDff{numLooming,1});

   
    %getting mean and ste for bl, f, nf
    allBaselineDff = [allBaselineDff fpObj.loomingData.baselineDff{numLooming,1}];
    allFreezingDff = [allFreezingDff fpObj.loomingData.freezingDff{numLooming,1}];
    allNonfreezingDff = [allNonfreezingDff fpObj.loomingData.nonfreezingDff{numLooming,1}];
    allAfterBaselineDff = [allAfterBaselineDff fpObj.loomingData.afterBaselineDff{numLooming,1}];

    allNormBaselineDff = [allNormBaselineDff fpObj.loomingData.normBaselineDff{numLooming,1}];
    allNormFreezingDff = [allNormFreezingDff fpObj.loomingData.normFreezingDff{numLooming,1}];
    allNormNonfreezingDff = [allNormNonfreezingDff fpObj.loomingData.normNonfreezingDff{numLooming,1}];
    allNormAfterBaselineDff = [allNormAfterBaselineDff fpObj.loomingData.normAfterBaselineDff{numLooming,1}];
end



%% (Raw) plotting baseline, freezingdff, and non freezing dff MEAN
figure
hold on
baselineBar = bar(1,mean(allBaselineDff),'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
freezingBar = bar(2,mean(allFreezingDff),'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
nonFreezingBar = bar(3, mean(allNonfreezingDff),'EdgeColor',[0 0 0],'FaceColor',[1 1 1]);
afterBaselineBar = bar(4, mean(allAfterBaselineDff),'EdgeColor',[0 0 0],'FaceColor',[1 0 0]);

ylabel('\DeltaF/F (%)');
set(gcf,'Color',[1 1 1])

set(gca,'xtick',[])

Labels = {'Baseline', 'Freezing', 'Non Freezing','After 20Sec'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
title([fpObj.expDescription{1,1} ' ' fpObj.groupInfo{1,1} ' '...
fpObj.idvData.folder ' \DeltaF/F']);
saveas(gcf,[fpObj.expDescription{1,1} ' ' fpObj.groupInfo{1,1} ' '...
fpObj.idvData.folder 'bar dff.jpg'])


%% (Normalized) plotting baseline, freezingdff, and non freezing dff MEAN
figure
hold on
baselineBar = bar(1,mean(allNormBaselineDff),'EdgeColor',[0 0 0],'FaceColor',[0 0 1]);
freezingBar = bar(2,mean(allNormFreezingDff),'EdgeColor',[0 0 0],'FaceColor',[0 0 0]);
nonFreezingBar = bar(3,mean(allNormNonfreezingDff),'EdgeColor',[0 0 0],'FaceColor',[1 1 1]);
afterBaselineBar = bar(4, mean(allNormAfterBaselineDff),'EdgeColor',[0 0 0],'FaceColor',[1 0 0]);

ylabel('n \DeltaF/F');
set(gcf,'Color',[1 1 1])

set(gca,'xtick',[])

Labels = {'Baseline', 'Freezing', 'Non Freezing','After 20Sec'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
title([fpObj.expDescription{1,1} ' ' fpObj.groupInfo{1,1} ' '...
fpObj.idvData.folder ' normalized \DeltaF/F']);
saveas(gcf,[fpObj.expDescription{1,1} ' ' fpObj.groupInfo{1,1} ' '...
fpObj.idvData.folder 'bar normalized dff.jpg'])




end