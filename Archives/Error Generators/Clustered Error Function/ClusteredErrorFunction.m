function [U_Errored, V_Errored, ErrorLocation] = ClusteredErrorFunction(MatFileAddress,PercentageError,MaximumError,MinimumError,ClusterSize)

% Author - Atul S Vivek 
% Date   - jun 16 2015
% Function to Impose Clustered  Type 2 outliers in a 
% velocity field.For more details refer A M Shineeb et al. 2004

% U_Errored - Contains the contaminated X velocity field  
% V_Errored - Contains the contaminated Y velocity field  
% ErrorLocation - Contains the Locations of the Erroneous vectors in the
%                  Field
% MatFileAddress  - Address of the .mat file containing the velocity data
% PercentageError - The percantage of vectors that are to be contaminated
% MaximumError - Maximum allowed Error value, Given as a fraction of the 
%                Local velocity in the field.Computed seperately for each 
%                direction 
% MinimumError - Minimum allowed Error value, Given as a fraction of the 
%                Local velocity in the field.Computed seperately for each 
%                direction
% ClusterSize -  Number of elements in each cluster
%                

%----------------------- Format of the .mat file---------------------------
% Should contain a Two square matrices U and V of the size 'GridSize' which
% also should be included in the file with the same name.For more details 
% regarding format refer the files - CellularVorticalFlowVelocityField.m or
% IncompressibleVelocityField.m 
%--------------------------------------------------------------------------

%---------------------------- Example -------------------------------------
% MatFileAddress  = 'F:\Books , References & studies\Projects\Purdue\Codes
%                   \Analytical Fields\Cellular Vortical Flow
%                   \CVFVelocityField.mat';
% PercentageError = 20;
% MaximumError    = 0.5;
% MinimumError    = 0.25
% ClusterSize     = 7;
%[U_Errored, V_Errored, ErrorLocation] = ClusteredErrorFunction(MatFileAddress
%                   ,PercentageError,MaximumError,MinimumError,ClusterSize)
%--------------------------------------------------------------------------

% To open the mat file
if ~exist(MatFileAddress, 'file') % File not Found condition
  message = sprintf('%s does not exist', MatFileAddress); 
  uiwait(warndlg(message));
else
 matobj =  load(MatFileAddress);
end

% Extract Parameters From the matfile  
GridSize = matobj.GridSize;
U = matobj.U;
V = matobj.V;


% Creates a Guide to limit the number of erroneous clusters to a number
% calculated on the basis of PercentageError.
ErrorNumber=round((PercentageError/100)*GridSize*GridSize/ClusterSize);
ErrorNumberFilter = zeros(GridSize);
ErrorNumberFilter(randperm(numel(ErrorNumberFilter), ErrorNumber)) = 1;


% A low pass filter that generates a field of error around the designated
% locations obtained from ErrorNumberFilter

ConvolutionFilterSize = ceil(sqrt(ClusterSize));
% Filter with randomly genrated values ,around 1 within limits specified by
% MaximumError and MinimumError
FilterU = 2*( MinimumError +  (MaximumError-MinimumError)*rand(ConvolutionFilterSize));
FilterV = 2*( MinimumError +  (MaximumError-MinimumError)*rand(ConvolutionFilterSize));

FilterCommon = ones(ConvolutionFilterSize);
FilterCommon(randperm(numel(FilterCommon),ConvolutionFilterSize*ConvolutionFilterSize- ClusterSize)) = 0;

FilterU = FilterU.*FilterCommon;
FilterV = FilterV.*FilterCommon;

% Generates a random field with values around 1 or -1 within limits specified by
% MaximumError and MinimumError
ErrorU = 2*(randi(2,GridSize) * 2 - 3).*(MinimumError +  (MaximumError-MinimumError)*rand(GridSize)).*ErrorNumberFilter;
ErrorV = 2*(randi(2,GridSize) * 2 - 3).*(MinimumError +  (MaximumError-MinimumError)*rand(GridSize)).*ErrorNumberFilter;


% Convolution of the filter with the Guide to devolop each cluster 
RandomErrorU =U.*conv2(ErrorU,FilterU,'same');
RandomErrorV =V.*conv2(ErrorV,FilterV,'same');

% Erroneous Vectors
U_Errored = U + RandomErrorU;
V_Errored = V + RandomErrorV;

% Gives the location of the errors
ErrorLocation = spones(conv2(ErrorU,FilterCommon,'same'));