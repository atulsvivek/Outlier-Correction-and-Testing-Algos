
function [U_Errored, V_Errored, ErrorLocation] = RandomErrorFunction(MatFileAddress,PercentageError,MaximumError)

% Author - Atul S Vivek 
% Date   - jun 16 2015
% Function to Impose Randomly distributed Type 1 outliers in a 
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

%----------------------- Format of the .mat file---------------------------
% Should contain a Two square matrices U and V of the size 'GridSize' which
% also should be included in the file with the same name.For more details 
% regarding format refer the files - CellularVorticalFlowVelocityField.m or
% IncompressibleVelocityField.m 
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


% Random Error generator. Geneartes random values for each location within
% the range [-MaximumError*Umax,+MaximumError*Umax]
RandomErrorU =U.*MaximumError*(2*rand(GridSize)- 1);
RandomErrorV =V.*MaximumError*(2*rand(GridSize)- 1);

% Creates a Mask to limit the number of erroneous vectors to a number
% calculated on the basis of PercentageError.
ErrorNumber=round(PercentageError*GridSize*GridSize/100);
ErrorNumberFilter = zeros(GridSize);
ErrorNumberFilter(randperm(numel(ErrorNumberFilter), ErrorNumber)) = 1;

% Filters the unwanted errors
RandomErrorU =RandomErrorU.*ErrorNumberFilter;
RandomErrorV =RandomErrorV.*ErrorNumberFilter;

% Erroneous Vectors
U_Errored = U + RandomErrorU;
V_Errored = V + RandomErrorV;

% Gives the location of the errors
ErrorLocation = ErrorNumberFilter;



