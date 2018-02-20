%% Miniscope Shock analysis main function
clear all; close all

%% load data
msObj = msObjMake;

%% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObj = msTrimmingDataShock(msObj);
msObj = msCalculateParaEvent(msObj);
%% plotting function
plotmsShock(msObj,'y')
plotKmeansClustering(msObj,[-5 5],5,100000);