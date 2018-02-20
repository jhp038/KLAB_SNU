function plotGraph(X,Y,varargin)
%example code
% plotGraph(1,2,3,'stimRange',0,'xLabel','Time (s)','yLabel','zscore')
%% initialization
totalNumVar = length(varargin);
disp(totalNumVar)
%  stimRange = [];

if totalNumVar <=1
    xLabelString = [];
    yLabelString = [];
    disp(['xlabel = ' xLabelString])
    disp(['ylabel = ' yLabelString])
    stimRange = [];
else  
    for numVar = 1: totalNumVar
        if ismatrix(varargin{numVar})
            E = varargin{numVar};
        elseif strcmp(varargin{numVar}, 'stimRange')
            stimRange = varargin{numVar+1};            
        elseif strcmp(varargin{numVar}, 'xLabel')
            xLabelString =  varargin{numVar+1};            
        elseif strcmp(varargin{numVar}, 'yLabel')
            yLabelString =  varargin{numVar+1};
            if strcmp(yLabelString,'zscore')
                yLabelString = 'Normalized \DeltaF/F';
            else
                yLabelString = '\DeltaF/F (%)';
            end
        end
    end
end

%% actual plotting
% disp(ischar(varargin{1}))
if ismatrix(varargin{1}) &&ischar(varargin{1}) == 0
    E = varargin{1};
    mseb(X,Y,E);
else
    plot(X,Y);
end

set(gca,'linewidth',1.6,'FontSize',15,'FontName','Arial')
set(gca, 'box', 'off')
set(gcf,'Color',[1 1 1])
hold on
xRange = xlim;
yRange = ylim;

disp(num2str(stimRange))

if isvector(stimRange)
    disp('hello')
plot([stimRange stimRange],ylim,'Color',[1 0 0]);
plot([stimRange stimRange],ylim,'Color',[1 0 0]);

else 
        disp('hello2')

%     r = patch([0 stimRange(2) stimRange(2) 0], [yRange(1) yRange(1) yRange(2)  yRange(2)],...
%         [1,0,0]);
%     set(r, 'FaceAlpha', 0.2,'LineStyle','none');


    
end

set(gca,'TickDir','out'); % The only other option is 'in'

% xlabel(xLabelString);
% ylabel(yLabelString);

xlim(xRange);
end