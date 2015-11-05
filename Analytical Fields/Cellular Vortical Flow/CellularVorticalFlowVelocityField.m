 
function [U,V,X,Y] = CellularVorticalFlowVelocityField(GridSize, PARAMETERS)

% Author - Atul S Vivek 
% Date   - jun 16 2015
% Function to Calculate Velocity field For an cellular vortical flow

% U - Velocity component along X direction
% V - Velocity component along Y direction
% X - Grid containing x-position of each vector
% Y - Grid containing y-position of each vector
% GridSize - Number fo Vectors in each direction
% PARAMETERS - contains the Parameters required 
% to defne the vortex see A-M Shinneeb et al. 2004

%----------------------------- Example ------------------------------------

%           To Run the Program
% GridSize = 128
% PARAMETERS.Lx = 500;
% PARAMETERS.Ly = 500;
% PARAMETERS.Ny = 8;
% PARAMETERS.Nx = 8;
% PARAMETERS.Vmax = 10;
% PARAMETERS.Filename = 'CVF_1'
% [U,V,X,Y] = CellularVorticalFlowVelocityField(GridSize,PARAMETERS)

%           To Display vectors
% quiver(X,Y,U,V)

%--------------------------------------------------------------------------



% Creates a Grid of the given size
[x, y] = meshgrid(1:GridSize, 1:GridSize);

% Extract values from the PARAMETERS STRUCTURE
Lx = PARAMETERS.Lx; % Length of the Field in X direction 
Ly = PARAMETERS.Ly; % Length of the Field in Y direction
Vmax = PARAMETERS.Vmax; % Maximum velocity in the field
Nx = PARAMETERS.Nx; % Number of Vortex cells in x direction
Ny = PARAMETERS.Ny; % Number of Vortex cells in x direction

% Rescaling the Grid based on the actual length of the field
x = x/GridSize*Lx;
y = y/GridSize*Ly;

% Velocity Calculation for each points
U = Vmax*cos(x*Nx*pi/Lx + pi/2).*cos(y*Ny*pi/Ly);
V = Vmax*sin(x*Nx*pi/Lx + pi/2).*sin(y*Ny*pi/Ly);
% Variable to be returned
X=x;
Y=y;

%--------------------------------------------------------------------------
% Creates a .mat File with the velocity field and other parameters  

CurrentFolder = pwd; % Current directory 
FileName = PARAMETERS.Filename; % Name of the File
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