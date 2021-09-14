function P3neuralDataConversion(numPic) 

%load in any given image neural responses
%use the models to forecast the Gabor response and reconstruct
mkA_NS_data = load('tang_dataset/tang_data/mkA_NS_data.mat').mkA_NS;
mkA_NS_averaged = reshape(mean(mkA_NS_data, 2, "omitnan"), 2250, 1225);

selectedData = mkA_NS_averaged(numPic, :);

parityNames = {'odd','even'};


for parity = 1:2
    for i = 1:5
        for j = 1:8 
            parityName = parityNames{parity};

            filename = strcat(strcat(fullfile(parityName,"regressionModels_"), num2str(i)), strcat("_", num2str(j)),".mat");
            %disp("loading file..")
            groupRegressionModels = load(strcat("data/models/", filename)).modelGroup;
            %disp("load")
            nrow = size(groupRegressionModels, 1);
            ncol = size(groupRegressionModels, 2);

            for k = 0:numel(groupRegressionModels)
                %disp(k)
                a = mod(k, nrow)+1;
                b = mod(k, ncol)+1;
                %disp("forecasting");
                model = groupRegressionModels(a,b);
                responses = forecast(model{1}, selectedData);
                %disp("forecasted");
                %do for all gabor filter responses ^
                if (parity == 1) 
                    oddReconstruction(i,j) = responses;

                 else 
                    evenReconstruction(i,j) = responses;
       
                 end
            end

        end
    end
end
save(strcat(strcat("data/reconstructions/oddReconstruction_", num2str(numPic)), ".mat"), "oddReconstruction", "-v7.3");
save(strcat(strcat("data/reconstructions/evenReconstruction_", num2str(numPic)),".mat"), "evenReconstruction", "-v7.3");
