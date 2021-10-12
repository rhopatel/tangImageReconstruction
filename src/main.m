
classdef main

methods(Static) 

function run(numPic)
    disp("starting machine learning...");
    
    main.addpaths();
    main.train();
    %main.testAll();
    %saveAll();

    main.test(numPic);
    main.save(numPic);
end

function train()
    disp("generating responses...");
    P0responseGenerator();
    disp("training...");
    P2regressionTraining();

end

function test(numPic)
    disp(strcat("testing on image #", num2str(numPic)));
    P3neuralDataConversion(numPic);
end


function testAll()
    disp("testing on all images");
    for i = 1:2250
	disp(strcat("testAll - testing on image #", num2str(i)));
        P3neuralDataConversion(i);
    end
end

function save(numPic)
    disp(strcat("saving image #", num2str(numPic)));
    P4imageReconstruction(numPic);
end

function saveAll()
    disp("saving all images");
    for i = 1:2250
        disp(strcat("saveAll - saving image #", num2str(i)));
        P4imageReconstruction(i);
    end
end

function runMetrics()
    disp("hi");
    metrics();
end

function addpaths()
    disp("adding paths");
    addpath code
    addpath data
    addpath tang_dataset
    addpath summary
    addpath output
    addpath extra
end

end
end
