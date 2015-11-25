function [Score] = SimilarityEstimator_PTV(Block,Ipos)
% Function to estimate scores for each element in a Block based on the
% similarity with Block(IPos)
e=0.1; % minimum tolerance is given to prevent inf values
Score = 1./(abs(Block - Block(Ipos))+e);
Score(Ipos)=nan;
Score = Score/max(Score(:));
