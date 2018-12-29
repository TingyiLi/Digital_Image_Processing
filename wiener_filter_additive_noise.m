% Wiener filtering with additive noise

clear, clc, close all

% Load test image
I = im2double(imread('croppedBike.png'));
figure(1); clf;
imshow(I); title('Original Image');

% Simulate additive noise.
noise_mean = 0;
noise_var = 0.005;
noisy = imnoise(I, 'gaussian', noise_mean, noise_var);
figure(2); clf;
imshow(noisy);
title('Noisy Image')
imwrite(noisy, 'Wiener_Filtering_Additive_Noise_noisy.png');

dif = 255 * (noisy - I);
rms_error_before_wnr = rms(dif(:))

% Perform Wiener filtering on noisy image
noisy_dft = fft2(noisy); % DFT of noisy image
I_psd = abs(fft2(I)).^2; % original image PSD
noise_psd = prod(size(I)) * noise_var; % white noise PSD
wnr_H = I_psd ./ (I_psd + noise_psd); % Wiener transfer function
figure(3); clf;
imshow(fftshift(log(1 + wnr_H)),[]); colorbar;
wnr_dft = noisy_dft .* wnr_H; % DFT of filtered image
wnr = real(ifft2(wnr_dft)); % converted to spatial domain
figure(4); clf;
imshow(wnr)
title('Restoration of Noisy Image Using Estimated NSR');
imwrite(wnr, 'Wiener_Filtering_Additive_Noise_wnr.png');

dif = 255 * (wnr - I);
rms_error_after_wnr = rms(dif(:))