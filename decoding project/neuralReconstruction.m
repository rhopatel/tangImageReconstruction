function neuralReconstruction(numPic) 
%load in any given image neural responses
%use the models to forecast the Gabor response and reconstruct
mkA_NS_data = load('matdata/mkA_NS_data.mat').mkA_NS;
mkA_NS_averaged = mean(mkA_NS_data, 2, "omitnan");

randomData = mkA_NS_averaged(numPic);


regressionModels = load('responseRegression.mat').regressionModels;
GWfilter = load("GWfilter.mat").GWfilter;

for i = 1:5
    for j = 1:8 
        groupRegressionModels = cell2mat(regressionModels{i,j}); 
        groupLength = numel(groupRegressionModels);
        groupRegressionModels = reshape(groupRegressionModels, 1, groupLength);
        for k = 1:groupLength
            PosteriorMdl = groupRegressionModels(k);
            filterResponses(k) = forecast(PosteriorMdl, randomData);
            %do for all gabor filter responses ^
        end
         N = ceil(sqrt(numel(filterResponses)));
         res(i,j) = {reshape(filterResponses, N, N)};

    end
end

disp(res);
%RECONSTRUCTION
h = waitbar(0, 'Now reconstructing...');

    tmpImage = zeros(imageSize);
    tmpImageEven = zeros(imageSize);
    tmpImageOdd  = zeros(imageSize);

    step  = 0;
    steps = (m+1)*K;

    for ii = 0: m

        for ll = 0: K-1
            %{
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
            %}
            
            tmpResponse = res(ii+1, ll+1);
            tmpGWfilter = GWfilter(ii+1,ll+1).even;
            if ii == 0
                tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii, imageSize);
                tmpEven = tmpEven * 2/3;
            else
                tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii*3/2, imageSize);
            end
           
            tmpImageEven = tmpImageEven + tmpEven;
 

            step = step + 1;
            waitbar(step / steps)
        end
    end
    resultImage = tmpImageEven;
    close(h)

    %% show the original image and result
    figure
    colormap gray

    subplot(2,2,1)
    clim = [0 255];
    imagesc(randomImage', clim)
    axis xy square
    set(gca, 'TickDir', 'out')
    title('original image')

    subplot(2,2,2)
    % clim = ([0 255] - meanValue)  * 23.2960;
    % imagesc(resultImage', clim)
    imagesc(resultImage')
    axis xy square
    set(gca, 'TickDir', 'out')
    title('new reconstructed image')



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