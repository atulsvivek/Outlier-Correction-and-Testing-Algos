function [Score_X,Score_Y]  = ValidtyEstimator_PTV(U_Errored,V_Errored,X_Block,Y_Block,Ipos,NeighborIndex,GridSize)

% Function to determine validty scores for elements 
% Based on distance weighted normalized median test 

% With the following parameters , a two pass evaluation is done, to obtain
% the validity scores
pass = 2;
tol = [3,2];
Eval = zeros(GridSize);
Score_X = zeros(GridSize);
Score_Y = zeros(GridSize);
for k=1:pass
    
    
    for i=1:GridSize
           
           
           if Eval(i)==0           
                % Neighboring elemnts found using Neighbors.m
                Ublock = U_Errored(NeighborIndex(i,1:end));                            
                 Vblock = V_Errored(NeighborIndex(i,1:end));
                
             
                [Ru,RuI]=ValidityEstimator_sub_PTV (Ublock,X_Block(i,:)',Y_Block(i,:)',Ipos(i));
                [Rv,RvI]=ValidityEstimator_sub_PTV(Vblock,X_Block(i,:)',Y_Block(i,:)',Ipos(i));
                
                % The validity score
                Score_X(i) = RuI;
                Score_Y(i) = RvI;
                
                % Thresholding criterion can be used to improve the
                % viabiltiy of RuI and RvI as measures of validity of the
                % velocity value
                if Ru > tol(k) || Rv > tol(k)
                    
                    U_Errored(i)=nan;
                    V_Errored(i)=nan;
                    Eval(i)=k;
                end

            end

        
    end
end
% Scaling is done with respect to the maximum value in the field
Score_X = Score_X/max(Score_X(:));
Score_Y = Score_Y/max(Score_Y(:));
