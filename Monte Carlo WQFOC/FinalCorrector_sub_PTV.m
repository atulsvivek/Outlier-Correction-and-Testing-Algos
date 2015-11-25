function [R]=FinalCorrector_sub_PTV (Block,Xblock,Yblock,Ipos,Block_Corr)

%minimum variance assumption
e=0.1; 

%remove value from query point
x=Block(Ipos);
Block(Ipos)=nan;

%remove any erroneous points

if length(isnan(Block))<=floor(length(Block)/3)
    %return negative threshold value if no valid vectors in block
    R = inf;
    
else
    %return the median deviation normalized to the MAD
    Distances = ((Xblock-Xblock(Ipos)).^2 + (Yblock-Yblock(Ipos)).^2).^0.5;
    Median_Dist = nanmedian(Distances);

    ea = - Median_Dist + (Median_Dist^2 + 4*e)^0.5; 
    
    
   
   
    Block_Weighted = Block_Corr./(Distances + ea);
    X_Weighted = x/(Median_Dist+ea);
    R = abs(X_Weighted - nanmedian(Block_Weighted))/(nanmedian(abs( Block_Weighted - nanmedian(Block_Weighted) )) + ea);
    
   
   
end

end
