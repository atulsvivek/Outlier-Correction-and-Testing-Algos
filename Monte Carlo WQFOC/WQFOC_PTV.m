function [U_Corrected,V_Corrected,U_Residual,V_Residual]= WQFOC_PTV(U_Errored,V_Errored,X,Y)

% Function to correct errors in velocity field using the Weighted Quadatic
% Fit method.It can handle both gridded and scattered data. hence can be
% used for error correction in PIV as well as PTV.

% U_Errored - The X velocity data to be corrected
% V_Errored - The Y velocity data to be corrected
% X ,Y  - matrices or vectors containing the x and Y coordinate of the 
%         points, where velocity data is defined
% U_Corrected - The corrected X velocity field
% V_Corrected - The corrected Y velocity field
% U_Residual  - The percentage deviation between the corrected value and
%               the original value of X velocity
% V_Residual  - The percentage deviation between the corrected value and
%               the original value of Y velocity
warning('off','all')


U_Corrected = U_Errored(:);
V_Corrected = V_Errored(:);

GridSize =size(U_Corrected);

V_Residual = zeros(GridSize);
U_Residual = zeros(GridSize);

X = X(:);
Y = Y(:);

% To find neighboring vectors for each vector
[NeighborIndex] = Neighbors(X,Y);



condition = 0;
Trial =0;

for i =1:GridSize(1)
    
    Ipos(i) = find(NeighborIndex(i,1:end)==i);
    X_Block(i,:) = X(NeighborIndex(i,1:end));
    Y_Block(i,:) = Y(NeighborIndex(i,1:end));
    % Estimates the distance weight that has to be applied for the 
    %  neighbors of each vector
   [DistScore(i,:)] =  DistanceWeightEstimator_PTV( X_Block(i,:),Y_Block(i,:),Ipos(i)); 
    
end    



while(condition ==0)
    
    % Produces a score for each vector based on the the distance weighted Normalized median Test 
    [Score_XM,Score_YM] = ValidtyEstimator_PTV(U_Corrected,V_Corrected,X_Block,Y_Block,Ipos,NeighborIndex,GridSize);
    
    for i = 1:GridSize(1)
      
    
            % Produces a score that quantifies the similarity between the 
            % Neighboring velocities and the velocity under scrutiny
            
            [Score_XN] = SimilarityEstimator_PTV(U_Corrected(NeighborIndex(i,1:end)) ,Ipos(i)); 
            [Score_YN] = SimilarityEstimator_PTV(V_Corrected(NeighborIndex(i,1:end)) ,Ipos(i)); 
             
            
            % Validity scores of neighbors
            Score_XM_Local = Score_XM(NeighborIndex(i,1:end));
            Score_YM_Local = Score_YM(NeighborIndex(i,1:end));
            
            % Distance weighting
            Weight_X = DistScore(i,:)'.*Score_XM_Local.*Score_XN;
            Weight_Y = DistScore(i,:)'.*Score_YM_Local.*Score_YN;
        
            Weight_X(Ipos(i))=0;
            Weight_Y(Ipos(i))=0;
            
            
            % Quadratic curve fitting is done for the locality and 
            % using this ,the velocity value being inspected is found    
            [UC,UCRes] = ParabolicFit_PTV(U_Corrected(NeighborIndex(i,1:end)),Weight_X,X_Block(i,:)',Y_Block(i,:)',Ipos(i));
            [VC,VCRes] = ParabolicFit_PTV(V_Corrected(NeighborIndex(i,1:end)),Weight_Y,X_Block(i,:)',Y_Block(i,:)',Ipos(i));
       
            U_Corrected(i) = UC;
            V_Corrected(i) = VC;
       
            U_Residual(i) = UCRes;
            V_Residual(i) = VCRes;
       
              
        
    end
    % Exit condition : The variation in the field between iterations is marginal 
    if((max(U_Residual(:))< 0.1 && max(V_Residual(:))< 0.1) || Trial ==50 )
    
        condition =1;
    end
    Trial =Trial+1;
    
    
  % disp(strcat(strcat('Trial Number - ' , num2str(Trial)),' is done !'));
end

U_Corrected(abs((U_Corrected-U_Errored(:))./U_Corrected(:)) <= 0.05) = U_Errored(abs((U_Corrected-U_Errored(:))./U_Corrected(:)) <= 0.05);
V_Corrected(abs((V_Corrected-V_Errored(:))./V_Corrected(:)) <= 0.05) = V_Errored(abs((V_Corrected-V_Errored(:))./V_Corrected(:)) <= 0.05);

% Reshaping the velocity data to the original structure
U_Corrected = reshape(U_Corrected,size(U_Errored));
V_Corrected = reshape(V_Corrected,size(V_Errored));

U_Residual = abs((U_Corrected - U_Errored)./U_Corrected)*100;
V_Residual = abs((V_Corrected - V_Errored)./V_Corrected)*100;

