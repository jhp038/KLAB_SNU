function plotOverlaying(fpObj,saveChoice)
%%
%Initialization
close all
screensize = get( 0, 'Screensize' );
totalfpObjNum = size(fpObj,2);
left = 0;bottom = 3;width =  4;height = 3; 
% left = 0;bottom = 6;width = 7;height = 6; % save size

meanRawConcat = [];
steRawConcat = [];
meanNormConcat = [];
steNormConcat = [];
tempColorArray = {[0 32 96]./255,[0 176 240]./255,[125 176 125]./255,[255 0 0]./255,[102 0 0]./255};
% tempColorArray = {[0 32 96]./255,[0 176 240]./255,[255 0 0]./255,[102 0
% 0]./255};
% tempColorArray = {[0 32 96]./255,[0 176 240]./255,[102 0 0]./255}; %3c
geneColorArray = {[56 87 35]./255,[146 208 80]./255,[0 176 80]./255};
neitherColorArray = {[204 102 0]./255,[0 204 102]./255,[102 0 204]./255};
lineProps.width = 2;
%data pre processing
for fpObjNum = 1:totalfpObjNum
    examRange = fpObj(fpObjNum).examRange;
    timeRange = round(fpObj(fpObjNum).idvData(1).TTLOffTimes{1,1}(1,1) ...
        - fpObj(fpObjNum).idvData(1).TTLOnTimes{1,1}(1,1));
    examRangeVector = linspace(examRange(1),examRange(2),length(fpObj(fpObjNum).timeWindow)+1);
    
    meanRawConcat = [meanRawConcat; fpObj(fpObjNum).meanRawArray];
    steRawConcat = [steRawConcat; fpObj(fpObjNum).steRawArray];
    meanNormConcat = [meanNormConcat; fpObj(fpObjNum).meanNormArray];
    steNormConcat = [steNormConcat;fpObj(fpObjNum).steNormArray];
end

%check temp vs gene data
% if fpObj(1).expDescription{1}(1) == fpObj(2).expDescription{1}(1)
if totalfpObjNum == 3
    lineProps.col = geneColorArray;
    dataType = 'gene';
    for fpObjNum = 1 : totalfpObjNum
        legendString{fpObjNum} = fpObj(fpObjNum).groupInfoArray{1,1};
    end
elseif totalfpObjNum >= 4
    
    lineProps.col = tempColorArray;
    dataType = 'temp';
    for fpObjNum = 1 : totalfpObjNum
        if strfind(fpObj(fpObjNum).expDescription{1},'4')
            legendString{fpObjNum} = sprintf('4%cC', char(176));
        elseif strfind(fpObj(fpObjNum).expDescription{1},'8')
            legendString{fpObjNum} = sprintf('8%cC', char(176));
        elseif strfind(fpObj(fpObjNum).expDescription{1},'20')
            legendString{fpObjNum} = sprintf('20%cC', char(176));
        elseif strfind(fpObj(fpObjNum).expDescription{1},'25')
            legendString{fpObjNum} = sprintf('25%cC', char(176));
        elseif strfind(fpObj(fpObjNum).expDescription{1},'32')
            legendString{fpObjNum} = sprintf('32%cC', char(176));
        elseif strfind(fpObj(fpObjNum).expDescription{1},'37')
            legendString{fpObjNum} = sprintf('37%cC', char(176));
        else
            legendString{fpObjNum} = fpObj(fpObjNum).groupInfo{1};
        end
    end
else
    lineProps.col = neitherColorArray;
    dataType = 'else';
    for fpObjNum = 1 : totalfpObjNum
        legendString{fpObjNum} = fpObj(fpObjNum).groupInfoArray{1,1};
    end
end
%%
%plotting
for i = 1:2 %for raw and normalized trace
    %i == 1, raw and i == 2, norm
    if i == 1
        meanData = meanRawConcat;
        steData  = steRawConcat;
        raw_norm = ' Raw ';
        yUnitString = '\DeltaF/F (%)';
    else
        meanData = meanNormConcat;
        steData  = steNormConcat;
        raw_norm = ' Norm ';
        yUnitString = 'n\DeltaF/F';
    end
    %% generating figure
    % full range figure
    figure('Units','inch','Position',[left bottom width height])%,'visible','off');
    left = left + width/2;
    mseb(examRangeVector,meanData,steData,lineProps,1); %PLOTTING FUNCTION
    yRange = ylim;
    xRange = xlim;
    
    %legend
    titleString = [fpObj(1).groupInfo{1} ' fullRange' raw_norm 'IntraTemp'];
    setplotSpec(titleString,yUnitString,1.6,'Arial',13,10,xRange,yRange,timeRange);
    lgd = legend(legendString(1:fpObjNum),'Location','northeastoutside');
    neworder = fpObjNum:-1:1;
    lgd.PlotChildren = lgd.PlotChildren(neworder);%reverse order
    legend('boxoff');
    
    
    
    %Save
    if saveChoice == 1
        saveas(gcf,[titleString '.jpg'])
    end
    
    
    %IR range figure
    figure('Units','inch','Position',[left bottom width height])%,'visible','off');
    left = left + width/2;
    mseb(examRangeVector,meanData,steData,lineProps,1); %PLOTTING FUNCTION
    
    %legend
    titleString = [fpObj(1).groupInfo{1} ' stimRange' raw_norm 'IntraTemp'];
    setplotSpec(titleString,yUnitString,1.6,'Arial',13,10,[0 timeRange],yRange,timeRange);  
    lgd = legend(legendString(1:fpObjNum),'Location','northeastoutside');
    neworder = fpObjNum:-1:1;
    lgd.PlotChildren = lgd.PlotChildren(neworder);%reverse order
    legend('boxoff');
 
    %Save
    if saveChoice == 1
        saveas(gcf,[titleString '.jpg'])
    end
    bottom = bottom - height-.2;
    left = 0;
end

end

