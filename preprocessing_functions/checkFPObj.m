function varargout = checkFPObj
%% varargout =checkFPobj
%02/27/2018
%Written by Jong Hwi Park
%This code checks if files written in metadata are loaded and ask user
% if he/she wants to re-preprocess. 

file = uipickfiles('FilterSpec','*.xlsx'); %this has to search for .xlsx files
metaDir_WO_ext = fileparts(file{1,1});
cd(metaDir_WO_ext);

processed_list = dir('*processed*');
if size(processed_list,1)>0 
    numPrevSession = size(processed_list,1);
    fprintf(['##### There are ' num2str(numPrevSession) ' previous sessions ... #####\n'])
    for i = 1:numPrevSession
        fprintf(['\t' num2str(i) ' : ' processed_list(i).name '\n'])
    end
    choice = input(['Please type in session number to resume or type ' num2str(size(processed_list,1)+1) ' to create new session: ']);
    % if user selected existing one...
    if choice <= numPrevSession
        %find path and load data
        chosen_dir= processed_list(choice).name;
        cd(chosen_dir)
        mat_list = dir('*.mat*');
        fpObj.loaded = 1;   %save loaded status for later usage
        varargout{:} = load(mat_list.name);
        fprintf(['##### Following data is successfully loaded : ' mat_list.name ' #####\n'])
        cd ..
    else
        fpObj = createFPObj(file);
        tic;
        fpObj = loadFPData(fpObj);
        disp(['Finished loading data']);
        toc;
        fpObj.loaded = 0;
        varargout{:} = fpObj;
    end
else
    fprintf(['##### There are no previous sessions ... #####\nloading data ... \n'])
    fpObj = createFPObj(file);
    tic;
    fpObj = loadFPData(fpObj);
    disp(['Finished loading data']);
    toc;
    fpObj.loaded = 0;
    varargout{:} = fpObj;
end
end

