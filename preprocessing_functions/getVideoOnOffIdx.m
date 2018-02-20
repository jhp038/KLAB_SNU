function fpObj = getVideoOnOffIdx(fpObj)

totalMouseNum = fpObj.totalMouseNum;
videoFile = uipickfiles('FilterSpec','*.mp4'); %this has to search for .mp4 files
% videoFile = uipickfiles('FilterSpec','*.wmv'); %this has to search for .wmv files

if iscell(videoFile) == 0
    errordlg('Please select .mp4 files')
    fpObj = [];
    return
end



for mouseNum = 1: totalMouseNum
    videoObject = VideoReader(videoFile{mouseNum});
  
    if mouseNum == 1
        thisFrame = read(videoObject, 20);
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
        end
    end
    %% find LED_On and Off indices from video
    numberOfFrames = videoObject.numberOfFrames;
    meanBlueLevels = zeros(numberOfFrames, 1);
    
    for frame = 1:1:numberOfFrames
        %     Extract the frame from the movie structure.
        thisFrame = read(videoObject, frame);
        meanBlueLevels(frame) = mean(mean(thisFrame(round(Selection(2):Selection(2)+Selection(4),0),Selection(1):Selection(1)+Selection(3), 3)));
    end
    
    
    figure
    plot(meanBlueLevels);
    
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
    
    fpObj.idvData(mouseNum).LEDOnIdx = LEDOnIdx;
end

% %interpolate meanBlueLevels with raw data, and cut with trimming range
% interp_meanBlueLevels = interp1(timeV_video,meanBlueLevels(LEDOnIdx(1):LEDOnIdx(2)),timeVectors,'linear','extrap');
