% Wiener filtering

clear, clc, close all

% Load test image
I = im2double(imread('croppedBike.png'));
figure(1); clf;
imshow(I); title('Original Image');

% Simulate a motion blur.
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
figure(2); clf;
imshow(blurred);
title('Blurry Image');
imwrite(blurred, 'Wiener_Filtering_blurred.png');

% Simulate additive noise.
noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred, 'gaussian', noise_mean, noise_var);
figure(3); clf;
imshow(blurred_noisy);
title('Blurry and Noisy Image')
imwrite(blurred_noisy, 'Wiener_Filtering_blurred_noisy.png');

dif = 255 * (blurred_noisy - blurred);
rms(dif(:))

% Perform Wiener filtering on blurry image, assuming noise = 0
estimated_nsr = 0;
wnr1 = deconvwnr(blurred, PSF, estimated_nsr);
figure(4); clf;
imshow(wnr1);
title('Restoration of Blurred Image Using NSR = 0')
imwrite(wnr1, 'Wiener_Filtering_deblurred.png');

% Perform Wiener filtering on blurry + noisy image
% Assuming noise = 0
estimated_nsr = 0;
wnr2 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure(5); clf; 
imshow(wnr2)
title('Restoration of Blurred, Noisy Image Using NSR = 0')
imwrite(wnr2, 'Wiener_Filtering_deblurred_noisy.png');

% Perform Wiener filtering on blurry + noisy image
% Remove noise = 0 assumption
estimated_nsr = noise_var / var(I(:));
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure(6); clf;
imshow(wnr3)
title('Restoration of Blurred, Noisy Image Using Estimated NSR');
imwrite(wnr3, 'Wiener_Filtering_deblurred_noisy_wnr.png');