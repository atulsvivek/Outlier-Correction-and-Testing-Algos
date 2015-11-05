function [U_Errored, V_Errored, ErrorLocations,X,Y] = ClusteredErrorGenerator(MatFileAddress,PercentageError,NoisePercentage)

% Author - Atul S Vivek 
% Function to Impose Clustered outliers in a velocity field.
% Cluster sizes follow a normal distribution defined in Wang et al. 2014
% The error magnitudes also are in accordance with Wang et al. 2014


% U_Errored - Contains the contaminated X velocity field  
% V_Errored - Contains the contaminated Y velocity field  
% ErrorLocation - Contains the Locations of the Erroneous vectors in the
%                 Field
% X - The matrix containing the x positions of the each vector.
% Y - The matrix containing the y positions of the each vector.
% X and Y should have the same size as U and V. 

% MatFileAddress  - Address of the .mat file containing the velocity data
% PercentageError - The percantage of vectors that are to be contaminated
% NoisePercentage - Gaussian noise to be added to the velocity field                  

%----------------------- Format of the .mat file---------------------------
% Should contain a two matrices U and V along with the position matrices  
% X and Y.
%--------------------------------------------------------------------------

%---------------------------- Example -------------------------------------
% MatFileAddress  = 'CVFVelocityField.mat' 
% PercentageError = 20;
% NoisePercentage = 10;
%[U_Errored, V_Errored, ErrorLocations,X,Y] = ClusteredErrorGenerator(....
%               ....MatFileAddress,PercentageError,NoisePercentage)
%--------------------------------------------------------------------------

% Distribution parameters 
  A = 0.4;
  Sigma = 2.8; 
  MaxSize =15; % Maximum cluster size
  Probability = A*exp(-(1:MaxSize).^2/(2*Sigma^2));
  Probability = Probability/sum(Probability); % probability of occurance of 
                                              % cluster sizes
  Deviation =0.3; % Maximum fractional deviations between spurious vectors 
                  % in the same cluster  




% To open the mat file
if ~exist(MatFileAddress, 'file') % File not Found condition
  message = sprintf('%s does not exist', MatFileAddress); 
  uiwait(warndlg(message));
else
 matobj =  load(MatFileAddress);
end

% Extract Parameters From the matfile  
U = matobj.U;
V = matobj.V;
X =matobj.X;
Y =matobj.Y;
GridSize = size(U);


% Number of spurious vectors 
MaximumErrorNumber=round((PercentageError/100)*GridSize(1)*GridSize(2));    
RandNum = rand(MaximumErrorNumber);                                                                                             
ClusterSizes = arrayfun(@(TempVar)sum(TempVar >= cumsum([0, Probability])), RandNum);


ErrorLocations =zeros(GridSize);
i = 1;
% Maximum error is limited by the interrogation window size.
% Refer Wang et al. 2014
MaximumErrorU = max(max(abs(U(:))),max(abs(V(:))));
MaximumErrorV = max(max(abs(U(:))),max(abs(V(:))));

U_Errored = U;
V_Errored = V;

% Noise generation
V_Noise = NoisePercentage/100*MaximumErrorV*randn(GridSize);
U_Noise = NoisePercentage/100*MaximumErrorU*randn(GridSize);
U_Errored = U_Errored+U_Noise;
V_Errored = V_Errored+V_Noise;


while(sum(ErrorLocations(:))<= MaximumErrorNumber)
    
    % to find the location of the central vector of the cluster
    ErrorNumberFilter = zeros(GridSize);
    ErrorNumberFilter(randperm(numel(ErrorNumberFilter), 1)) = 1;
    
    if(ErrorLocations(find(ErrorNumberFilter)) ==0)
        
        % To obtain locations around the central spurious vector
        ConvolutionFilterSize = max(ceil(sqrt(ClusterSizes(i))),3);
        FilterU = ( 1- Deviation +  2*Deviation*rand(ConvolutionFilterSize));
        FilterV = ( 1- Deviation +  2*Deviation*rand(ConvolutionFilterSize));
        FilterCommon = zeros(ConvolutionFilterSize);
        FilterCommon(randperm(numel(FilterCommon),ClusterSizes(i))) = 1;
        ErrorU   = conv2(ErrorNumberFilter,FilterU.*FilterCommon,'same');
        ErrorV   = conv2(ErrorNumberFilter,FilterV.*FilterCommon,'same');
    
        ErrorLocations(find(ErrorU)) = 1;
    
        ErrorU = ErrorU*(2*MaximumErrorU*rand- MaximumErrorU);
        ErrorV = ErrorV*(2*MaximumErrorV*rand- MaximumErrorV);
    
        U_Errored = U_Errored.*(not(ErrorU)) + ErrorU;
        V_Errored = V_Errored.*(not(ErrorV)) + ErrorV;
        
        i=i+1;
    end
end    

