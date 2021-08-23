function P4imageReconstruction(numPic) 

    oddReconstruction = load("data/oddReconstruction.mat").oddReconstruction;
    evenReconstruction = load("data/evenReconstruction.mat").evenReconstruction;
    
    GWfilter = load("data/GWfilter.mat").GWfilter;
    

    %RECONSTRUCTION
    h = waitbar(0, 'Now reconstructing...');
        imageSize = [1 1] * 32;

        tmpImage = zeros(imageSize);
        tmpImageEven = zeros(imageSize);
        tmpImageOdd  = zeros(imageSize);

        m = ceil(log2(imageSize(1)/2));
        K = 8; 
  
        step  = 0;
        steps = (m+1)*K;

        for ii = 1: m

            for ll = 0: K-1

                tmpResponse = cell2mat(evenReconstruction(ii+1, ll+1));
                tmpGWfilter = GWfilter(ii+1,ll+1).even;
                if ii == 0
                    tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii, imageSize);
                    tmpEven = tmpEven * 2/3;
                else
                    tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii*3/2, imageSize);
                end
                tmpResponse = cell2mat(oddReconstruction(ii+1, ll+1));
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

        h = waitbar(0, 'Now Gabor filter reconstruction...');
        imageSize = [1 1] * 32;

        tmpImage = zeros(imageSize);
        tmpImageEven = zeros(imageSize);
        tmpImageOdd  = zeros(imageSize);

        m = ceil(log2(imageSize(1)/2));
        K = 8; 
  
        step  = 0;
        steps = (m+1)*K;

        for ii = 0: m

            for ll = 0: K-1

                tmpResponse = cell2mat(evenReconstruction(ii+1, ll+1));
                tmpGWfilter = GWfilter(ii+1,ll+1).even;
                if ii == 0
                    tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii, imageSize);
                    tmpEven = tmpEven * 2/3;
                else
                    tmpEven = myReconstruction2(tmpGWfilter, tmpResponse, 2^ii*3/2, imageSize);
                end
                tmpResponse = cell2mat(oddReconstruction(ii+1, ll+1));
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
        
        im2 = rgb2gray(imread(strcat(strcat('tang_stimuli/tang/NS/',num2str(numPic)), '.png')));
        r = centerCropWindow2d(size(im2),[64 64]);
        im2 = imresize(imcrop(im2, r), [32 32]);

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
        title('new reconstructed image')
        
        
        %
        %subplot(2,2,3)
        % clim = ([0 255] - meanValue)  * 23.2960;
        % imagesc(resultImage', clim)
        %imagesc(resultImage')
        %axis xy square
        %set(gca, 'TickDir', 'out')
        %title('Gabor filter reconstruction image')
        
        %

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
    end
    


