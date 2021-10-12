function metrics()
	disp("for each neuron")
	groundTruth = []

	[oddResponses, evenResponses] = P1responseGenerator()
		for j = 1:1225
			disp(j)
		end
	predicted = []
	
	for i = 1:2250
		disp(i)		
		%[oddReconstruction, evenReconstruction] = P3imageReconstruction(j)
		for j = 1:1225
			disp(j)
		end
				
end
