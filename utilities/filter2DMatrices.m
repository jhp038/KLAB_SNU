function [ outputMaps ] = filter2DMatrices( inputMaps, downsampledFlag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%2D ratemap smoothing function **************************************
if downsampledFlag
    halfNarrow = 5;
    narrowStdev = 2;
else
    halfNarrow = 7;
    narrowStdev = 3.5;
end
[xGridVals, yGridVals]=meshgrid(-halfNarrow:1:halfNarrow);
narrowGaussian = exp(-0.5 .* (xGridVals.^2+yGridVals.^2)/narrowStdev^2)/(narrowStdev*(sqrt(2*pi)));
narrowGaussianNormed=narrowGaussian./sum(sum(narrowGaussian));

for i = 1:size(inputMaps,3)
%     outputMaps(:,:,i) = conv2nan(inputMaps(:,:,i,1),narrowGaussianNormed);
    outputMaps(:,:,i) = nanconv(inputMaps(:,:,i,1),narrowGaussianNormed, 'nanout');
end
end

