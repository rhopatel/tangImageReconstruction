function P2regressionTraining()

%load in image + neural response datasets
%compute regression with Gabor responses

mkA_NS_data = load('matdata/mkA_NS_data.mat').mkA_NS;

%mkA_PT_data = load('matdata/mkA_PT_data.mat').mkA_PT;
%mkE_NS_data = load('matdata/mkE_NS_data.mat').mkE_NS;
%mkE_PT_data = load('matdata/mkE_PT_data.mat').mkE_PT;

%disp(size(mkA_NS_data));
numPredictors = 1225;
numImages = 2250;

mkA_NS_averaged = mean(mkA_NS_data, 2, "omitnan");
neuralData = reshape(mkA_NS_averaged, numImages,numPredictors);


%monkey_A_correspondence = load('matdata/mkA_corr.mat').monkey_A_correspondence;
%mkE_PT_stimuli = load('matdata/mkE_PT_stimuli.mat').mkE_PT_stimuli;

evenResponses = load('evenResponses.mat').evenResponses;
oddResponses = load('oddResponses.mat').oddResponses;


PriorMdl = bayeslm(numPredictors);
parityNames = {'oddSummary','evenSummary'};

for parity = 1:2
    
    if (parity == 1)
        responses = oddResponses; 
    else
        responses = evenResponses;
    end 
    
    for i = 1:5
        for j = 1:8 
            
            groupFilterResponses = cell2mat(responses(:,i,j));
            groupLength = numel(groupFilterResponses)/numImages;
            groupFilterResponses = reshape(groupFilterResponses, numImages, groupLength);
            disp(size(groupFilterResponses));

            for k = 1:groupLength
                filterResponse = groupFilterResponses(:,k);

                %neural data: 2250 x 1225
                %filter response: 2250 x 1

                PosteriorMdl = estimate(PriorMdl,neuralData, filterResponse, "Display",false);
                groupRegressionModels(k) = {PosteriorMdl};
            end
            N = ceil(sqrt(numel(groupRegressionModels)));
            
            parityName = parityNames{parity};
            
            filename = strcat(strcat(fullfile(parityName,"regressionModels_"), num2str(i)), strcat("_", num2str(j)),".mat");
            modelGroup = reshape(groupRegressionModels, N, N);
            save(filename,"modelGroup");

            clear modelGroup;
            clear groupRegressionModels;
        end
    end
end
%save("regressionModels.mat", "regressionModels");


