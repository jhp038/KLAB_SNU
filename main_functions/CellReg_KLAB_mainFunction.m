%% Shock 1
clear all ; clc
msObjShock_1 = msObjMake;

% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObjShock_1 = msTrimmingDataShock(msObjShock_1);
msObjShock_1 = msCalculateParaEvent(msObjShock_1);

%% Shock 2
msObjShock_2 = msObjMake;

% data preprocessing
%trimming timestamp and wav data(first 50sec)
msObjShock_2 = msTrimmingDataShock(msObjShock_2);
msObjShock_2 = msCalculateParaEvent(msObjShock_2);


%% Bout


%% organizing data format to insert into CellReg
neurons = {msObjShock_1.msData.neuron; msObjShock_2.msData.neuron};
names = {msObjShock_1.msData.fileName; msObjShock_2.msData.fileName};




%% CellReg
cell_registered_struct=CellReg_KLAB(neurons); % this function is adapted from CellReg main function. tune parameters like microns_per_pixel and maximal_distance

indexMap = cell_registered_struct.cell_to_index_map;
for i = 1:size(indexMap,1)
    if indexMap(i,1) == 0 || indexMap(i,2) ==0
        indexMap(i,:) = 0;
    end
end

snipped_indexMap = snip(indexMap,'0');
numOverlappingCells = size(snipped_indexMap,1)
%% Shock_1

cellClassification_shock_1 = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum = 0;
samplingRate = 5;
examRange = [-2 2];
examRangeIdx = samplingRate *examRange;
numTotalShock = msObjShock_1.numTotalShock;
videoShockIdx = msObjShock_1.videoShockIdx;
firstShockRangeIdx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);
neuron = msObjShock_1.msData.neuron;
timeStamp = msObjShock_1.msData.timeStamp;
C_raw = neuron.C_raw;
numOfFrames = msObjShock_1.msData.numOfFrames;
timeIdx = msObjShock_1.timeIdx;
mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
normalized_C = (C_raw - mean_Array)./std_Array;

