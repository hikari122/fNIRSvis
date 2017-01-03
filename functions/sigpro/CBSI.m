function [ oxy0,deoxy0 ] = CBSI( oxy,deoxy )
% CBSI calculates the Correlation Based Signal Improvement [1]
% The method is "based on the principle that the concentration changes of
% oxygenated and deoxygenated hemoglobin" - that was contaminated by motion
% noise - "should be negatively correlated." 
% 
% [1] http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2818571/

alpha = std(oxy)./std(deoxy);
oxy0 = oxy - alpha .* deoxy;
oxy0 = oxy0/2;
deoxy0=-oxy0./alpha;


