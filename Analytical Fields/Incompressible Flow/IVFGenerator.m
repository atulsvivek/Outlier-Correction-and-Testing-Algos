function IVFGenerator(BaseFileName)

% Date - June 22 2015 
% Function to generate multiple velocity field using the function 
% IncompressibleVelocityField()

% BaseFileName - The Base of the file name for all the mat files generated
% the files will be named IVF_1 ,IVF_2 etc. if the BaseFileName is IVF.

%---------------------------- Example -------------------------------------
% 
% IVFGenerator('IVF');
%
%--------------------------------------------------------------------------

% Parameters required - Refer IncompressibleVelocityField() for details
% ------------------------------------------------------------------------- 

C = [1;2;4] ;
NumberOfFields = size(C);
GridSize =75;
PARAMETERS.Lx = 500;
PARAMETERS.Ly = 500;

%--------------------------------------------------------------------------

BaseFileName = strcat('/',strcat(BaseFileName,'_'));



for i=1:NumberOfFields
    
    PARAMETERS.C = C(i);
    IterationNumber = num2str(i);
    PARAMETERS.Filename = strcat(BaseFileName,IterationNumber);
    IncompressibleVelocityField(GridSize,PARAMETERS);

end

    