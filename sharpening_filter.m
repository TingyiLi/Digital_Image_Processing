% Sharpening filter

clear, clc, close all

% Load test image
img = im2double(imread('croppedBike.png'));

% Apply two different sharpening filters
h1 = [0, -1, 0; -1, 8, -1; 0, -1, 0] / 4;
h2 = [0, -1, 0; -1, 5, -1; 0, -1, 0];
filteredImg1 = imfilter(img, h1, 'replicate');
filteredImg2 = imfilter(img, h2, 'replicate');

% Show images
figure(1), clf;
subplot(1, 2, 1), imshow(img); title('Original Image');
subplot(1, 2, 2), imshow(filteredImg1); title('Filtered Image');
figure(2), clf;
subplot(1, 2, 1), imshow(img); title('Original Image');
subplot(1, 2, 2), imshow(filteredImg2); title('Filtered Image');

% Define frequency responses
[wx,wy] = meshgrid(-3 : 0.1 : 3, -3 : 0.1 : 3);
H1 = 2 - 0.5 * cos(wx) - 0.5 * cos(wy);
H2 = 5 - 2 * cos(wx) - 2 * cos(wy);

% Show magnitude of frequency response
figure(3), clf;
surf(wx/pi, wy/pi, abs(H1));
set(gca, 'XTick', -1 : 1/2 : 1, 'YTick', -1 : 1/2 : 1);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi'); zlabel('| H(\omega_x, \omega_y) |');
figure(4), clf;
surf(wx/pi, wy/pi, abs(H2));
set(gca, 'XTick', -1 : 1/2 : 1, 'YTick', -1 : 1/2 : 1);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi'); zlabel('| H(\omega_x, \omega_y) |');

% Save images
imwrite(filteredImg1, 'Sharpening_Filter_1.png');
imwrite(filteredImg2, 'Sharpening_Filter_2.png');