
function [U_Errored, V_Errored, ErrorLocations,X,Y] = RandomErrorGenerator(MatFileAddress,PercentageError,NoisePercentage)

% Author - Atul S Vivek 
% Function to Impose Random outliers in a velocity field.
% The error is limited to the largest vector in the field 
% Refer Wang et al. 2014



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
%[U_Errored, V_Errored, ErrorLocations,X,Y] = RandomErrorGenerator(....
%               ....MatFileAddress,PercentageError,NoisePercentage)
%--------------------------------------------------------------------------

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
MaximumErrorU = max(max(abs(U(:))),max(abs(V(:))));
MaximumErrorV = max(max(abs(U(:))),max(abs(V(:))));

U_Errored = U;
V_Errored = V;

V_Noise = NoisePercentage/100*MaximumErrorV*randn(GridSize);
U_Noise = NoisePercentage/100*MaximumErrorU*randn(GridSize);
U_Errored = U_Errored+U_Noise;
V_Errored = V_Errored+V_Noise;



% Random Error generator. Generates random values for each location within
% the range [-Umax,Umax]
RandomErrorU =(2*MaximumErrorU*rand(GridSize)- MaximumErrorU);
RandomErrorV =(2*MaximumErrorV*rand(GridSize)- MaximumErrorV);

% Creates a Mask to limit the number of erroneous vectors to a number
% calculated on the basis of PercentageError.
ErrorNumber=round(PercentageError*GridSize(1)*GridSize(2)/100);
ErrorNumberFilter = zeros(GridSize);
ErrorNumberFilter(randperm(numel(ErrorNumberFilter), ErrorNumber)) = 1;

% Filters the unwanted errors
RandomErrorU =RandomErrorU.*ErrorNumberFilter;
RandomErrorV =RandomErrorV.*ErrorNumberFilter;

% Erroneous Vectors
U_Errored = U_Errored.*(not(ErrorNumberFilter)) + RandomErrorU;
V_Errored = V_Errored.*(not(ErrorNumberFilter)) + RandomErrorV;

% Gives the location of the errors
ErrorLocations = ErrorNumberFilter;



