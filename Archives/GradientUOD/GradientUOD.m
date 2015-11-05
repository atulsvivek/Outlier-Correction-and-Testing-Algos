function [U_Corrected, V_Corrected, CorrectedLocations,EX,EY] = GradientUOD(U_Errored,V_Errored,Tolerance)

% Author - Atul S Vivek 
% Date   - jun 18 2015
% Function To detect outliers in a 2D velocity field 2D using 
% gradient based UOD score. 
% Ensure that GradientUOD_sub is accessible for this function.

% U_Errored   -  The X velocity component of the erroneous vector field
% V_Errored   -  The Y velocity component of the erroneous vector field
% Tolerance   -  The tolerance array where number fo elements in the array
%                gives the number of passes.
% U_Corrected -  Corrected X velocity component vector field 
% V_Corrected -  Corrected Y velocity component vector field 
% CorrectedLocations - Locations identified as erroneous the number
%                      indicates the pas in which the vector was identified
%                      as spurious
% EX - The Gradient UOD Score for X component of the element in each iteration
% EY - The Gradient UOD Score for Y component of the element in each iteration

%------------------------------ Example -----------------------------------
%
% Load U_Errored, V_Errored into memory
% Tolerance = [1.2,1.4,1.6]
% [U_Corrected, V_Corrected, CorrectedLocations,EX,EY] = GradientUOD(U_Errored,V_Errored,Tolerance)
%
%--------------------------------------------------------------------------


% Initialization 
GridSize = size(U_Errored);
PassNumber = length(Tolerance);
U_Corrected = U_Errored;
V_Corrected = V_Errored;
CorrectedLocations = zeros(GridSize);
EX = zeros(GridSize(1),GridSize(2),PassNumber);
EY = zeros(GridSize(1),GridSize(2),PassNumber);

Eval =zeros(size(U_Errored));
t=3*ones(2);
tol=[3,2];


% Number of passes to be performed
for k =1:PassNumber
   
    % Minimum size of the grid to be used for validation
    % MinELNo = 3 - 3 X 3 Grid with 8 neighboring elements. 
    MinElNo = 5 ;
    
    for i = 1:GridSize(1) 
        for j = 1:GridSize(2)
            
    
            if(CorrectedLocations(i,j) == 0  )   
                
                ElNo = ones(2,1)*floor((MinElNo-1)/2);
                condition =0;
                
                % To obtain a Grid of valid (not yet invalidated) neighboring elements. 
                while(condition ==0)
                    
                    condition =1;
                    % To find bounds of the grid
                    Imin = max([i-ElNo(1)  1   ]);
                    Imax = min([i+ElNo(1) GridSize(1)]);
                    Jmin = max([j-ElNo(2) 1   ]);
                    Jmax = min([j+ElNo(2) GridSize(2)]);
                   
                    Iind = Imin:Imax;
                    Jind = Jmin:Jmax;
                    
                    % The evaluvation block obtained
                    Ublock = U_Corrected(Iind,Jind);
                    Vblock = V_Corrected(Iind,Jind);
                    
                    % To count the number of valid Elements in each row/coloumn 
                    [RowU,ColU] = find(~isnan(Ublock));
                    [RowV,ColV] = find(~isnan(Vblock));
                    
                    % To find the row/couloumn with minimum numebr of valid
                    % elements.
                    MinElRow = min(min(hist(RowU,unique(RowU))),min(hist(RowV,unique(RowV))));
                    MinElCol = min(min(hist(ColU,unique(ColU))),min(hist(ColV,unique(ColV)))) ;   
                   
                    % Condition for number of elements in each couloum -
                    % Sufficient number of elements or too many iterations
                    if(MinElCol >= MinElNo ||ElNo(1)> 3*floor((MinElNo-1)/2) );
                        condition = condition * 1;
                    else
                       ElNo(1) = ElNo(1)+1;
                        condition = condition * 0;
                    end
                    
                    % Condition for number of elements in each row -
                    % Sufficient number of elements or too many iterations 
                    if(MinElRow >= MinElNo || ElNo(2)> 3*floor((MinElNo-1)/2))
                        condition = condition * 1;
                    else
                        ElNo(2) = ElNo(2)+1;
                        condition = condition * 0;
                   end                     
                end
                
                % Position of the current element in the grid validation obtained 
                Ipos = find(Iind==i);
                Jpos = find(Jind==j);
                
                % Function to evaluvate Gradient UOD Score
                [GradientUODMetric_U]=GradientUOD_sub(Ublock,Ipos,Jpos);
                [GradientUODMetric_V]=GradientUOD_sub(Vblock,Ipos,Jpos);
                
                % Gradient UOD scores for each iteration
                EX(i,j,k) = GradientUODMetric_U;
                EY(i,j,k) = GradientUODMetric_V;
                
                % Thresholding criterion - average of the Scores for U and V
                % components is used for detecting an outlying vector 
                if (GradientUODMetric_U + GradientUODMetric_V) > 2*Tolerance(k);
                    U_Corrected(i,j)=nan;
                    V_Corrected(i,j)=nan;
                    CorrectedLocations(i,j)=k;
                end
            
            end     
        end
    end  
end



