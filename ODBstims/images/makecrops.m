for i=[1 4 13 16]
    bw=rot90(CenterInBlack(imread(sprintf('sgridODB-%02d.png',i)),[600 600]));
    L=bwlabel(bw);
    s=regionprops(L,'centroid');
    centroids=round(cat(1,s.Centroid));%+[15 0];
    sx=133; sy=180;
    cropped=bw(round(centroids(2)-sx):round(centroids(2)+sx-1),round(centroids(1)-sy):round(centroids(1)+sy-1));
    
    cropped(cropped==0)=128;
    cropped(cropped==255)=0;
    figure;
    imshow(rot90(cropped));
    imwrite(rot90(cropped)./255,sprintf('sgridODB-%02d.tif',i));
end
    