


%%
obj = VideoReader('WIN_20180315_19_11_23_Pro_cut.avi');
NumberOfFrames = obj.NumberOfFrames;
% 
la_imagen=read(obj,10);
filas=size(la_imagen,1);
columnas=size(la_imagen,2);
% Center
centro_fila=round(filas/2);
centro_columna=round(columnas/2);
 figure(1);
for cnt = 1%%:NumberOfFrames       
    la_imagen=read(obj,cnt);
    if size(la_imagen,3)==3
        la_imagen=rgb2gray(la_imagen);
    end

    subplot(212)
    piel=~im2bw(la_imagen,0.2);
    imagesc(piel)
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

%%
      BW1 = imread('circles.png');
      figure, imshow(BW1)
      BW2 = bwmorph(BW1,'remove');
      BW3 = bwmorph(BW1,'skel',Inf);
      figure, imshow(BW2)
      figure, imshow(BW3)
      
      %% trying fuzzy c
      imagesc(la_imagen)
      [centers,U] = fcm(lim2double(a_imagen),3)
      
      figure
      imagesc(U)

      
      
      