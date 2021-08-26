function main()
    disp("starting machine learning...");
    
    addpath code
    addpath data
    addpath extra
    addpath output
    addpath tang_dataset
    addpath summary

    train();
    %test();
end

function train()
    P1responseGenerator();
    P2regressionTraining();

end

function test()
    for i = 1:2250
        P3neuralDataConversion(i);
    end
end



