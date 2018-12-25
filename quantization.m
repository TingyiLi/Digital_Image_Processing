clear, clc, close all;
% quantization: how many bits per picels
% Load test image
img = double(imread('lena.bmp'));

% Loop over number of bits
for numOfBit = 1 : 8
    % Quantize to given number of bits
    numOfLevel = 2.^ numOfBit;
    levelGap = 256 / numOfLevel;
    quantizedImg = uint8(ceil(img / levelGap) * levelGap - 1); % quantization
   
    % Plot image
    subplot(2, 4, 9 - numOfBit), imshow(quantizedImg);
    if numOfBit == 1
        name = [num2str(numOfBit) '-bit'];
    else
        name = [num2str(numOfBit) '-bits'];
    end
    title(name);
    
    % Save image
    imwrite(quantizedImg, ['Quantization_' name '.png'] );
end %end numOfBit