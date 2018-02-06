%% Text2Array_miniscope
% Revised by Jong Hwi Park
% 12/20/2016
% This script function will find txt data files in curret working directory
% and convert into a nx4 array such that it can be prepared for plotting
% via using Revised_Fiber_Photometry_Plot
%
% revised by SYK, 1/9/2017
% folerName as an input: this folder must contain "only" the following four
% text files that are space-separated when exported from TDT OpenExplorer.
% Div1A.txt = 473 nm signal
% Div2A.txt = 405 nm signal
% Wav1.txt = IR pulse
% Wav2.txt = LED pulse


function [RawData samplingRate] = Text2Array_miniscope(folderName)
%% find current working directory and check if there is any txt files.
% disp('Please select a directory that contains txt files...');
% currentDirectory = uigetdir;

dirInfo = dir(folderName);
%cd(dirInfo);
RawData =[];
%if there is no any txt files, print 'No txt file exists and ask to change
%dir
exist_txt = zeros(size(dirInfo));
%%
for i = 1:size(dirInfo)
    filename = dirInfo(i).name;
   if isempty(strfind(filename, 'txt')) == 1
       exist_txt(i,1) = 0;
   else
       exist_txt(i,1) = 1;
   end
end
%%
if sum(exist_txt) == 0
    disp('No txt file exists. Please check your current working directory.');
    return;
else
    disp(['Found *.txt files from: ' folderName]);
end   

%%
for i=1:size(dirInfo)
    filename = dirInfo(i).name;
    if isempty(strfind(filename, 'wmv')) == 0 || isempty(strfind(filename, 'avi')) == 0 || isempty(strfind(filename,'mpg')) == 0
        output = filename;
    end
    if strfind(filename, 'txt')
        fprintf(['Processing ' filename ' ...\n']);
        fidr = fopen([folderName filesep filename]);
        
        %6 is Row offset, and 0 is column offset
        Data = dlmread([folderName filesep filename], '\t',6,0); 
        % preset option of the program
        %col 3 time point
        %col 4 sampling rate 
        % col 5 data starts
        OrgData = zeros(size(Data,1)*128, 2, 'double');
        
        for k=1:size(Data,1)
            for l=1:128
                OrgData((k-1)*128+l,1) = Data(k,3)+1/Data(k,4)*l;
                OrgData((k-1)*128+l,2) = Data(k,l+4);
            end
        end
        
        RawData(:,1) = OrgData(:,1);
        length = size(RawData,2);
        RawData(:,length+1) = OrgData(:,2) ;
        samplingRate = Data(1,4);
        fclose(fidr);
    end
   
end

fprintf('Done!\n');