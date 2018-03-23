
function pupilTracking(filename,parameters)

% November 29, 2017 AK: This is the most recent version of program to
% analyze the pupil diameter from videos of a mouse eye. Before running
% this, run the analyzePupilSetup_gui program to obtain the appropriate
% parameters.


%%%%%%%%%% INPUTS: %%%%%%%%%%%%%%
%filename: should be an .mp4 video of a mouse pupil; enter the filename
%with or without the extension

%parameters: should have already run the "analyzePupilSetup_gui" which will
%generate a .mat file containing a structure with necessary parameters. Load
%this file and pass the parameters structure as an input. Alternatively,
%leave the second input blank and the program will start by loading the GUI
%to select parameters.

%Setup global variables
global nFrames cLast pupilDiameter pupilPos frame xROI yROI colInvert adjContrast
    
if nargin == 1 %If no parameters variable give, run the 'setup' analysis
    analyzePupilSetup_gui
else
    pupilDiameter = nan(1,nFrames);
    pupilPos = nan(2,nFrames);
    IRledSignal = nan(1,nFrames);
    cLast = nan(1,2);
    frame = 1;
    
    %Remove any filename extension if exists
    if isequal(filename(end-3),'.')
        filename = filename(1:end-4);
    end
    
    %Load global parameter values set in the "analyzePupilSetup" GUI
    %load([filename '.mat'])
    loadParams(parameters)
    
    %Loading video file
    [vidobj,nFrames] = createVidObj(filename);
    h = setupFig();
    while hasFrame(vidobj)
        
        percCounter(frame,1,nFrames) %Keeps track of progress
        
        %Read video frame and get coordinates for eye ROI
        frame = frame+1;
        im2 = getFrame(vidobj,yROI,xROI,adjContrast);
        
        %Save the mean value of the frame to track IR led flashes
        IRledSignal(frame) = readIRLedpixel(im2);
        
        %Get size and position of last several pupil values to best select next object
        [cLast] = getLastValues(frame);
        
        %Get pupil diameter and position of pupil in current frame
        [diam,cLast,im4,imOpen,Ie2] = getPupilDiameter(im2,frame,numThresh,sens,openPix,erodePix,cLast,h);
        if ~isempty(diam)
            pupilDiameter(frame) = diam;
            pupilPos(:,frame) = cLast;
        else
            pupilDiameter(frame) = NaN;
            pupilPos(:,frame) = pupilPos(:,frame-1);
        end
        
        if frame < 100 %plot image & circle output for first 100 frames to make sure working correctly
            plotOutput()
        end
        
    end
    
    %Smooth & normalize pupil diameter values
    frSmooth = round(0.5*125); %smooth across ~500ms sliding window
    pupilDiameter2 = smoothData(pupilDiameter,frSmooth)';
    pupilDiameter3 = 100* mat2gray(pupilDiameter2);
    
    %Plot final output
    figure, hold on, plot(pupilDiameter),plot(pupilDiameter2),plot(pupilDiameter3), axis tight
    
    %Save necessary variables for further analysis
    save([filename,'.mat'],'IRledSignal','pupilDiameter','pupilDiameter2','pupilDiameter3','-append')
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function loadParams(parameters)
        numThresh = parameters.numThresh;
        openPix = parameters.openPix;
        erodePix = parameters.erodePix;
        sens = parameters.sens;
        nFrames = parameters.nFrames;
        colInvert = parameters.colInvert;
        adjContrast = parameters.adjContrast;
        xROI = parameters.xROI;
        yROI = parameters.yROI;
    end
    function [obj,n] = createVidObj(f)
        v = sprintf('%s',f,'.mp4');
        disp('Loading video file...')
        obj = VideoReader(v);
        
        n = floor(obj.FrameRate*obj.Duration);
    end
    function im2 = getFrame(vidobj,yROI,xROI,adjContrast)
        %Read video frame and get coordinates for eye ROI
        im = rgb2gray(readFrame(vidobj));
        
        %Crop the image around the ROI area & save as binary image
        ypix = min(yROI):max(yROI);
        xpix = min(xROI):max(xROI);
        im2 = im(ypix,xpix);
        if isequal(adjContrast,'y') || isequal(adjContrast,1)
            im2 = imadjust(im2);
        end
    end
    function [cLast] = getLastValues(frame)
        
        if frame > 101
            %m = nanmean(pupilDiameter(frame-100:frame-1));
            cLast = nanmean(pupilPos(:,frame-10:frame-1),2)';
        else
            %m = nanmean(pupilDiameter(1:frame-1));
            cLast = nanmean(pupilPos(:,1:frame-1),2)';
        end
    end

    function h = setupFig()
        figure(1);
        h.axes1 = subplot(2,2,1);%h.axes1 = get(gca);
        h.axes2 = subplot(2,2,2);%h.axes2 = get(gca);
        h.axes3 = subplot(2,2,3);%h.axes3 = get(gca);
        h.axes4 = subplot(2,2,4);%h.axes4 = get(gca);
    end
    function plotOutput()
        axes(h.axes1)
        imshow(im2)
        hold on
        title(['Frame number: ',num2str(frame),' diam = ',num2str(pupilDiameter(frame))])
        viscircles(cLast,diam/2,'EdgeColor','b');
        drawnow
        hold off
        
        axes(h.axes2)
        imshow(im4),title('after thresholding')
        axes(h.axes3)
        imshow(imOpen),title('after imopen')
        axes(h.axes4)
        imshow(Ie2),title('after imopen + imerode')
    end

    function signal = readIRLedpixel(im2)
        signal = mean(im2(:));
    end

end