for z = 1: numOverlappingCells
    neuronNum = snipped_indexMap(z,1);
    
    %first neuron's data
    %     dFF = df_neuron;
    dFF = normalized_C(neuronNum,:);
    dff_Array = [];
    for shockNum = 1:numTotalShock
        if firstShockRangeIdx(shockNum,2) > numOfFrames || firstShockRangeIdx(shockNum,1) >numOfFrames
        else
            dff_Array(shockNum,:) = dFF(firstShockRangeIdx(shockNum,1):firstShockRangeIdx(shockNum,2));
        end
    end
    
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baseline = dff_Array(:,1:abs(examRangeIdx(1)));
    meanBaseline = mean(baseline,2);
    
    response =  dff_Array(:,size(baseline,2)+1:end);
    meanResponse = mean(response,2);
    
    diff_data = meanResponse-meanBaseline ;
    mu = mean(meanBaseline);
    %function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
    [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1([meanResponse meanBaseline] ,5000,1,0.05,mu,0);
    disp(pval)
    %     pval(neuronNum) = permtest(meanShock,meanBaseline,5000);
    pval = pval(1);
    if pval<= 0.05 %excited
        
        activatedCellNum = activatedCellNum + 1;
        cellClassification_shock_1(z,1) = 1;
        cellClassification_shock_1(z,2) = pval;
        cellClassification_shock_1(z,3) = mean(diff_data);
        
    elseif pval >= 0.95 %inhibited
        inhibitiedCellNum = inhibitiedCellNum +1;
        cellClassification_shock_1(z,1) = -1;
        cellClassification_shock_1(z,2) = pval;
        cellClassification_shock_1(z,3) = mean(diff_data);
        
    else
        nonResponsiveCellNum = nonResponsiveCellNum +1;
        cellClassification_shock_1(z,1) = 0;
        cellClassification_shock_1(z,2) = pval;
        cellClassification_shock_1(z,3) = mean(diff_data);
        
    end
    
end

%% Shock_2

cellClassification_shock_2 = [];
activatedCellNum = 0;
inhibitiedCellNum = 0;
nonResponsiveCellNum = 0;
samplingRate = 5;
examRange = [-2 2];
examRangeIdx = samplingRate *examRange;
numTotalShock = msObjShock_2.numTotalShock;
videoShockIdx = msObjShock_2.videoShockIdx;
firstShockRangeIdx = [videoShockIdx(:,1) videoShockIdx(:,1)] + repmat(examRangeIdx,[numTotalShock 1]);
neuron = msObjShock_2.msData.neuron;
timeStamp = msObjShock_2.msData.timeStamp;
C_raw = neuron.C_raw;
numOfFrames = msObjShock_2.msData.numOfFrames;
timeIdx = msObjShock_2.timeIdx;
mean_C_raw = mean(C_raw,2); mean_Array = repmat(mean_C_raw,[1,numOfFrames]);
std_C_raw = std(C_raw,0,2);std_Array =  repmat(std_C_raw,[1,numOfFrames]);
normalized_C = (C_raw - mean_Array)./std_Array;

for z = 1: numOverlappingCells
    neuronNum = snipped_indexMap(z,2);
    
    %first neuron's data
    %     dFF = df_neuron;
    dFF = normalized_C(neuronNum,:);
    dff_Array = [];
    for shockNum = 1:numTotalShock
        if firstShockRangeIdx(shockNum,2) > numOfFrames || firstShockRangeIdx(shockNum,1) >numOfFrames
        else
            dff_Array(shockNum,:) = dFF(firstShockRangeIdx(shockNum,1):firstShockRangeIdx(shockNum,2));
        end
    end
    
    
    %baseline = 1sec before onset to 0sec
    %examRange = up to 20 sec
    baseline = dff_Array(:,1:abs(examRangeIdx(1)));
    meanBaseline = mean(baseline,2);
    
    response =  dff_Array(:,size(baseline,2)+1:end);
    meanResponse = mean(response,2);
    
    diff_data = meanResponse-meanBaseline ;
    mu = mean(meanBaseline);
    %function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
    [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1([meanResponse meanBaseline] ,5000,1,0.05,mu,0);
    disp(pval)
    %     pval(neuronNum) = permtest(meanShock,meanBaseline,5000);
    pval = pval(1);
    if pval<= 0.05 %excited
        
        activatedCellNum = activatedCellNum + 1;
        cellClassification_shock_2(z,1) = 1;
        cellClassification_shock_2(z,2) = pval;
        cellClassification_shock_2(z,3) = mean(diff_data);
        
    elseif pval >= 0.95 %inhibited
        inhibitiedCellNum = inhibitiedCellNum +1;
        cellClassification_shock_2(z,1) = -1;
        cellClassification_shock_2(z,2) = pval;
        cellClassification_shock_2(z,3) = mean(diff_data);
        
    else
        nonResponsiveCellNum = nonResponsiveCellNum +1;
        cellClassification_shock_2(z,1) = 0;
        cellClassification_shock_2(z,2) = pval;
        cellClassification_shock_2(z,3) = mean(diff_data);
        
    end
    
end


%% adapted from CellReg
shock_responsive_1 = 0;
shock_nonResponsive_1 = 0;

shock_responsive_2 = 0;
shock_nonResponsive_2 = 0;

both_responsive = 0;
both_responsive_Idx=[];
shock_responsive_Idx_1 = [];
shock_responsive_Idx_2 = [];


for i = 1:numOverlappingCells
    %feeding
    if cellClassification_shock_2(i,1) ~=0
        shock_responsive_2 = shock_responsive_2 +1;
        shock_responsive_Idx_2(shock_responsive_2) = snipped_indexMap(i,2);
    else
        shock_nonResponsive_2 = shock_nonResponsive_2 +1;
        shock_nonResponsive_Idx_2(shock_nonResponsive_2) =  snipped_indexMap(i,2);
    end
    %shock
    if cellClassification_shock_1(i,1) ~= 0
        shock_responsive_1 = shock_responsive_1 +1;
        shock_responsive_Idx_1(shock_responsive_1) = snipped_indexMap(i,1);
    else
        shock_nonResponsive_1 = shock_nonResponsive_1 +1;
        shock_nonResponsive_Idx_1(shock_nonResponsive_1) =  snipped_indexMap(i,1);
    end
    %both
    if  cellClassification_shock_2(i,1) ~=0 && cellClassification_shock_1(i,1) ~=0
        both_responsive = both_responsive +1;
        both_responsive_Idx(both_responsive,:) =[snipped_indexMap(i,1) snipped_indexMap(i,2)];
    end
end




spatial_footprints = cell_registered_struct.spatial_footprints_corrected;
cell_to_index_map = cell_registered_struct.cell_to_index_map;
number_of_sessions=size(spatial_footprints,1);

pixel_weight_threshold=0.5; % for better visualization of cells
all_projections_partial=cell(1,number_of_sessions);
mutual_projections_partial=cell(1,number_of_sessions);
cells_in_all_days=find(sum(cell_to_index_map'>0)==number_of_sessions);
other_cells=cell(1,number_of_sessions);
for n=1:number_of_sessions
    logical_1=sum(cell_to_index_map'>0)<number_of_sessions;
    other_cells{n}=find(cell_to_index_map(:,n)'>0 & logical_1);
end
 
disp('Calculating spatial footprints projections:')
for n=1:2%:number_of_sessions
    display_progress_bar('Terminating previous progress bars',true)
    display_progress_bar(['Calculating projections for session #' num2str(n) ' - '],false)
    this_session_spatial_footprints=spatial_footprints{n};
    num_spatial_footprints=size(this_session_spatial_footprints,1);
    normalized_spatial_footprints=zeros(size(this_session_spatial_footprints));
    for k=1:num_spatial_footprints
        display_progress_bar(100*(k)/(num_spatial_footprints),false)
        this_spatial_footprint=this_session_spatial_footprints(k,:,:);
        this_spatial_footprint(this_spatial_footprint<pixel_weight_threshold*max(max(this_spatial_footprint)))=0;
        if max(max(this_spatial_footprint))>0
            normalized_spatial_footprints(k,:,:)=this_spatial_footprint/max(max(this_spatial_footprint));
        end
    end
    display_progress_bar(' done',false);
    
    %     all_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
    %     mutual_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
    %     all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(cells_in_all_days,n),:,:),1));
    %     all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1));
    %     all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1))+squeeze(sum(normalized_spatial_footprints(cell_to_index_map(cells_in_all_days,n),:,:),1));
    %     all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(other_cells{n},n),:,:),1));
    %     mutual_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(cell_to_index_map(cells_in_all_days,n),:,:),1));
    %     all_projections_partial{n}(all_projections_partial{n}>1)=1;
    
    %% I have to visualize excited/excited, inhibit/inhibit cells.
    if n == 1

        all_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3);
        all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(shock_responsive_Idx_1,:,:),1)); %shock
        all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(both_responsive_Idx(:,n),:,:),1)); %bothResponsive
        all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(shock_nonResponsive_Idx_1,:,:),1)); %nonResponsive
        all_projections_partial{n}(all_projections_partial{n}>1)=1;
    else
        all_projections_partial{n}=zeros(size(this_spatial_footprint,2),size(this_spatial_footprint,3),3); 
        all_projections_partial{n}(:,:,1)=squeeze(sum(normalized_spatial_footprints(shock_responsive_Idx_2,:,:),1)); %feeding
        all_projections_partial{n}(:,:,2)=squeeze(sum(normalized_spatial_footprints(both_responsive_Idx(:,n),:,:),1)); %both
        all_projections_partial{n}(:,:,3)=squeeze(sum(normalized_spatial_footprints(shock_nonResponsive_Idx_2,:,:),1)); %both
        all_projections_partial{n}(all_projections_partial{n}>1)=1;

    end
