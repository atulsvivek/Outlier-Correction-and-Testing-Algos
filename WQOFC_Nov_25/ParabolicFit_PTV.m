function [UC,UCRes] = ParabolicFit_PTV(Block,Weight,X,Y,Ipos);
% Function to Fit a parabolic surface to the given velocity data 
% under the given  weights, and to evaluate the function value at the
% desired location
p = QuadraticFit2D(X,Y,Block,Weight);
UC = QuadraticEval2D(p,X(Ipos),Y(Ipos));
UCRes = abs((UC - Block(Ipos)));
