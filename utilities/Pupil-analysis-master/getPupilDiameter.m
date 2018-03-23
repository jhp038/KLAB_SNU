
function [diam,cLast,im4,imOpen,Ie2] = getPupilDiameter(im2,frame,numThresh,sens,openPix,erodePix,cLast,h)

warning('off','all'); %suppress warning display, otherwise will print warning on every frame

%thresholding the image using multithresh, save just the lowest threshold values
thresh = single(multithresh(im2,numThresh));
im4 = imcomplement(imbinarize(im2,thresh(1)/255));

%Modify image using imopen & imerode to help distinguish pupil from background
im4 = bwareafilt(im4,[20 1e5]);
se2 = strel(ones(openPix,openPix));
se3 = strel(ones(erodePix,erodePix));
imOpen = imopen(im4, se2);
Ie2 = imcomplement(imerode(imOpen, se3));

minRad = 6;
maxRad = 80;
maxDist = 30;

%Find circles in modified image
[centers,radii] = imfindcircles(Ie2,[minRad maxRad],'ObjectPolarity','dark','Sensitivity',sens,'Method','twostage');
radii = radii + (erodePix/2); %add # of eroded pixels back onto the radius to reflect actual pupil size

col = ['brgkmy'];
colstr = {'blue','red','green','black','magenta','yellow'};

bestCirc = 1;
diam = NaN;

if ~isempty(centers) %if at least one circle found
    
    if frame < 1000 && isnan(cLast(1)) %for first few frames ask user to define which circle is the pupil if program isn't sure
        if size(centers,1) == 1
            bestCirc = 1;
        else
            plotOutput()
            bestCirc = askbestCirc();
        end
    else
        bestCirc = getbestCirc();
    end
    diam = 2*radii(bestCirc);
end

if ~isempty(centers) && ~isempty(bestCirc) %&& ~isnan(diam)
    cLast = centers(bestCirc,:); %save center coordinate of pupil to compare to next frame
else
    cLast = cLast;%nans(1,2);
end

warning('on','all'); %suppress warning display, otherwise will print warning on every frame

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function plotOutput()
        axes(h.axes1);
        imshow(im2)
        hold on
        title(['Frame number: ',num2str(frame),' diam = '])
        for j = 1:min(size(centers,1),length(col))
            ctemp = centers(j,:);
            distLast(j) = pdist([ctemp;cLast]);
            viscircles(centers(j,:),radii(j),'EdgeColor',col(j))
        end
        drawnow
        hold off
        
        axes(h.axes2);
        imshow(im4),title('after thresholding')
        axes(h.axes3);
        imshow(imOpen),title('after imopen')
        axes(h.axes4);
        imshow(Ie2),title('after imopen + imerode')
        
    end


    function bestCirc = askbestCirc()
        %x = input('Enter color of circle for pupil: ');
        l = min(size(centers,1),length(col));
        colstr = colstr(1:l);
        x = listdlg('PromptString','Select the color for the pupil: ',...
            'SelectionMode','single',...
            'ListSize',[150 100],...
            'ListString',colstr);
        if ~isempty(x)
            bestCirc = x;%find(col == x);
        else
            bestCirc = [];
        end
    end

    function bestCirc = getbestCirc()
        distLast = [];
        for j = 1:size(centers,1)
            ctemp = centers(j,:);
            distLast(j) = pdist([ctemp;cLast]);
        end
        [y,x] = min(distLast); %choose the correct circle as the one with the smallest distance from the pupil center on the previous frame
        
        if y < maxDist
            bestCirc = x;
        else
            bestCirc = [];
        end
    end
end



% x = find(diff(thresh) <= 0);
% if ~isempty(x) %will get an error if there are no pixels above one of the thresholds
%     thresh = thresh(1:x);
% end
% seg_im2 = imquantize(im2,thresh);
% im4 = seg_im2 == 1; %create binary image from only pixels below the first threshold (i.e. the darkest pixels)
