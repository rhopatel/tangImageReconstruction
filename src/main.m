function main()
    disp("hi");
    
    train();
    test();
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



