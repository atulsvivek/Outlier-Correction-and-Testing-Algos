function MonteCarloWQFOC_PTV(FieldType)

% Date - September 23 2015
% Function to perform Monte Carlo Simulation of WQOFC Method.It can
% be easily modified to test other outlier detection methods as well.

% FieldType - The Type of the Field Used 
%             Type 1 - Cellular Vortical field refer CVFGenerator.m for
%             more details and settings such as the number of vortices.
%             Type 0 - Refer IVFGenerator.m for details and settings.
%             Type 2005 - PIV challenge 2005 case B images 1 and 2
%             Type 2001 - PIV challenge 2001 case E images 1 and 2     
% 
% The Result will be stored in a matfile created within a folder with the
% current date and time

%-------------------------- Example ---------------------------------------
%
% MonteCarloWQFOC_PTV (1)
%
%--------------------------------------------------------------------------

NoisePercentage = 0;


% To create Folder to Store Results and field.
ParentFolder = pwd;
DateTime = datestr(now,'mmm_dd_yyyy_HH_MM_SS');

if(FieldType==1)        
    ResultFolder = strcat(strcat(ParentFolder,'\Simulation Results\CVF_'),DateTime);
   ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\CVF_Noise_'),num2str(NoisePercentage));
elseif (FieldType ==0) 
    ResultFolder = strcat(strcat(ParentFolder,'\Simulation Results\IVF_'),DateTime);
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\IVF_Noise_'),num2str(NoisePercentage));
elseif (FieldType ==2005)
    ResultFolder = strcat(strcat(ParentFolder,'\Simulation Results\PIV2005B_'),DateTime);
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\PIV2005B_Noise_'),num2str(NoisePercentage)); 
elseif (FieldType ==2001)
    ResultFolder = strcat(strcat(ParentFolder,'\Simulation Results\PIV2001E_'),DateTime);
    ErroredFolder = strcat(strcat(ParentFolder,'\ErroredFields\PIV2001E_Noise'),num2str(NoisePercentage));
end

mkdir(ResultFolder);
Dataobj = load(strcat(ErroredFolder,'\DataFile'));
GridSize = size(Dataobj.U);
U = Dataobj.U;
V = Dataobj.V;
Random_Q = Dataobj.Random_Q;
Clustered_Q=Dataobj.Clustered_Q;
RandomErrorTypeNumber = length(Dataobj.Random_Q );
ClusteredErrorTypeNumber = length(Dataobj.Clustered_Q);
MaxTrials = Dataobj.NumberOfFields ;
  
for FieldNumber = 1:MaxTrials
    
    % To test the performance under the presence fo randomly distibuted
    % errors
    parfor i= 1:RandomErrorTypeNumber
        
                  
         % Generating Random Errors in the field
         FileName = strcat('\FieldNumber',num2str(FieldNumber));
         Path = strcat(strcat(ErroredFolder,'\RandomError_'),num2str(Random_Q(i))); % File address
         Path = strcat(Path,FileName);
         Matobj =  load(Path,'U_Errored','V_Errored','X','Y');
         % Gradient UOD function call
         [U_Corrected,V_Corrected] = WQFOC_PTV(Matobj.U_Errored,Matobj.V_Errored,Matobj.X,Matobj.Y,1);
         
         % Statistics of error detected. 
          Deviations =(((U_Corrected - U).^2 +(V_Corrected - V).^2).^0.5)./(((U).^2 +(V).^2).^0.5 + 0.1);
          ErrorRandom(FieldNumber,i) = sum(Deviations(:));
          Deviations = sort(Deviations(:));
          Size = size(Deviations(:)); 
          RandomUQDeviation(FieldNumber,i) = median(Deviations(ceil(Size/2):Size));
          RandomMedianDeviation(FieldNumber,i) = median(Deviations(:));
          RandomLQDeviation(FieldNumber,i) = median(Deviations(1:ceil(Size/2)));
                
    end
    
    % To test the performance under the presence of clusterederrors    
    parfor i= 1:ClusteredErrorTypeNumber
        
                            
          % Generating Random Errors in the field
         FileName = strcat('\FieldNumber',num2str(FieldNumber));
         Path = strcat(strcat(ErroredFolder,'\ClusteredError_'),num2str(Clustered_Q(i))); % File address
         Path = strcat(Path,FileName);
         Matobj =  load(Path,'U_Errored','V_Errored','X','Y');
       
         % Gradient UOD function call
          [U_Corrected,V_Corrected] = WQFOC_PTV(Matobj.U_Errored,Matobj.V_Errored,Matobj.X,Matobj.Y,1);
         
         
         % Statistics of error detected. 
          Deviations =(((U_Corrected - U).^2 +(V_Corrected - V).^2).^0.5)./(((U).^2 +(V).^2).^0.5 + 0.1);
          ErrorClustered(FieldNumber,i) = sum(Deviations(:));
          Deviations = sort(Deviations(:));
          Size = size(Deviations(:)); 
          ClusteredUQDeviation(FieldNumber,i) = median(Deviations(ceil(Size/2):Size));
          ClusteredMedianDeviation(FieldNumber,i) = median(Deviations(:));
          ClusteredLQDeviation(FieldNumber,i) = median(Deviations(1:ceil(Size/2)));
    end
    
    disp(strcat(strcat('Trial Number - ' , num2str(FieldNumber)),' is done !'));
