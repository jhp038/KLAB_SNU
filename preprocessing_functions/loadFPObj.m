function fpObj = loadFPObj
file = uipickfiles('FilterSpec','*.mat','Prompt','Please select fpObj.mat files'); %this has to search for .mat files

if iscell(file) == 0
    errordlg('Please select .mat files')
    fpObj = [];
    return
end
fpObj = [];
for fileNum = 1:size(file,2)
    a = load(file{fileNum});
    fpObj = [fpObj a.tempfpObj(:)];
end
end