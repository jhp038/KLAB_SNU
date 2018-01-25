%% Read in file
clear all;clc
[filename,PathName,FilterIndex] = uigetfile('*.xlsx','Select the excel  file');
cd(PathName)
[data,txt,raw] = xlsread(filename);
xlimRange = [-50 1550];
ylimRange = [0 2000];
markerSize = 6;
%% Initialize variable

mouseNumber = data(1,:);
lineWidth = 1.6; fontName = 'Arial';fontSize = 16;

info =  txt(5:6,2:end);

ctrl_idx = find(strcmp(info(2,:), 'Ctrl'));
exp_idx = find(strcmp(info(2,:), 'ChR2'));

%after seperating experiment group, now we divide into bi and uni
exp_bi_idx = exp_idx(find(strcmp(info(1,exp_idx),'bi')));
exp_uni_idx =  exp_idx(find(strcmp(info(1,exp_idx),'uni')));

%% Lets do it with the first mouse
for z = 1:3
    edges = [0:150:xlimRange(2)-50];
    waterData=[];
    saltData=[];
    %lets start with ctr
    
    % ctrl_idx exp_bi_idx exp_uni_idx
    if z ==1
        temp = ctrl_idx;
        titleString = [filename '  ctrl'];
    elseif z== 2
        temp = exp_bi_idx;
        titleString = [filename '  bi'];     
    else
        temp =  exp_uni_idx;
        titleString = [filename '  uni'];      
    end
    
    numTemp = size(temp,2);
    figure('Units','inch','Position',[3 3 4 3])%,'visible','off');
    
    for num = 1:numTemp;
        
        mouseNum = temp(num);
        
        for i = 1:2
            lickData = data(:,mouseNum);
            numLeftLick = lickData(9,1);
            numRightLick = lickData(10,1);
            leftTimeData = lickData(13:13+numLeftLick-1);
            rightTimeData = lickData(5015:5015+numRightLick-1);
            
            %first and last lick time
            
            if i == 1 %water
                timeData = leftTimeData;
                lineColor = 'b';
                [N] = histcounts(timeData,edges);
                edges_Xtick =[edges];%(2:end) - mean(edges(1:2))];
                N = [0 N]; %This will be used as X
                cumulative_lickNum = cumsum(N); %This will be used as Y
                waterData(mouseNum,:) = cumulative_lickNum;
            else %salt
                timeData = rightTimeData;
                lineColor = 'r';
                [N] = histcounts(timeData,edges);
                edges_Xtick =[edges];%(2:end) - mean(edges(1:2))];
                N = [0 N]; %This will be used as X
                cumulative_lickNum = cumsum(N); %This will be used as Y
                saltData(mouseNum,:) = cumulative_lickNum;
            end
            %plot
            plot(edges_Xtick,cumulative_lickNum,'Color',lineColor,'lineWidth',1.6)
            set(gca,'XTick',edges)
            set(gca,'XtickLabelRotation',45);
            hold on
            
        end
        
        %legend
        lgd = legend({'Water','Salt'},'Location','northwest');
        legend('boxoff')
        neworder = 2:-1:1;
        lgd.PlotChildren = lgd.PlotChildren(neworder);%reverse order
        %label and title
        xlabel('Time (s)');
        ylabel('Cumulative Lick');
%         titleString = ['Mouse number  ' num2str(mouseNumber(num))];
        xlim(xlimRange);
        %plotSpec
        set(gca,'linewidth',lineWidth,'FontSize',fontSize,'FontName',fontName)
        set(gcf,'Color',[1 1 1]);
        set(gca,'box','off')
        set(gca,'TickDir','out'); % The only other option is 'in'
        set(gca,'XtickLabelRotation',45);
        title([titleString ' OL n=' num2str(numTemp)],'FontSize',7) %title
        xlim(xlimRange);
        ylim(ylimRange)
