
function [U, V,X,Y] = IncompressibleVelocityField(GridSize, PARAMETERS)

% Author - Atul S Vivek 
% Date   - jun 16 2015
% Function to Calculate Velocity field (u,v) = (C*x^2,-2C*x*y) 

% U - Velocity component along X direction
% V - Velocity component along Y direction
% X - Grid containing x-position of each vector
% Y - Grid containing y-position of each vector
% GridSize - Number fo Vectors in each direction
% PARAMETERS - contains the Parameters required 
% For more details see A-M Shinneeb et al. 2004

%----------------------------- Example ------------------------------------

%           To Run the Program
% GridSize = 128
% PARAMETERS.Lx = 500;
% PARAMETERS.Ly = 500;
% PARAMETERS.C = 10
% [U,V,X,Y] = IncompressibleVelocityField(GridSize,PARAMETERS)

%           To Display vectors
% quiver(X,Y,U,V)

%--------------------------------------------------------------------------



% Creates a Grid of the given size
[x, y] = meshgrid(1:GridSize, 1:GridSize);

% Extract values from the PARAMETERS STRUCTURE
Lx = PARAMETERS.Lx; % Length of the Field in X direction 
Ly = PARAMETERS.Ly; % Length of the Field in Y direction
C = PARAMETERS.C; % Defines the 'C' value that governs the field

% Rescaling the Grid based on the actual length of the field
x = x/GridSize*Lx;
y = y/GridSize*Ly;

% Velocity Calculation for each points
U = C*x.*x;
V = C*x.*y;
% Variable to be returned
X=x;
Y=y;

%--------------------------------------------------------------------------
% Creates a .mat File with the velocity field and other parameters  

CurrentFolder = pwd; % Current directory 
FileName = '\ICVelocityField'; % Name of the File
Path = strcat(CurrentFolder,FileName); % File address

matobj = matfile(Path,'Writable',true);% File variable   
% Writing the variables
matobj.U= U;
matobj.V= V;
matobj.X= X;
matobj.Y= Y;
matobj.PARAMETERS = PARAMETERS; 
matobj.GridSize= GridSize;
%--------------------------------------------------------------------------