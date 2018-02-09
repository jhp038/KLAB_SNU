%% Miniscope MED analysis main function XLSX data
clear all; close all
msObj = msObjMake;

%% preprocessing
%made exception for excel data.
msObj = msTrimmingData(msObj);

%now, calculate array for four cases: 
%active, inactive, reward, and port entry 
msObj = msFR1_preprocessing(msObj,[-2 2],5);


%% plotting
plotmsFR1(msObj,'y');
