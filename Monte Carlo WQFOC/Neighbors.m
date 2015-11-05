function [NeighborIndex,TreeModel] = Neighbors(X,Y)
% Function to find the neighbors of each vector, in a scattered grid   
% 
Index = cat(2,X(:),Y(:));

% constructs a kd-tree based on the position data in index
% Neighbors are determined on the basis of Euclidean distance 
TreeModel = KDTreeSearcher(Index);

% Return the neighboring position of each vector
[NeighborIndex,d] = knnsearch(TreeModel,Index,'k',25);
