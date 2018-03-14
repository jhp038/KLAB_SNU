%% Miniscope Shock analysis main function
clear all; close all
%% This to do;
%check if there is a previous iteration.
% if there isnt, make one and save result in directory.


%% load data
msObj = msObjMake;

%% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObj = msTrimmingDataShock(msObj);
msObj = msCalculateParaEvent(msObj);
%% plotting function
plotmsShock(msObj,'y')
% plotKmeansClustering(msObj,[-5 5],5,100000);
