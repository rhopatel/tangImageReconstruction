function P1responseGenerator() 

%generate Gabor filters and compute Gabor filter responses


%ENCODING
%% set parameters of Gabor wavelet
% param

imageSize = [1 1] * 32;

N  = 1;               % sampling points per octave
a0 = 2^(1/N);   % scaling factor
b0 = 1;         % the unit spatial interval

param.phai = 1.5;     % band width of gabor [octave]
param.aspectRatio = 1;% aspect ratio of the gabor filter

m = ceil(log2(imageSize(1)/2));
param.m = m*N;        % the number of scale (in 6 octaves)
K = 8;                % the number of sampling orientation
param.theta0 = pi/K;  % the step size of each angular rotation

param.N = N;
param.K = K;
param.a0 = a0;
param.b0 = b0;

% set the filter bank
for ii = 0: m
    for ll = 0: K-1

        filterSize = 4 * 2^ii;
        tx = 1:filterSize;
        ty = 1:filterSize;

        [x,y] = meshgrid(tx,ty); x = x'; y = y';
        ctr = ( 4 + 2^(-ii) ) / 2;

        GWfilter(ii+1,ll+1).even= GaborWavelet(x,y,ii,ctr,ctr,ll,param,0);
        GWfilter(ii+1,ll+1).odd = GaborWavelet(x,y,ii,ctr,ctr,ll,param,1);
    end
end
    save("GWfilter.mat","GWfilter");

%load in each image
%save responses for each 

for imageNumber = 1: 2250

    im2 = rgb2gray(imread(strcat(strcat('tang_stimuli/tang/NS/',num2str(imageNumber)), '.png')));

    r = centerCropWindow2d(size(im2),[64 64]);
    im2 = imcrop(im2, r);


    step = 0;
    steps = (m+1)*K;

    % tic
    for ii = 0: m

        for ll = 0: K-1

            if ii == 0
                even = myConv2(GWfilter(ii+1,ll+1).even, im2, 2^ii);
                odd = myConv2(GWfilter(ii+1,ll+1).odd , im2, 2^ii);
            else        
                even = myConv2(GWfilter(ii+1,ll+1).even, im2, 2^ii*3/2);
                odd = myConv2(GWfilter(ii+1,ll+1).odd , im2, 2^ii*3/2);
            end

            step = step + 1;

            evenResponses(imageNumber, ii+1, ll+1) = {even};
            oddResponses(imageNumber, ii+1, ll+1) = {odd};
        end
    end

end

    save("evenResponses.mat",'evenResponses');
    save("oddResponses.mat",'oddResponses');
    disp("done");


function res = myConv2(h, tmpX, step)
    %% preparation. X consists of original image surounded by zeros
    tmpImageSize = size(tmpX);
    filterSize = size(h);

    numFilter = ceil(((tmpImageSize(1) - filterSize(1))/2 + 1)/step) * 2 + 1;

    imageSize = step * (numFilter - 1) + filterSize(1);
    tmpZeros = zeros(imageSize);

    sizeX = size(tmpX);
    tx = imageSize / 2 - sizeX(1)/2 + 1: imageSize / 2 + sizeX(1)/2;
    tmpZeros(tx,tx) = tmpX;
    X = tmpZeros;

    %% 
    startingPoints(1,:) = 1: step: imageSize - filterSize(1) + 1;
    startingPoints(2,:) = 1: step: imageSize - filterSize(2) + 1;

    res = NaN(size(startingPoints,2));

    for ii = 1: size(startingPoints,2)
        for jj = 1: size(startingPoints,2)

            offset(1) = startingPoints(1,ii);
            offset(2) = startingPoints(2,jj);

            filterLength(1,:) = 0: filterSize(1)-1;
            filterLength(2,:) = 0: filterSize(2)-1;

            Xind = offset(1) + filterLength(1,:);
            Yind = offset(2) + filterLength(2,:);

            tmpX = X(Xind, Yind);
            dotProd = sum(sum(tmpX .* h));

            res(ii,jj) = dotProd;

        end
    end