end


%-------------------- Statistics of Errors --------------------------------
%
% These definitions are common for both random errors and Clustered errors
%
% 
% Percentage Error - The percentage deviation of the processed field with the 
%                   uncontaminated field    
% 
% Percentage UQ Deviation - Upper Quartile deviation
%
% Percentage LQ Deviation - Lower Quartile deviation
%
% Percentage Median Deviation - Median deviation  


% Statistics for Random error correction - Total Errors and Percentages.

TotalErrorRandom = sum(ErrorRandom,1);
PercentageErrorRandom = TotalErrorRandom/(GridSize(1)*GridSize(2)*MaxTrials)*100;
PercentageRandomUQDeviation = sum(RandomUQDeviation,1)/(MaxTrials)*100;
PercentageRandomMedianDeviation = sum(RandomMedianDeviation,1)/(MaxTrials)*100;
PercentageRandomLQDeviation = sum(RandomLQDeviation,1)/(MaxTrials)*100;

% Statistics for clustered error correction - Total Errors and Percentages.

TotalErrorClustered = sum(ErrorClustered,1);
PercentageErrorClustered = TotalErrorClustered/(GridSize(1)*GridSize(2)*MaxTrials)*100;
PercentageClusteredUQDeviation = sum(ClusteredUQDeviation,1)/(MaxTrials)*100;
PercentageClusteredMedianDeviation = sum(ClusteredMedianDeviation,1)/(MaxTrials)*100;
PercentageClusteredLQDeviation = sum(ClusteredLQDeviation,1)/(MaxTrials)*100;



%----------- Creates a .mat File with Statistics of Random Errors ---------

FileName = '\RandomError'; % Name of the File
Path = strcat(ResultFolder,FileName); % File address

matobj = matfile(Path,'Writable',true);% File variable  

% Writing the variables
matobj.FieldType = FieldType;
matobj.PercentageError= PercentageErrorRandom;
matobj.Q= Random_Q;
matobj.MaxTrials = MaxTrials ;
matobj.PercentageUQDeviation = PercentageRandomUQDeviation;
matobj.PercentageMedianDeviation = PercentageRandomMedianDeviation;
matobj.PercentageLQDeviation = PercentageRandomLQDeviation;


%--------------------------------------------------------------------------

%-------- Creates a .mat File with Statistics of Clustered Errors ---------
 
FileName = '\ClusteredError'; % Name of the File
Path = strcat(ResultFolder,FileName); % File address

matobj = matfile(Path,'Writable',true);% File variable  

% Writing the variables
matobj.FieldType = FieldType;
matobj.PercentageError= PercentageErrorClustered;
matobj.Q= Clustered_Q;
matobj.MaxTrials = MaxTrials ;
matobj.PercentageUQDeviation = PercentageClusteredUQDeviation;
matobj.PercentageMedianDeviation = PercentageClusteredMedianDeviation;
matobj.PercentageLQDeviation = PercentageClusteredLQDeviation;


%--------------------------------------------------------------------------