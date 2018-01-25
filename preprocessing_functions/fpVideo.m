function getVideoOnOffIdx(fpObj)
[filename, pathname] = uigetfile( ...
{'*.avi;*.wmv;*.mp4',...
'Video Files (*.avi,*.wmv,*.mp4)'; 
   '*.*',  'All Files (*.*)'}, ...
   'Pick a video file');
videoObject = VideoReader(filename);
numberOfFrames = videoObject.NumberOfFrames;
samplingRate = numberOfFrames/videoObject.Duration;

%% Select ROI

thisFrame = read(videoObject, 1);
imshow(thisFrame)
title('Select ROI')
% ROI=imSelectROI(thisFrame);
Selection = round(getrect,0);
if any(Selection < 0)
    disp(['Selected ROI is out of bounce. Please reselct!'])
Selection = round(getrect,0);  % Select the Area of Interest Using a Mouse
else
     rectangle('Position',Selection,'EdgeColor','r')
     disp('ROI selected. Please close the image.')
%      pause(1)
%      close
end

%% find LED_On points that exists in first 5 min
meanBlueLevels = zeros(numberOfFrames, 1);
meanGrayLevels = zeros(numberOfFrames, 1);

for frame = 1:1:numberOfFrames %what if there isnt a flash in first 10000 frames?
    %     Extract the frame from the movie structure.
    thisFrame = read(videoObject, frame);
    
    meanBlueLevels(frame) = mean(mean(thisFrame(round(Selection(2):Selection(2)+Selection(4),0),Selection(1):Selection(1)+Selection(3), 3)));
    
end



threshold = (max(meanBlueLevels)+min(meanBlueLevels))/2;

eventLightON = meanBlueLevels >= threshold;
threshCrossings = diff(eventLightON);
LEDOnIdx = find(threshCrossings == 1); 
LEDOffIdx = find(threshCrossings == -1); 

figure(1)
plot(meanBlueLevels);
title('Mean Blue Levels');

fpObj.idvData.LEDOnIdx = LEDOnIdx;
fpObj.idvData.LEDOffIdx = LEDOffIdx;



