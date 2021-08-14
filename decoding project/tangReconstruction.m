function returnValue = tangReconstruction()


mkA_NS_data = load('matdata/mkA_NS_data.mat').mkA_NS;

%mkA_PT_data = load('matdata/mkA_PT_data.mat').mkA_PT;
mkE_NS_data = load('matdata/mkE_NS_data.mat').mkE_NS;
%mkE_PT_data = load('matdata/mkE_PT_data.mat').mkE_PT;

%disp(size(mkA_NS_data));

mkA_NS_averaged = mean(mkA_NS_data, 2, "omitnan");
mkA_NS_averaged = reshape(mkA_NS_averaged, 2250,1225);

returnValue = mkA_NS_averaged;

disp(size(mkA_NS_averaged));

%monkey_A_correspondence = load('matdata/mkA_corr.mat').monkey_A_correspondence;
%mkE_PT_stimuli = load('matdata/mkE_PT_stimuli.mat').mkE_PT_stimuli;

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
        % tx = 1:filterSize*2;
        % ty = 1:filterSize*2;
        [x,y] = meshgrid(tx,ty); x = x'; y = y';
        ctr = ( 4 + 2^(-ii) ) / 2;
        % ctr = ( 8 + 2^(-ii) ) / 2;

        GWfilter(ii+1,ll+1).even= GaborWavelet(x,y,ii,ctr,ctr,ll,param,0);
        GWfilter(ii+1,ll+1).odd = GaborWavelet(x,y,ii,ctr,ctr,ll,param,1);
    end
end


%load in each image
%save responses for each 

for imageNumber = 1: size(mkA_NS_averaged,1)

    im2 = rgb2gray(imread(strcat(strcat('tang_stimuli/tang/NS/',num2str(imageNumber)), '.png')));

    r = centerCropWindow2d(size(im2),[32 32]);
    im2 = imcrop(im2, r);

    %meanValue = mean(im2(:));


    % tx = 1:imageSize(1); % the width of the image
    % ty = 1:imageSize(2); % the height of the image
    % [x y] = meshgrid(tx,ty); x = x'; y = y';

    step = 0;
    steps = (m+1)*K;
    %h = waitbar(0, 'Now analyzing...');
    %responses = cell(2250, m+1, K);
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
            %waitbar(step / steps)

            responses(imageNumber, ii+1, ll+1) = {val};

        end
    end
    % toc
      
    
    param.m = param.m+1;

    %disp(size(res));
    %returnValue = res;
    %close(h);
end
%returnValue = responses;

disp(numel(responses));
responses = reshape(responses, 2250, 40);

disp(numel(responses));
PriorMdl = bayeslm(1225);
PosteriorMdl = estimate(PriorMdl,mkA_NS_averaged, responses);

randomImage = mKa_NS_averaged(1);
res = forecast(PosteriorMdl, randomImage);


%RECONSTRUCTION
h = waitbar(0, 'Now reconstructing...');

    tmpImage = zeros(imageSize);
    tmpImageEven = zeros(imageSize);
    tmpImageOdd  = zeros(imageSize);

    step  = 0;
    steps = (m+1)*K;

    for ii = 0: m

        for ll = 0: K-1

            tmpResponse = res(ii+1, ll+1).even;
            tmpGWfilter = GWfilter(ii+1,ll+1).even;
            if ii == 0
                tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii, imageSize);
                tmpEven = tmpEven * 2/3;
            else
                tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii*3/2, imageSize);
            end
            tmpResponse = res(ii+1, ll+1).odd;
            tmpGWfilter = GWfilter(ii+1,ll+1).odd;
            if ii == 0
                tmpOdd  = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii, imageSize);
                tmpOdd  = tmpOdd * 2/3;
            else
                tmpOdd  = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii*3/2, imageSize);
            end
            tmpImageEven = tmpImageEven + tmpEven;
            tmpImageOdd  = tmpImageOdd  + tmpOdd;

            step = step + 1;
            waitbar(step / steps)

        end
    end
    resultImage = tmpImageEven + tmpImageOdd;
    close(h)

    %% show the original image and result
    figure
    colormap gray

    subplot(2,2,1)
    clim = [0 255];
    imagesc(im2', clim)
    axis xy square
    set(gca, 'TickDir', 'out')
    title('original image')

    subplot(2,2,2)
    % clim = ([0 255] - meanValue)  * 23.2960;
    % imagesc(resultImage', clim)
    imagesc(resultImage')
    axis xy square
    set(gca, 'TickDir', 'out')
    title('(Gabor) reconstructed image')

    %{
    subplot(2,2,3)
    % imagesc(tmpImageEven',clim/2)
    imagesc(tmpImageEven')
    axis xy square
    set(gca, 'TickDir', 'out')
    title('reconstructed image(even)')

    subplot(2,2,4)
    % imagesc(tmpImageOdd',clim/2)
    imagesc(tmpImageOdd')
    axis xy square
    set(gca, 'TickDir', 'out')
    title('reconstructed image(odd)')
    %}
    
%useless(imageSize, res);

%returnValue = res;


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


function res = myReconstruction2(h, X, step, tmpImageSize)
    % preparation. X consists of original image surounded by zeros
    filterSize = size(h);

    numFilter = ceil(((tmpImageSize(1) - filterSize(1))/2 + 1)/step) * 2 + 1;
    imageSize = step * (numFilter - 1) + filterSize(1);
    tmpRes = zeros(imageSize);


    startingPoints(1,:) = 1: step: imageSize - filterSize(1) + 1;
    startingPoints(2,:) = 1: step: imageSize - filterSize(2) + 1;

    for ii = 1: size(startingPoints,2)
        for jj = 1: size(startingPoints,2)

            offset(1) = startingPoints(1,ii);
            offset(2) = startingPoints(2,jj);

            filterLength(1,:) = 0: filterSize(1)-1;
            filterLength(2,:) = 0: filterSize(2)-1;

            Xind = offset(1) + filterLength(1,:);
            Yind = offset(2) + filterLength(2,:);

            tmpRes(Xind, Yind) = tmpRes(Xind, Yind) + X(ii,jj) * h;
        end
    end

    tx = imageSize / 2 - tmpImageSize/2 + 1: imageSize / 2 + tmpImageSize/2;
    res = tmpRes(tx, tx);

