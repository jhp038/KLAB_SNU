%% Miniscope MED analysis main function
clear all; close all
path ='I:\Miniscope data\1_20_2018\714_feeding'
cd(path);

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
plotmsBout(msObj);
