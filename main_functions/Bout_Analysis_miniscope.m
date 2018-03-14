%% Miniscope MED analysis main function
clear all; close all

%% load data
msObj = msObjMake;

%% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObj = msTrimmingData(msObj);


%now, calculate bout
boutWindow = 3;
numWindow = 3;
msObj = msCalculateBout(msObj);

%% plotting
%visualizing each neuron
plotmsBout(msObj,'y');
plotKmeansClustering_bout(msObj,[-15 15],7,1000000);