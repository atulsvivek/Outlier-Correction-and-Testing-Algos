function MonteCarloErrorGenerator(FieldType,Number)

% Author - Atul S Vivek 
% Function to Generate multiple erroreous field simultaneously that can be
% used to perform montecarlo analysis of outlier correction algorithms 

% FieldType - The Tye of Field to be used  
% --------------- Options --------------- 
% 1 - Cellular Vortical field
% 0 - Quadratically variying field
% 2005 -  PIV challenge 2005 case B
% 2001 -  PIV challenge 2001 case E
% The mat file containing the data of these field must be resent in the 
% folder 'Fields' in the current directory.New options can be added by 
% adding new mat files, and by changing the funtion accordingly

%------------------------- Error Settings ---------------------------------

% The parameters to be used by the error generator functions
% ClusteredErrorGenerator.mat and RandomErrorGenerator.Mat are specified here
% Refer these functions for more details

Random_Q = [5;10;15;20]; % Error percentages to be used in fields 
                         % with random error 
RandomErrorTypeNumber = length(Random_Q);

Clustered_Q = [5;10;15;20]; % Error percentages to be used in fields 
                            % with Clustered error
ClusteredErrorTypeNumber = length(Clustered_Q);

NoisePercentage = 0; % percentage noise 
%--------------------------------------------------------------------------

warning('off','all')

% To create Folder to Store Results and field.
ParentFolder = pwd;

if(FieldType==1)    
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\CVF_Noise_'),num2str(NoisePercentage));
    MatFileAddress = strcat(ParentFolder,strcat('\Fields\CVF.mat'));    
elseif (FieldType ==0) 
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\IVF_Noise_'),num2str(NoisePercentage));
    MatFileAddress = strcat(ParentFolder,strcat('\Fields\IVF.mat'));   
elseif (FieldType ==2005)
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\PIV2005B_Noise_'),num2str(NoisePercentage));
    MatFileAddress = strcat(ParentFolder,strcat('\Fields\PIV2005B.mat'));   
elseif (FieldType ==2001)
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\PIV2001E_Noise'),num2str(NoisePercentage));
    MatFileAddress = strcat(ParentFolder,strcat('\Fields\PIV2001E.mat'));
   
end
mkdir(ErroredFolder);

for FieldNumber = 1:Number
    
    % To test the performance under the presence fo randomly distibuted
    % errors
    parfor i= 1:RandomErrorTypeNumber
        
                  
         % Generating Random Errors in the field
         [U_Errored, V_Errored, ErrorLocations,X,Y] = RandomErrorGenerator(MatFileAddress,Random_Q(i),NoisePercentage);
         
         FileName = strcat('\FieldNumber',num2str(FieldNumber));
         Path = strcat(strcat(ErroredFolder,'\RandomError_'),num2str(Random_Q(i))); % File address
         mkdir(Path);
         Path = strcat(Path,FileName);
         
         matobj = matfile(Path,'Writable',true);% File variable  

         % Writing the variables
         matobj.U_Errored = U_Errored;
         matobj.V_Errored = V_Errored;
         matobj.ErrorLocations= ErrorLocations;
         matobj.Q= Random_Q(i);
         matobj.X= X;
         matobj.Y= Y;
          
    end
    
    parfor i= 1:ClusteredErrorTypeNumber
        
                  
         % Generating Random Errors in the field
         [U_Errored, V_Errored, ErrorLocations,X,Y] = ClusteredErrorGenerator(MatFileAddress,Clustered_Q(i),NoisePercentage);
         
         FileName = strcat('\FieldNumber',num2str(FieldNumber));
         Path = strcat(strcat(ErroredFolder,'\ClusteredError_'),num2str(Clustered_Q(i))); % File address
         mkdir(Path);
         Path = strcat(Path,FileName);
         
         matobj = matfile(Path,'Writable',true);% File variable  

         % Writing the variables
         matobj.U_Errored = U_Errored;
         matobj.V_Errored = V_Errored;
         matobj.ErrorLocations= ErrorLocations;
         matobj.Q= Clustered_Q(i);
         matobj.X= X;
         matobj.Y= Y;
        
                
    end
     disp(strcat(strcat('Field Number - ',num2str(FieldNumber)),' is done !'));
end

% To generate a file containing the parameter data
Matobj =  load(MatFileAddress);
Dataobj = matfile(strcat(ErroredFolder,'\DataFile'),'Writable',true);% File variable  
Dataobj.U = Matobj.U;
Dataobj.V = Matobj.V;
Dataobj.X = Matobj.X;
Dataobj.Y = Matobj.Y;
Dataobj.Random_Q = Random_Q;
Dataobj.Clustered_Q = Clustered_Q;                
Dataobj.DateTime = datestr(now,'mmm_dd_yyyy_HH_MM_SS');
Dataobj.NumberOfFields = Number;
Dataobj.NoisePercentage = NoisePercentage;
