function [U_C,V_C,Eval]  = FinalCorrector_PTV(U_Errored,V_Errored,U_Corrected,V_Corrected,X_Block,Y_Block,Ipos,NeighborIndex,GridSize)

% Function to dtermine and replace spurious vectors based on comparison
% between the curve fitted base field and the errored field
pass = 2;
tol = [2,1.8];
Eval = zeros(GridSize);
Score_X = zeros(GridSize);
Score_Y = zeros(GridSize);
U_C = U_Errored;
V_C = V_Errored;
for k=1:pass
    
    
    for i=1:GridSize
           
           
           if Eval(i)==0           
                 Ublock = U_C(NeighborIndex(i,1:end))';                            
                 Vblock = V_C(NeighborIndex(i,1:end))';
                 Ublock_Corr = U_Corrected(NeighborIndex(i,1:end)); 
                 Vblock_Corr = V_Corrected(NeighborIndex(i,1:end)); 
                %universal outlier detection
             
                [Ru]=FinalCorrector_sub_PTV (Ublock,X_Block(i,:)',Y_Block(i,:)',Ipos(i),Ublock_Corr);
                [Rv]=FinalCorrector_sub_PTV(Vblock,X_Block(i,:)',Y_Block(i,:)',Ipos(i),Vblock_Corr);
                 
               
                if Ru > tol(k) || Rv > tol(k)
                    %UOD threshold condition
                    U_C(i)=nan;
                    V_C(i)=nan;
                    Eval(i)=k;
                end

            end

        
    end
end
U_C(isnan(U_C))= U_Corrected(isnan(U_C));
V_C(isnan(V_C))= V_Corrected(isnan(V_C));

