function P6summaryHistogram() 

oddSummary = load("oddSummary.mat").oddSummary;
evenSummary = load("evenSummary.mat").evenSummary;

figure

for parity = 1:2

    if (parity == 1) 
       summary = oddSummary;
    else 
       summary = evenSummary;  
    end
    
    
    numBins = 25;
    
    for i = 2:5
        for j = 1:8 
            
            summaryStatistics = summary(i,j);
            summaryStatistics = reshape(summary, 1, numel(summaryStatistics));
            for k = 1:numel(summaryStatistics)
                summaryStat = summaryStatistics(k).MarginalDistribution;
                X = summaryStat;
            end

        end
    end
    histogram(X, numBins);
    %plot histogram
end