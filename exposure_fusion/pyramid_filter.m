% This is a 1-dimensional 5-tap low pass filter. It is used as a 2D separable low
% pass filter for constructing Gaussian and Laplacian pyramids.

function f = pyramid_filter;
f = [.0625, .25, .375, .25, .0625];