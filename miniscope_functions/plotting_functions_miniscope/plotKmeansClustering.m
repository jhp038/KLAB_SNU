function plotKmeansClustering(msObj,examRange,k,iteration)

%% initialization
neuron = msObj.msData.neuron;
data_raw = neuron.C_raw;
numOfFrames = msObj.msData.numOfFrames;
numTotalNeuron = msObj.msData.numTotalNeuron;
checkBoutData = isfield(msObj,'boutData');
if checkBoutData ==1
    videoEventIdx=msObj.boutData.videoLickingIdx;
    numEvent=msObj.boutData.numTotalBout;
else
    videoEventIdx = msObj.videoShockIdx;
    numEvent = msObj.numTotalShock;
end
examRangeIdx = examRange*5;
totalExamRangeIdx = examRangeIdx(2) - examRangeIdx(1) +1;
timeV = linspace(examRange(1),examRange(2),totalExamRangeIdx);
examRangeSize = size(timeV,2);

data_raw_max = max(data_raw,[],2);
data_raw_min = min(data_raw,[],2);

max_data_raw_array = repmat(data_raw_max,[1,numOfFrames]);
min_data_raw_array = repmat(data_raw_min,[1,numOfFrames]);

data_norm =((data_raw - min_data_raw_array)./(max_data_raw_array-min_data_raw_array)-.5)*2;

%%normalize before....
%%

for neuronNum = 1: numTotalNeuron
    idx = [videoEventIdx(:,1) videoEventIdx(:,1)] + repmat(examRangeIdx,[numEvent 1]);
    %first neuron's data
    
    for i = 1:numEvent%heating num
        if idx(i,2) < numOfFrames
            df_neuron(i,:) = data_norm(neuronNum,idx(i,1):idx(i,2));
        end
    end
    mean_norm_array(neuronNum,:) = mean(df_neuron);
end

%For each neuron responsive to social contact, neuronal activities were averaged crossing trials and then normalized to the baseline 
%(averaged fluorescent intensity in 5 s before the initiation of social interaction). K-means clustering (6 clusters) was performed on this type of responses.


baselineMean = mean(mean_norm_array(:,1:abs(examRangeIdx(1))),2);
mean_norm_array = mean_norm_array - repmat(baselineMean,[1,examRangeSize]);
temparray=mean_norm_array;

%% kmeans
totalNumK =k;
[idx,~] = kmeans(temparray,totalNumK,'MaxIter',iteration);

organizedArray = [];
idxNum4cluster = [];
organized_meanArray = [];
organized_steArray=[];
legendString=[];
for k = 1:totalNumK
    one_idx = find(idx == k);
    organizedArray = [organizedArray; temparray(one_idx,:)];
    idxNum4cluster =[idxNum4cluster;size(one_idx,1)];
    organized_meanArray(k,:) =mean(temparray(one_idx,:));
    temp_std= std(temparray(one_idx,:),0,1);
    organized_steArray(k,:) = temp_std./sqrt(idxNum4cluster(k));
    legendString{k} =['K= ' num2str(k)];
end
cum_idxNum4cluster = cumsum(idxNum4cluster);

%plotting
f1 = figure('Units','inch','Position',[1 1 4 8],'Visible','on');

imagesc(timeV, 1:size(idx,1), organizedArray)
hold on
plot([0,0],ylim, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 2);
if checkBoutData == 0
    plot([1,1],ylim, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 2);
end
h = gca;
cm = colormap(gca,othercolor('BuDRd_18'));
c2 = colorbar(...
    'Location',         'eastoutside');
hL = ylabel(c2,'Normalized \DeltaF','FontSize',11);
%     set(c2,'YTick',[-3 3]);
% c2.Label.String = 'n\DeltaF';
% set(hL,'Rotation',-90);

caxis([-1 1])
% h.YTick = 1:numMouse;
xlabel('Time (s)');
ylabel('Neuron Num');
set(gcf,'Color',[1 1 1])
set(gca,...
    'linewidth',           2.0,...
    'FontSize',            11,...
    'FontName',          'Arial',...
    'TickDir',            'out',...
    'box',               'off')
xRange = xlim;
hold on
line(repmat(xRange,[size(totalNumK) 1]),[cum_idxNum4cluster+.5 cum_idxNum4cluster+.5],'LineWidth',1.2,'Color',[0 0 0])
title(['K = ' num2str(totalNumK)])
% line graph
%
export_fig(gcf,'Kmeans Clustering heatmap.jpg')
% export_fig(gcf,'Kmeans Clustering heatmap.pdf')
export_fig(gcf,'Kmeans Clustering heatmap.pdf', '-depsc', '-painters');




%% line graph
f1 = figure('Units','inch','Position',[1 1 5 3],'Visible','on');
% plot(timeV,organized_meanArray);

mseb(timeV,organized_meanArray,organized_steArray);


set(gca,'linewidth',1.6,'FontSize',11,'FontName','Arial')
set(gca, 'box', 'off')
set(gcf,'Color',[1 1 1])
ylim([-1 1]);
xlabel('Time (s)')%,'FontSize',18)
ylabel('Normalized \DeltaF');

set(gca,'TickDir','out'); % The only other option is 'in'
yRange = ylim;
legend(legendString,'Location','northeastoutside')
legend('boxoff')
if checkBoutData == 0
    r = patch([0 1 1 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
        [1,0,0]);
    set(r, 'FaceAlpha', 0.2,'LineStyle','none');
else
    hold on
    plot([0,0],ylim, 'Color','k', 'LineStyle', '--', 'LineWidth', 2);
end

export_fig(gcf,'Kmeans Clustering 2D.jpg')
export_fig(gcf,'Kmeans Clustering 2D.pdf', '-depsc', '-painters');



end