%         set(gca,'XTickLabel',[])


        hold on
        
    end
    export_fig([titleString ' Overlaid'],'-jpg')
    saveas(gcf,[titleString ' Overlaid' '.svg'])

    %% get mean and ste
    %initialization
    sumSaltData = sum(saltData,2);
    sumWaterData = sum(waterData,2);
    saltData(find(sumSaltData == 0),:) =[];
    waterData(find(sumWaterData == 0),:) =[];
    
    
    meanSalt = mean(saltData,1);
    meanWater = mean(waterData,1);
    steSalt = std(saltData)./sqrt(numTemp);
    steWater = std(waterData)./sqrt(numTemp);
    
    if z ==1 %ctrl
        ctrl_saltData = meanSalt;
        ctrl_steSalt = steSalt;
        ctrl_waterData = meanWater;
        ctrl_steWater = steWater;
    elseif z== 2 %bi
        bi_saltData = meanSalt;
        bi_steSalt = steSalt;
        bi_waterData = meanWater;
        bi_steWater = steWater;
    else %uni
        uni_saltData = meanSalt;
        uni_steSalt = steSalt;
        uni_waterData = meanWater;
        uni_steWater = steWater;
    end
    
    figure('Units','inch','Position',[3 3 4 3])%,'visible','off');
    
    for i = 1:2
        if i == 1
            meanData = meanSalt;
            steData = steSalt;
            lineColor = 'r';
            marker = 'o';
        else
            meanData = meanWater;
            steData = steWater;
            lineColor = 'b';
            marker = 'd';
        end
        
        if numTemp == 1
            plot(edges,meanData,'Color',lineColor,'lineWidth',1.6)
            hold on
        else
            errorbar(edges,meanData,steData,...
                'Marker',marker,'MarkerFaceColor',lineColor,'MarkerSize',markerSize,...
                'Color',lineColor,'lineWidth',1.6)
            hold on
        end
    end
    
    %legend
    legend({'Salt','Water'},'Location','northwest');
    legend('boxoff')
    
    %label and title
    xlabel('Time (s)');
    ylabel('Cumulative Lick');
    % title(') %title
    %plotSpec
    set(gca,'linewidth',lineWidth,'FontSize',fontSize,'FontName',fontName)    
    set(gca,'XTick',edges)
    set(gca,'XtickLabelRotation',45);    
    set(gcf,'Color',[1 1 1]);
    set(gca,'box','off')
    set(gca,'TickDir','out'); % The only other option is 'in'
    title([titleString ' SEM  n=' num2str(numTemp)],'FontSize',7) %title
    
    xlim(xlimRange);
    ylim(ylimRange)
%     xticks([0 150 300 450 600 750 900 1050 1200])

    export_fig([titleString ' SEM'],'-jpg')
    saveas(gcf,[titleString ' SEM' '.svg'])

    
end

%% Now, I need to plot salt and water plot on uni vs bi vs ctrl
lineColor = {[0 191/255 1] ;[0 0 1]; [0 0 0]};
marker = {'^','d','o'}; %uni bi ctrl
for v = 1:2
    figure('Units','inch','Position',[3 3 4 3])%,'visible','off');
    
    if v == 1 %salt %stack in order of uni bi ctrl
        meanData = [uni_saltData ; bi_saltData ; ctrl_saltData];
        steData = [uni_steSalt ; bi_steSalt ; ctrl_steSalt]; 
        titleString = 'Salt';
    else %water
        meanData = [uni_waterData ; bi_waterData; ctrl_waterData];
        steData = [uni_steWater ; bi_steWater ; ctrl_steWater];
        titleString = 'Water';
    end
    
    for i = 1:3
        errorbar(edges,meanData(i,:),steData(i,:),...
            'Marker',marker{i},'MarkerFaceColor',lineColor{i},'MarkerSize',markerSize,...
            'Color',lineColor{i},'lineWidth',1.6)

        hold on
    end
    
    %legend
    legend({'Unilateral','Bilateral','Ctrl'},'Location','northwest');
    legend('boxoff')
    
    %label and title
    xlabel('Time (s)');
    ylabel('Cumulative Lick');
    set(gca,'XTick',edges)
    set(gca,'XtickLabelRotation',45);
    
    %plotSpec
    
    set(gca,'linewidth',lineWidth,'FontSize',fontSize,'FontName',fontName)
    set(gcf,'Color',[1 1 1]);
    set(gca,'box','off')
    set(gca,'TickDir','out'); % The only other option is 'in'
    title([titleString],'FontSize',7)  ;
    xlim(xlimRange);
    ylim(ylimRange)
%     xticks([0 150 300 450 600 750 900 1050 1200])

%     saveas(gcf,[titleString ' three case' '.jpg'])
%     saveas(gcf,[titleString ' three case' '.fig'])

    export_fig([titleString ' three case'],'-jpg')
    saveas(gcf,[titleString ' three case' '.svg'])


end
  %% for sfo.. Data that has n = 1
% % lineColor = {[0 191/255 1] ;[0 0 1]; [0 0 0]};
% lineColor = {[0 191/255 1] ; [0 0 0]};
% 
% marker = {'^','o'}; %uni bi ctrl
% 
% for v = 1:2
%     figure('Units','inch','Position',[3 3 4 3])%,'visible','off');
%     
%     if v == 1 %salt %stack in order of uni bi ctrl
%         %meanData = [uni_saltData ; bi_saltData ; ctrl_saltData];
%         %steData = [uni_steSalt ; bi_steSalt ; ctrl_steSalt];
%         meanData = [uni_saltData  ; ctrl_saltData];
%         steData = [uni_steSalt  ; ctrl_steSalt];
%         biData = bi_saltData;
%         titleString = 'Salt';
%     else %water
% %         meanData = [uni_waterData ; bi_waterData; ctrl_waterData];
% %         steData = [uni_steWater ; bi_steWater ; ctrl_steWater];
%         meanData = [uni_waterData ; ctrl_waterData];
%         steData = [uni_steWater  ; ctrl_steWater];
%         biData = bi_waterData;
%         titleString = 'Water';
%     end
%     
%     for i = 1:2
%         errorbar(edges,meanData(i,:),steData(i,:),...
%             'Marker',marker{i},'MarkerFaceColor',lineColor{i},'MarkerSize',markerSize,...
%             'Color',lineColor{i},'lineWidth',1.6)
% 
%         hold on
%     end
%     %now plotting bi data with color of [0 0 1] red
% %     plot(edges, biData,'Marker','d','MarkerFaceColor','r','MarkerSize',markerSize,...
% %             'Color','r','lineWidth',1.6)
%     
%     %legend
%     lg = legend({'Unilateral','Ctrl'},'Location','northwest');
% %     neworder = [1, 3, 2];
% %     lg.PlotChildren = lg.PlotChildren(neworder);
%     legend('boxoff')
%     
%     %label and title
%     xlabel('Time (s)');
%     ylabel('Cumulative Lick');
%     set(gca,'XTick',edges)
%     set(gca,'XtickLabelRotation',45);
%     
%     %plotSpec
%     
%     set(gca,'linewidth',lineWidth,'FontSize',fontSize,'FontName',fontName)
%     set(gcf,'Color',[1 1 1]);
%     set(gca,'box','off')
%     set(gca,'TickDir','out'); % The only other option is 'in'
%     title([titleString],'FontSize',7)  ;
%     xlim(xlimRange);
%     ylim(ylimRange)
% %     saveas(gcf,[titleString ' three case' '.jpg'])
% %     saveas(gcf,[titleString ' three case' '.fig'])
% 
%     export_fig([titleString ' three case'],'-jpg')
%     
% 
% end
