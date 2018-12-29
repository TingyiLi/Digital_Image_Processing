% Nonlinear noise reduction/sharpening 

clear, clc; % close all;

% Load test image
img = double(imread('croppedBike.png'));
% img = double(imread('cman.tif'));
figure(1); imshow(img,[0 255]); title('Original Image');

% Blur the image
kernel_avg = [1 2 1]' * [1 2 1];
kernel_avg = kernel_avg / sum(kernel_avg(:));
img = imfilter(img,kernel_avg,'replicate','conv');
figure(2); imshow(img,[0 255]); title('Blurred Image');
imwrite(uint8(img),'Nonlinear_Filtering_blurred.tif');

% Add noise
noise_var = 16;
noise = (rand(size(img))-0.5)/sqrt(1/12)*sqrt(noise_var);
img = img + noise;
figure(3); imshow(img,[0 255]); title('Blurry Noisy Image');
imwrite(uint8(img),'Nonlinear_Filtering_blurred_noisy.tif');

img_low = imfilter(img,kernel_avg,'replicate','conv');
img_low_low = imfilter(img_low,kernel_avg,'replicate','conv');

% Generate high-pass-filtered images
kernel1 = [-0.5 1 -0.5]; kernel1 = kernel1 / sum(abs(kernel1(:)));
kernel2 = [-0.5; 1; -0.5]; kernel2 = kernel2 / sum(abs(kernel2(:)));
kernel3 = [-0.5 0 0; 0 1 0; 0 0 -0.5]; kernel3 = kernel3 / sum(abs(kernel3(:)));
kernel4 = [0 0 -0.5; 0 1 0; -0.5 0 0]; kernel4 = kernel4 / sum(abs(kernel4(:)));
H1 = imfilter(img,kernel1,'replicate','conv');
H2 = imfilter(img,kernel2,'replicate','conv');
H3 = imfilter(img,kernel3,'replicate','conv');
H4 = imfilter(img,kernel4,'replicate','conv');

% Parameters for soft coring
gamma = 2;
tau = 10;
scaling = 3;

% Show soft coring function
figure(4); clf; set(gcf, 'Color', 'w');
h = plot(-100:0.5:100,soft_coring(-100:0.5:100,gamma,tau,scaling),'r','linewidth',3);
set(h, 'LineSmoothing', 'on');
hold on; 
% h = plot(-100:100,-100:100,'k:','linewidth',3);
% set(h, 'LineSmoothing', 'off');
% h = plot(-100:100,scaling*(-100:100),'k:','linewidth',3);
% set(h, 'LineSmoothing', 'off');
axis([-100 100 -300 300]); axis square;
hold on; plot(zeros(1,601),[-300:300],'k','linewidth',1);
hold on; plot([-100:100],zeros(1,201),'k','linewidth',1);
set(gca,'FontSize',12,'XTick',[-50:10:50]);
axis equal;
axis([-50 50 -50 50]);

% Perform soft coring on high-pass images
H1t = soft_coring(H1,gamma,tau,scaling);
H2t = soft_coring(H2,gamma,tau,scaling);
H3t = soft_coring(H3,gamma,tau,scaling);
H4t = soft_coring(H4,gamma,tau,scaling);

% Generate the denoised and sharpened image
alpha = 0.5;
img1 = img - (H1+H2+H3+H4)*alpha + (H1t+H2t+H3t+H4t)*alpha;
imwrite(uint8(img1),'Nonlinear_Filtering_denoised_sharpened.tif');
img2 = img - (H1+H2+H3+H4)*alpha + (H1t+H2t+H3t+H4t)*0/9;
imwrite(uint8(img2),'Nonlinear_Filtering_denoised_blurred.tif');
img3 = img - (H1+H2+H3+H4)*0/9 + (H1+H2+H3+H4)*alpha;
imwrite(uint8(img3),'Nonlinear_Filtering_noisy_sharpened.tif');
figure(5); imshow(img1,[0 255]); title('Denoised and Sharpened');
figure(6); imshow(img2,[0 255]); title('Lowpass Filtered')
figure(7); imshow(img3,[0 255]); title('Sharpened');

% Save high pass results
max_value = max(log(abs([H1t(:); H2t(:); H3t(:); H4t(:)])));
imwrite(uint8(log(abs(H1))/max_value*255),'H1.tif');
imwrite(uint8(log(abs(H2))/max_value*255),'H2.tif');
imwrite(uint8(log(abs(H3))/max_value*255),'H3.tif');
imwrite(uint8(log(abs(H4))/max_value*255),'H4.tif');
imwrite(uint8(log(abs(H1t))/max_value*255),'H1t.tif');
imwrite(uint8(log(abs(H2t))/max_value*255),'H2t.tif');
imwrite(uint8(log(abs(H3t))/max_value*255),'H3t.tif');
imwrite(uint8(log(abs(H4t))/max_value*255),'H4t.tif');