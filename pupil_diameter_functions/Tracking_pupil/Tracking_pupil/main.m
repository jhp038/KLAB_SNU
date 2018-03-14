


%%
obj = VideoReader('180123_HJ_Pupil_Ref2_LightOnOff.wmv');

thisFrame = read(obj, 20);
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


NumberOfFrames = obj.NumberOfFrames;

la_imagen=read(obj,10);

% Center
% centro_fila=round(filas/2);
% centro_columna=round(columnas/2);
 figure(1);
for cnt = 1:NumberOfFrames       
    temp_image=read(obj,cnt);
    la_imagen=temp_image(round(Selection(2):Selection(2)+Selection(4),0),Selection(1):Selection(1)+Selection(3));
    filas=size(la_imagen,1);
    columnas=size(la_imagen,2);
    
    if size(la_imagen,3)==3
        la_imagen=rgb2gray(la_imagen);
    end

    subplot(212)
    piel=~im2bw(la_imagen,0.15);
    %     --
    piel=bwmorph(piel,'close');
    piel=bwmorph(piel,'open');
    piel=bwareaopen(piel,200);
    piel=imfill(piel,'holes');
    imagesc(piel);
    % Tagged objects in BW image
    L=bwlabel(piel);
    % Get areas and tracking rectangle
    out_a=regionprops(L);
    % Count the number of objects
    N=size(out_a,1);
    if N < 1 || isempty(out_a) % Returns if no object in the image
        solo_cara=[ ];
        continue
    end
    % ---
    % Select larger area
    areas=[out_a.Area];
    [area_max pam]=max(areas);
    subplot(211)
    imagesc(la_imagen);
    colormap gray
    hold on
    rectangle('Position',out_a(pam).BoundingBox,'EdgeColor',[1 0 0],...
        'Curvature', [1,1],'LineWidth',2)
    centro=round(out_a(pam).Centroid);
    X=centro(1);
    Y=centro(2);
    plot(X,Y,'g+')
    %     
    text(X+10,Y,['(',num2str(X),',',num2str(Y),')'],'Color',[1 1 1])
    if X<centro_columna && Y<centro_fila
        title('Top left')
    elseif X>centro_columna && Y<centro_fila
        title('Top right')
    elseif X<centro_columna && Y>centro_fila
        title('Bottom left')
    else
        title('Bottom right')
    end
    hold off
    % --
    drawnow;
end