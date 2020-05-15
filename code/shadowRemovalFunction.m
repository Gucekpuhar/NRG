function final = shadowRemovalFunction(x)

clear all
close all
clc

name = x;
im = imread(name);


[y1,x1] = size(im);
figure, imshow(im);

%  median filter size
bl = medfilt2( double( im(:,:,3)), [3,3] );

gr = medfilt2 (double( im(:,:,2)), [3,3] );

% re = medfilt2( double( im(:,:,1)), [3,3] ); we dont use it latter 




% Shadow Ratio:

SH_rat = ((4/pi).*atan(((bl-gr))./(bl+gr)));


figure, imshow(SH_rat); colormap(hsv); colorbar;

% threshold  
mask = SH_rat>0.05;


figure, imshow(mask), title('Mask'); 

mask(1:5,:) = 0;

mask(:,1:5) = 0;

mask(end-5:end,:) = 0;

mask(:,end-5:end) = 0;


%area size threshold
mask = bwareaopen(mask, 1);

[y,x] = find(imdilate(mask, strel('disk',2))-mask);



figure, imshow(im); hold on,
plot(x, y, '.g'), title('Shadows');


%tmp = rgb2hsv(im);

%tmp(:,:,2) = tmp(:,:,2) / 5;
%tmp = hsv2rgb(tmp);

BW = im2bw(mask,0.4);


%figure, imshow(tmp);

res = rgb2hsv(im);

sat = res(:,:,2);

valu = res(:,:,3);

meanS = mean(sat(:));

meanV = mean(valu(:));

sat = meanS .* 0.1;

valu = meanV .* 1.8;

%avg = (sat + valu) /2;

%res(shadow_mask) = sat ;
%res(mask) = avg ;
res(:,:,2) = bsxfun(@times, res(:,:,2), 0.3) ;
res(:,:,3) = bsxfun(@times, res(:,:,3), 1.5) ;

res2  = hsv2rgb(res);


tmp2 = bsxfun(@times, im, cast(~BW, 'like', im));
%maskedRgbImage=im;

%combine the images

maskedRgbImage = bsxfun(@times, res2, cast(BW, 'like', res2));
%pixelsToReplace = maskedRgbImage == 255;

%maskedRgbImage(pixelsToReplace) = tmp2(pixelsToReplace);
%res2(BW) = res(BW);
els = im2double(tmp2);

final = els + maskedRgbImage;
figure, imshow(final);


end





