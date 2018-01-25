videoObject = VideoReader('passive heating_light_cropped-1.avi');


thisFrame = read(videoObject, 20);
% imshow(thisFrame)
% title('Select ROI')
% % ROI=imSelectROI(thisFrame);
% Selection = round(getrect,0);
% if any(Selection < 0)
%     disp(['Selected ROI is out of bounce. Please reselct!'])
% Selection = round(getrect,0);  % Select the Area of Interest Using a Mouse
% else
%      rectangle('Position',Selection,'EdgeColor','r')
%      disp('ROI selected. Please close the image.')
% 
% end

%% find LED_On and Off indices from video
numberOfFrames = videoObject.numberOfFrames;
meanBlueLevels = zeros(numberOfFrames, 1);

% for frame = 1:1:numberOfFrames 
%     %     Extract the frame from the movie structure.
%     thisFrame = read(videoObject, frame);   
%     meanBlueLevels(frame) = mean(mean(thisFrame(round(Selection(2):Selection(2)+Selection(4),0),Selection(1):Selection(1)+Selection(3), 3)));   
% end

for frame = 1:1:numberOfFrames 
    %     Extract the frame from the movie structure.
    thisFrame = read(videoObject, frame);   
    meanBlueLevels(frame) = mean(mean(thisFrame(:,:,3)));   
end

plot(meanBlueLevels);
% 
% %interpolate meanBlueLevels with raw data, and cut with trimming range
% interp_meanBlueLevels = interp1(timeV_video,meanBlueLevels,timeVectors,'linear','extrap');
% interp_meanBlueLevels_trimmed = interp_meanBlueLevels(trimmingRange(1):trimmingRange(2));
% %interpolate timepoint
% interp_meanBlueLevels = interp1(1:duration,timeV_video,1:length(timeVectors)','linear','extrap');


%Initializae variable
threshold = [];
eventLightOn = [];
threshCrossings=[];
LEDOnIdx=[];
LEDOffIdx=[];

threshold = (max(meanBlueLevels)+min(meanBlueLevels))/2;
eventLightON = meanBlueLevels >= threshold;
threshCrossings = diff(eventLightON);
LEDOnIdx = find(threshCrossings == 1); 
LEDOffIdx = find(threshCrossings == -1); 

