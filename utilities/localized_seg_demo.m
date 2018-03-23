% Demo of "Localized Region Based Active Contours"
% 
% Example:
% localized_seg_demo
%
% Coded by: Shawn Lankton (www.shawnlankton.com)
    videoObject = VideoReader('WIN_20180315_19_11_23_Pro_cut.avi');

thisFrame = read(videoObject, 360);
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



I =thisFrame;   %-- load the image
m = false(size(I,1),size(I,2));   %-- create initial mask




m(Selection(1):Selection(1)+Selection(3),Selection(2):Selection(2)+Selection(4)) = true;

I = imresize(I,.5);  %-- make image smaller
m = imresize(m,.5);  %   for fast computation

subplot(2,2,1); imshow(I); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = localized_seg(I, m, 500,12);  %-- run segmentation

subplot(2,2,4); imshow(seg); title('Final Segmentation');




