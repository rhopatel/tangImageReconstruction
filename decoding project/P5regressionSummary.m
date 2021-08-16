function P5regressionSummary() 

parityNames = {'odd','even'};

for parity = 1:2
    for i = 2:5
        for j = 1:8 
            parityName = parityNames{parity};

            filename = strcat(strcat(fullfile(parityName,"regressionModels_"), num2str(i)), strcat("_", num2str(j)),".mat");
            groupRegressionModels = load(filename).modelGroup;

            groupLength = numel(groupRegressionModels);
            groupRegressionModels = reshape(groupRegressionModels, 1, groupLength);
            for k = 1:groupLength
                PosteriorMdl = groupRegressionModels(k);
                summary(k) = summarize(PosteriorMdl{1});
                %do for all gabor filter responses ^
            end
             N = ceil(sqrt(numel(summary)));
             if (parity == 1) 
                oddSummary(i,j) = {reshape(summary, N, N)};
             else 
                evenSummary(i,j) = {reshape(summary, N, N)};       
             end

        end
    end
end
save("oddSummary.mat", "oddSummary");
save("evenSummary.mat", "evenSummary");