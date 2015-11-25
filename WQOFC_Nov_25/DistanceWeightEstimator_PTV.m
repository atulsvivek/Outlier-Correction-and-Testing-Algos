function [DistScore] =  DistanceWeightEstimator_PTV(X,Y,Ipos)
% Function to evaluate the distance score for a given array of vectors
DistScore = 1./((X-X(Ipos)).^2 +(Y-Y(Ipos)).^2);
DistScore(Ipos) = 0;
DistScore = DistScore/max(DistScore(:));