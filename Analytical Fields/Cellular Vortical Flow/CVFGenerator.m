function CVFGenerator(BaseFileName)

% Date - June 22 2015 
% Function to generate multiple velocity field using the function 
% CellularVorticalFlowVelocityField()

% BaseFileName - The Base of the file name for all the mat files generated
% the files will be named CVF_1 ,CVF_2 etc. if the BaseFileName is IVF.

%---------------------------- Example -------------------------------------
% 
% IVFGenerator('CVF');
%
%--------------------------------------------------------------------------

% Parameters required - Refer CellularVorticalFlowVelocityField() for details
% ------------------------------------------------------------------------- 

VortexNumberX = [1;2;4] ;
VortexNumberY = [1;2;4] ;
NumberOfFields = size(VortexNumberX);
GridSize =32;
PARAMETERS.Lx = 500;
PARAMETERS.Ly = 500;
PARAMETERS.Vmax = 10;

%--------------------------------------------------------------------------

BaseFileName = 'CVF';
BaseFileName = strcat('/',strcat(BaseFileName,'_'));



for i=1:NumberOfFields
    
    PARAMETERS.Ny = VortexNumberY(i);
    PARAMETERS.Nx = VortexNumberX(i);
    IterationNumber = num2str(i);
    PARAMETERS.Filename = strcat(BaseFileName,IterationNumber);
    CellularVorticalFlowVelocityField(GridSize,PARAMETERS);

end

    