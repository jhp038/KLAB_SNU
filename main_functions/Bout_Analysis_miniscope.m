%% Miniscope MED analysis main function
clear all; close all


%% load data
msObj = msObjMake;

%% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObj = msTrimmingData(msObj);


%now, calculate bout
boutWindow = 10;
numWindow = 10;
msObj = msCalculateBout(msObj);

%% plotting
%visualizing each neuron
plotmsBout(msObj,'n');
