% DJM added modified from http://stackoverflow.com/questions/20400873/detect-a-circular-shape-inside-image-in-matlab 
%uncomment line 13 if folder contains both whisker and pupil sequences
clear;
myFolder = uigetdir;
cd(myFolder);
filePattern = fullfile(myFolder, '*.tif');
tiffiles = dir(filePattern);
count = length(tiffiles);
% nMovies = count;
% curMovie = 0;
w = 1;

figure;

for curMovie = 1:count;
    %if mod(y, 2) ==1;
    curMovieName = tiffiles(curMovie, 1).name;
    fileinfo = imfinfo(curMovieName);
    frames = numel(fileinfo);
    
    I = imreadtiffstack (curMovieName, frames);
    % resize option would go here - change I to J in line above
    % I = imresize(J, 0.5);
    %diamKeeper = zeros(frames,1);
    for z = 1:frames;
      contrastkeeper(:,:,z) = imadjust(I(:,:,z), [0.0 0.11], []); %originally 0.06, also used at 0.04, for recent movies set to 0.1 to start
    end
    
    
    level = graythresh(contrastkeeper(:,:,1));
    
    for b = 1:frames;
        bwkeeper(:,:,b) = im2bw(contrastkeeper(:,:,b), level);
    end
    
    for currentFrame = 1:frames;
        try
        %gimg = min( I(:,:,currentFrame), [], 3 );
        %BW = im2bw( gimg, .02 ); %imagesc(BW) % changed to 0.02, was 0.4
        BW = bwkeeper(:,:,currentFrame);
        %  3. Get area and centroid porperties of image regions
        
        st = regionprops( ~BW, 'Area', 'Centroid', 'PixelIdxList' );
        
        % 4. select only large enough regions
        
        sel = [st.Area] > numel(BW)*0.005; % at least 0.5% of image size
        st = st(sel);
        
        % 5. compute region distance to center of image
        
        cntr = .5 * [size(BW,2) size(BW,1)]; % X-Y coordinates and NOT Row/Col
        d = sqrt( sum( bsxfun(@minus,vertcat( st.Centroid ), cntr ).^2, 2 ) );
        
        % 6. pick the region closest to center
        
        [mn, idx] = min(d);
        
        % 7. Create a mask
        
        res = false(size(BW));
        res( st(idx).PixelIdxList ) = true;
        
        % define arbitrary num pixels that is 'edge'
        edgeThresh = 8; %originally was 8
        %sizeVector = 1:size(res,2);
        
        for i = 1:size(res,2);
            if(sum(res(:,i)) > edgeThresh) %columns - from left
                L_edge = i;
                break
            end
        end
        
        j = fliplr(1:size(res,2));
        
        for i = 1:size(res,2);
            if(sum(res(:,j(i))) > edgeThresh) %columns - from right
                R_edge = j(i);
                break
            end
        end
        
        diam = R_edge - L_edge;
        diamKeeper(currentFrame, w) = diam;
        catch
            diamKeeper(currentFrame, w) = NaN;
        end
        
        end   
    plot(diamKeeper(:,w)); hold all;
    w = w + 1;
end
save('diameter.mat', 'diamKeeper');
save('tiffiles.mat', 'tiffiles');
% 
% if curMovie == 1;
%     radius = zeros(frames, 1); % preallocation
% end
% for currentFrame = 1:frames;
%     contrastkeeper(:,:,currentFrame) = imadjust(I(:,:,currentFrame), [0.0 0.06], []);
%     
%     level = graythresh(contrastkeeper(:,:,1));
%     %currentFrame = 1:frames;
%     bwkeeper(:,:,currentFrame) = im2bw(contrastkeeper(:,:,currentFrame), level);
%     
%     %currentFrame = 1:frames;
%     edgekeeper(:,:,currentFrame) = edge(bwkeeper(:,:,currentFrame));
%     %currentFrame = 1:frames;
%     [centersDark, radiiDark] = imfindcircles(edgekeeper(:,:,currentFrame),[70 130],'ObjectPolarity','dark', 'Sensitivity', 0.90);
%     %viscircles(centersDark, radiiDark,'LineStyle','--');
%     fault = isempty(radiiDark);
%     if fault == 1
%         [centersDark, radiiDark] = imfindcircles(edgekeeper(:,:,currentFrame),[70 130],'ObjectPolarity','dark', 'Sensitivity', 0.93);
%         %radiiDark = 0;
%     end
%     fault = isempty(radiiDark);
%     if fault == 1
%         [centersDark, radiiDark] = imfindcircles(edgekeeper(:,:,currentFrame),[70 140],'ObjectPolarity','dark', 'Sensitivity', 0.96);
%         %radiiDark = 0;
%     end
%     fault = isempty(radiiDark);
%     if fault == 1
%         radiiDark = 0;
%     end
%     sradiiDark = size(radiiDark);
%     if sradiiDark(1,1) > 1
%         radiiDark = NaN;
%     end
%     radius(currentFrame, w) = radiiDark;
% end
% w = w + 1;

%clear contrastkeeper; clear bwkeeper; clear edgekeeper; clear I;

%end

%end
%save('radius.mat', 'radius');




%
%     for z = 1:frames;
%         contrastkeeper(:,:,z) = imadjust(I(:,:,z), [0.0 0.06], []);
%     end
%     level = graythresh(contrastkeeper(:,:,1));
%     for b = 1:frames;
%         bwkeeper(:,:,b) = im2bw(contrastkeeper(:,:,b), level);
%     end
%     for f = 1:frames;
%         edgekeeper(:,:,f) = edge(bwkeeper(:,:,f));
%     end
%     for x = 1:frames;