end
%%
%  edge(spatial_footprints_shock(:,:,z), 'canny');
%     hello=ones([162 169 3]);

figure('units','normalized','outerposition',[0.1 0.2 0.8 0.5],'Visible','on')
set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')')
for n=1:number_of_sessions
    subplot(1,number_of_sessions,n)
    imagesc(all_projections_partial{n})
%     hold on
%     imagesc(hello)
%     alphamask(all_projections_partial{n}(:,:,1),[1 0 0],1);%responsive
%     alphamask(edge(all_projections_partial{n}(:,:,2),'Roberts'), [.9 .9 .5], 1);%both
%     alphamask(edge(all_projections_partial{n}(:,:,3),'Roberts'), [0 1 1], 1);%non


%     imagesc(edge(all_projections_partial{n}(:,:,1),'canny'))

    set(gca,'xtick',[])
    set(gca,'ytick',[])
    colormap('gray')
    if n==1
        title(['Shock 0117 933'],'fontsize',14,'fontweight','bold')
        
        text(0.01*size(all_projections_partial{n},1),0.02*size(all_projections_partial{n},2),'Shock Day1 Only','fontsize',14,'color','r','fontweight','bold')
        text(0.01*size(all_projections_partial{n},1),0.10*size(all_projections_partial{n},2),'NonResponsive','fontsize',14,'color','c','fontweight','bold')
    else
        title(['Shock 0120 933'],'fontsize',14,'fontweight','bold')
        
        text(0.01*size(all_projections_partial{n},1),0.02*size(all_projections_partial{n},2),'Shock Day2 Only','fontsize',14,'color','r','fontweight','bold')
        text(0.01*size(all_projections_partial{n},1),0.10*size(all_projections_partial{n},2),'NonResponsive','fontsize',14,'color','c','fontweight','bold')
    end
    text(0.01*size(all_projections_partial{n},1),0.06*size(all_projections_partial{n},2),'Both','fontsize',14,'color',[.9 .9 .5],'fontweight','bold')
    %     text(0.01*size(all_projections_partial{n},1),0.11*size(all_projections_partial{n},2),'Responsive','fontsize',14,'color',[1 1 0],'fontweight','bold')
end

%% epifluorescence figure





