function [R,RI]=ValidityEstimator_sub_PTV(Block,Xblock,Yblock,Ipos)

%minimum deviaiton
e=0.1; 

x=Block(Ipos);
Block(Ipos)=nan;



if length(isnan(Block))<=floor(length(Block)/3)
    % when no valid neighbors are found
    R = inf;
    RI= 0;
else
    
    Distances = ((Xblock-Xblock(Ipos)).^2 + (Yblock-Yblock(Ipos)).^2).^0.5;
    Median_Dist = nanmedian(Distances);

    ea = - Median_Dist + (Median_Dist^2 + 4*e)^0.5; 
    Block_Weighted = Block./(Distances + ea);
    X_Weighted = x/(Median_Dist+ea);
    % Distance wighted normalized median score
    R = abs(X_Weighted - nanmedian(Block_Weighted))/(nanmedian(abs( Block_Weighted - nanmedian(Block_Weighted) )) + ea);
    % The inverse of the distance wighted median score is expected to act
    % as a measure of the validity of the vector
    RI = (nanmedian(abs( Block_Weighted - nanmedian(Block_Weighted) )) + ea)/(abs(X_Weighted - nanmedian(Block_Weighted))+ea) ;
    
   
   
end

end
