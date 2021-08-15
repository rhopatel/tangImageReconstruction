function neuralConversion(numPic) 
%load in any given image neural responses
%use the models to forecast the Gabor response and reconstruct
mkA_NS_data = load('matdata/mkA_NS_data.mat').mkA_NS;
mkA_NS_averaged = reshape(mean(mkA_NS_data, 2, "omitnan"), 2250, 1225);

selectedData = mkA_NS_averaged(numPic, :);


%regressionModels = load('responseRegression.mat').regressionModels;

for i = 2:5
    for j = 1:8 
        
        filename = strcat(strcat(fullfile("res","regressionModels_"), num2str(i)), strcat("_", num2str(j)),".mat");
        groupRegressionModels = load(filename).modelGroup;
        
        groupLength = numel(groupRegressionModels);
        groupRegressionModels = reshape(groupRegressionModels, 1, groupLength);
        for k = 1:groupLength
            PosteriorMdl = groupRegressionModels(k);
            filterResponses(k) = forecast(PosteriorMdl{1}, selectedData);
            %do for all gabor filter responses ^
        end
         N = ceil(sqrt(numel(filterResponses)));
         reconstruction(i,j) = {reshape(filterResponses, N, N)};

    end
end
save("reconstruction.mat", "reconstruction");
