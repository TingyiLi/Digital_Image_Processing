% Image averaging for noise reduction
clear, clc, close all

% Load test image
img = im2double(rgb2gray(imread('lena.bmp')));

% Loop over number of samples
nArray = [1, 2, 8, 32];
for i = 1 : numel(nArray)
    N = nArray(i);
    avgImg = zeros(size(img));
    
    % Add Gaussian noise, accumulate average image
    for j = 1 : N
        noisyImg = imnoise(img, 'gaussian', 0, 0.02);
        avgImg = avgImg + noisyImg;
    end % end j
    
    % Show image
    avgImg = avgImg / N;
    subplot(2, 2, i);
    imshow(avgImg);
    title([num2str(N), ' image(s)']);
    imwrite(avgImg, ['Image_Averaging_', num2str(N), 'avg.png']);
end % end i
