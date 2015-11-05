function [GradientUODMetric]=GradientUOD_sub(Block,Ipos,Jpos)

% Author - Atul S Vivek 
% Date   - jun 19 2015
% Function To find 2D gradient based UOD score for a given velocity
% component in a block of neighboring values.To be used in conjugation with
% GradientUOD.m 

% Block - Block of neighboring values of the component to be evaluvated
%         including itself
% Ipos  - Row number of the component to be evaluvated, in the matrix
%         'Block'
% Jpos  - Coloumn number of the component to be evaluvated, in the matrix
%         'Block'
% GradientUODMetric - The Score of the component under scrutiny.This gives
%                    a measure of the components validity. 


BlockSize = size(Block);
%------------------------ X directional Differences -----------------------

% Row wise differences - gives variation in X direction
XDifferences = diff(Block,1,2);
XDifferenceSize =size(XDifferences);

% Find the position of differences involving the component under scrutiny 
JposMin = max(1,(Jpos-1));
JposMax = min(XDifferenceSize(2),Jpos);

% Finding the differences involving the component under scrutiny to be 
% used for validation  
CurrenElementRow = Block(Ipos,:);
CurrenElementRowIndex = 1:BlockSize(2);
CurrentElementDifferences_X = (CurrenElementRow - CurrenElementRow(Jpos))./(CurrenElementRowIndex-Jpos) ;

% The differnces involvin the component under scrutiny should not be used
% for its own validation hence these are given nan values.
XDifferences(Ipos,JposMin:JposMax) = nan;

% Median value of the X directional differences in the neighborhood.
MedianDifference_X = nanmedian(XDifferences(:));

% The variation of the X directional differences from the median, in the 
% neighborhood  
VariationFromMedianDifference_X = XDifferences - MedianDifference_X;

% The variation of the X directional differences involving the element under
% Scrutiny, from the median.
CurrentElementVFMD_X =  CurrentElementDifferences_X - MedianDifference_X;

% The gradientUODMetric_X is the ratio of the " minimum of the absoltue 
%  Variation in X directional differences involving the element under 
% Scrutiny, from the median" to the " absolute value of the median of the of 
% Variation in X directional differences from the median ,in the neighborhood 
% of the element under Scrutiny." 
GradientUODMetric_X =((min(abs(CurrentElementVFMD_X)))/(nanmedian(abs(VariationFromMedianDifference_X(:)))+ 0.1));


%-------------------------------------------------------------------------- 


%------------------------ Y directional Differences -----------------------

% Coloum wise differences - gives variation in Y direction
YDifferences = diff(Block,1,1);
YDifferenceSize =size(YDifferences);

% Find the position of differences involving the component under scrutiny 
IposMin = max(1,(Ipos-1));
IposMax = min(XDifferenceSize(1),Ipos);

% Finding the differences involving the component under scrutiny to be 
% used for validation  
CurrenElementColoumn = Block(:,Jpos);
CurrenElementColoumnIndex = 1:BlockSize(1);
CurrentElementDifferences_Y = (CurrenElementColoumn - CurrenElementColoumn(Ipos))./(CurrenElementColoumnIndex(:)-Ipos) ;

% The differnces involving the component under scrutiny should not be used
% for its own validation hence these are given nan values.
YDifferences(Ipos,JposMin:JposMax) = nan;

% Median value of the Y directional differences in the neighborhood.
MedianDifference_Y = nanmedian(YDifferences(:));

% The variation of the Y directional differences involving the element under
% Scrutiny, from the median.
VariationFromMedianDifference_Y = YDifferences - MedianDifference_Y;

% The variation of the Y directional differences involving the element under
% Scrutiny, from the median.
CurrentElementVFMD_Y =  CurrentElementDifferences_Y - MedianDifference_Y;

% The gradientUODMetric_Y is the ratio of the " minimum of the absoltue 
%  Variation in Y directional differences involving the element under 
% Scrutiny, from the median" to the " absolute value of the median of the of 
% Variation in Y directional differences from the median ,in the neighborhood 
% of the element under Scrutiny." 
 GradientUODMetric_Y =((min(abs(CurrentElementVFMD_Y)))/(0.1+nanmedian(abs(VariationFromMedianDifference_Y(:)))));

% The to metrics are combined to a single one which indicates the validity
% of the component under scrutiny
GradientUODMetric = GradientUODMetric_Y + GradientUODMetric_X ;
