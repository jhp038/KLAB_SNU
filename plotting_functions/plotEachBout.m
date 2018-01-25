function plotEachBout(fpObj, examRange,saveFigures)
%% Data initialization from fpObj
if exist('EachBoutGraph') ~= 7
    [status, msg, msgID] = mkdir('EachBoutGraph');
    if status == 1
        cd('EachBoutGraph');
    end
end
totalMouseNum = fpObj.totalMouseNum;
examRange = examRange;
examRangeIdx = examRange * round(fpObj.samplingRate);

for numMouse =1:totalMouseNum
    dFF = fpObj.idvData(numMouse).dFF;
    timeV = fpObj.idvData(numMouse).timeVectors;
    boutIdx = fpObj.idvData(numMouse).boutIdx;
    lickingIdx = fpObj.idvData(numMouse).lickingIdx;
    % numLicking =  fpObj.idvData(numMouse).totalNumLicking;
    numBout = fpObj.idvData(numMouse).totalNumBout;
    plotRangeIdx = [boutIdx(:,1) boutIdx(:,1)] + repmat(examRangeIdx,[size(boutIdx(:,1))]);
    %% Calculating raw and normalized dFF trace of each bout
    
    numColumns = examRangeIdx(2) - examRangeIdx(1) + 1;
    eachBoutTimeV = linspace(examRange(1), examRange(2), numColumns);
    
    eachBoutDffArray = zeros(numBout, numColumns);
    
    for boutOrder = 1 : numBout
        eachBoutDffArray(boutOrder, :) = dFF(plotRangeIdx(boutOrder,1):plotRangeIdx(boutOrder,2))';
    end
    
    % normalization
    meanEachBoutArray = repmat(mean(eachBoutDffArray(:, 1:(-examRangeIdx(1))), 2), 1, numColumns);
    stdEachBoutArray = repmat(std(eachBoutDffArray(:, 1:(-examRangeIdx(1))), 0, 2), 1, numColumns);
    eachBoutNormDffArray = (eachBoutDffArray - meanEachBoutArray)./stdEachBoutArray;
    
    % for bar plot (maybe?)
    % needs revision: whole row is not equivalent to dFF within the bout
    
    % meanEachWholeBout = mean(eachBoutDffArray, 2);
    % steEachWholeBout = std(eachBoutDffArray, 0, 2)/sqrt(size(eachBoutDffArray, 2));
    
    %% Finding indices of licks and bouts in the exam range
    
    % for finding indices and time point of contained bouts
    includedBoutIdxCell = cell(numBout, 1);
    includedBoutTimeCell = cell(numBout, 1);
    
    for boutOrder = 1 : numBout
        % for finding indices
        disp(num2str(boutOrder))
        includedBoutLogical = (boutIdx > plotRangeIdx(boutOrder, 1))&(boutIdx <= plotRangeIdx(boutOrder, 2));
        includedBoutIdx = boutIdx .* includedBoutLogical;
        includedBoutIdx(~any(includedBoutIdx, 2), :) = [];
        if includedBoutIdx(end, 2) == 0
            includedBoutIdx(end, 2) = plotRangeIdx(boutOrder, 2);
        end
        includedBoutIdxCell{boutOrder} = includedBoutIdx;
        
        % transforming indices into time points
        includedBoutTime = zeros(size(includedBoutIdx, 1), size(includedBoutIdx, 2));
        for ii = 1:size(includedBoutIdx, 1)
            for jj = 1:size(includedBoutIdx, 2)
                includedBoutTime(ii, jj) = timeV(includedBoutIdx(ii, jj));
            end
        end
        % JONGWHI !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        includedBoutTimeCell{boutOrder} = includedBoutTime;
    end
    
    % for finding indices and time point of contained licks
    includedLickingIdxCell = cell(numBout, 1);
    includedLickingTimeCell = cell(numBout, 1);
    
    for boutOrder = 1: numBout
        % for finding indices
        includedLickingLogical = ...
            (lickingIdx >= plotRangeIdx(boutOrder, 1))&(lickingIdx <= plotRangeIdx(boutOrder, 2));
        includedLickingIdx = lickingIdx(includedLickingLogical);
        includedLickingIdxCell{boutOrder} = includedLickingIdx;
        
        % transforming indices into time point
        includedLickingTime = zeros(size(includedLickingIdx, 1), 1);
        for ii = 1:size(includedLickingIdx, 1)
            includedLickingTime(ii) = timeV(includedLickingIdx(ii));
        end
        includedLickingTimeCell{boutOrder} = includedLickingTime;
    end
    
    %% Plotting raw dFF trace of each bout with overlapping bouts shaded
    for boutOrder = 1 : numBout
        left = 0;bottom = 6;width = 4;height = 3;                               % copied from plotFirstLick.m
        figure('Units','inch','Position',[left bottom width height], 'visible', 'on');           % copied from plotFirstLick.m
        left = left + width+.2;                                                             % copied from plotFirstLick.m
        
        plot(eachBoutTimeV, eachBoutDffArray(boutOrder, :),'linewidth',1.2)
        hold on
        
        set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
        set(gca, 'box', 'off')
        set(gcf,'Color',[1 1 1])
        set(gca,'TickDir','out'); % The only other option is 'in'
        
        xlabel('Time (s)')%,'FontSize',18)
        ylabel('\DeltaF/F (%)');
        
        title([fpObj.idvData(numMouse).Description ' ' iptnum2ordinal(boutOrder) ' Bout'],'FontSize',10)
        plot([0 0],ylim,'Color',[1 0 0]);
        plot([0 0],ylim,'Color',[1 0 0]);
        
        xlim([eachBoutTimeV(1) eachBoutTimeV(end)]);
        yRange = ylim;                                                          % copied from plotFirstLick.m
        xRange = xlim;                                                          % copied from plotFirstLick.m
        ylim([yRange(1),yRange(2)]);                                      % copied from plotFirstLick.m
        
        % Shading licking as dark red
        shiftedLickingTime = includedLickingTimeCell{boutOrder} - timeV(boutIdx(boutOrder, 1));
        for ii = 1:size(shiftedLickingTime, 1)
            line([shiftedLickingTime(ii) shiftedLickingTime(ii)], [yRange(2)*9/10 yRange(2)],'Color','r')
        end
        
        %Shading bout as light red
        shiftedBoutTime = includedBoutTimeCell{boutOrder} - timeV(boutIdx(boutOrder, 1));
        for ii = 1:size(shiftedBoutTime, 1)
            r = patch([shiftedBoutTime(ii,1) shiftedBoutTime(ii,2) shiftedBoutTime(ii,2) shiftedBoutTime(ii,1)],...
                [yRange(2) yRange(2) yRange(1)  yRange(1)], [1,0,0]);
            set(r, 'FaceAlpha', 0.2,'LineStyle','none');
            uistack(r,'up')
        end
        
        % save
        if saveFigures =='y' || saveFigures ~='Y'
            
            saveas(gcf,[fpObj.idvData(numMouse).Description ' ' iptnum2ordinal(boutOrder) ' Bout' '.jpg'])
            saveas(gcf,[fpObj.idvData(numMouse).Description ' ' iptnum2ordinal(boutOrder) ' Bout' '.svg'])
        end
    end
end
cd ..







