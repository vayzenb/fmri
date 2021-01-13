% function xVSF_Analysis(img)

close all; clear all;

load('VoxelData_final.mat', 'VSFDATA');

subjects = [1:32]; % [1:35]; figureFileName = '~/Desktop/VSFadults.tif'; %adult
roinames = {'parcel_rOPA' 'parcel_lOPA' 'parcel_rPPA' 'parcel_lPPA' 'parcel_rRSC' 'parcel_lRSC' 'parcel_rMT' 'parcel_lMT' 'parcel_rV1' 'parcel_lV1' 'V1' 'MT' 'OPA' 'PPA' 'RSC'};
rois = [1 2 3 4 5 6 7 8 9 10]; % [1:10]; %,2,3,4];

averageDynStat = 0; %average over motion effect =1, no = 0
motionDiffScores = 0; %subjtract stat from dyn for each domain
sceneMinusObject = 0;

runs2use = [2005 1 2 3 4;
            2006 1 2 3 4;
            2007 1 3 4 NaN;
            2008 1 2 3 4;
            2009 1 2 3 4;
            2010 1 2 3 4;
            2011 1 3 NaN NaN;
            2012 1 2 3 4;
            2013 1 2 3 4;
            2014 1 2 3 4;
            2015 1 2 3 4;
            2016 1 2 3 4;
            2017 1 2 3 4;
            2018 1 2 3 4;
            2019 1 2 3 4;
            2020 1 2 3 4;
            3001 1 2 3 4;
            3002 1 2 3 NaN;
            3004 1 2 4 NaN;
            3005 1 2 3 NaN;
            3008 1 2 3 4;
            3009 1 2 3 4;
            3016 1 3 4 NaN;
            3017 1 2 3 4;
            3018 1 2 3 4;
            3019 1 2 NaN NaN;
            3022 1 2 3 4;
            3023 1 2 3 4;
            3024 1 2 3 NaN;
            3025 1 2 3 4;
            3027 1 2 3 4;
            3028 1 2 3 4];

%get ROIsizes
scaleByROIsize = 1;
if scaleByROIsize == 1
    for roi = 1:length(rois)
        for sub = 1:length(subjects)
            for perm = 1:size(VSFDATA.subject(1,subjects(sub)).perm,2)
                permSizes(roi,sub,perm) = size(VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS,1);
            end
            permSizes(permSizes == 0) = NaN;
            roiSizes(sub,roi) = min(permSizes(roi,sub,:));
        end
    end
    %use only some percentage of parcel?
    roiSizes = round(roiSizes*.1);
    binSize = roiSizes/20; binSize = floor(binSize);% binSize = round(binSize);
    numBins = floor(roiSizes./binSize);
    numVoxels = roiSizes; numVoxels = floor(numVoxels); % numVoxels = round(numVoxels);
else
    roiSizes = ones(length(rois),1)*150;
    binSize = 5; binSize = ones(length(rois),1)*binSize; binSize = round(binSize);
    numBins = floor(roiSizes./binSize);
    numVoxels = roiSizes; numVoxels = round(numVoxels);
end



%% first extract betas and subtract voxelwise to get contrasts of interest
for sub = 1:length(subjects)
    %set up perms
    goodRuns = runs2use(subjects(sub),2:end);
    goodRuns = goodRuns(~isnan(goodRuns)); %remove NaNs
    if length(goodRuns)>2
        locPerms = combnk(goodRuns,2); 
        clear expPerms
        for perm = 1:length(locPerms)
            expPerms(perm,:) = setdiff(goodRuns,locPerms(perm,:));
        end
    else
        locPerms = goodRuns';
        expPerms = [locPerms(2);locPerms(1)];
    end
    
    for roi = 1:length(rois)
        if size(VSFDATA.subject(1,subjects(sub)).perm(1).ROI(rois(roi)).VOXELS,1) >= 1 %numVoxels(rois(roi))
            
            for perm = 1:size(expPerms,1)
                condBetasA(:,perm) = VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS(1:numVoxels(sub,roi),1); 
                condBetasB(:,perm) = VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS(1:numVoxels(sub,roi),2); 
                condBetasC(:,perm) = VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS(1:numVoxels(sub,roi),3); 
                condBetasD(:,perm) = VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS(1:numVoxels(sub,roi),4); 
                condBetasE(:,perm) = VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS(1:numVoxels(sub,roi),5); 
                condBetasF(:,perm) = VSFDATA.subject(1,subjects(sub)).perm(perm).ROI(rois(roi)).VOXELS(1:numVoxels(sub,roi),6); 
            end
            
            %average the perms
            condBetasA_permMean = nanmean(condBetasA,2);
            condBetasB_permMean = nanmean(condBetasB,2);
            condBetasC_permMean = nanmean(condBetasC,2);
            condBetasD_permMean = nanmean(condBetasD,2);
            condBetasE_permMean = nanmean(condBetasE,2);
            condBetasF_permMean = nanmean(condBetasF,2);
            
            %save the data
            IEFP_VSF.A{roi}(:,sub) = nanmean(condBetasA_permMean); %(1:numVoxels);
            IEFP_VSF.B{roi}(:,sub) = nanmean(condBetasB_permMean); %(1:numVoxels);
            IEFP_VSF.C{roi}(:,sub) = nanmean(condBetasC_permMean); %(1:numVoxels);
            IEFP_VSF.D{roi}(:,sub) = nanmean(condBetasD_permMean); %(1:numVoxels);
            IEFP_VSF.E{roi}(:,sub) = nanmean(condBetasE_permMean); %(1:numVoxels);
            IEFP_VSF.F{roi}(:,sub) = nanmean(condBetasF_permMean); %(1:numVoxels);

            if averageDynStat == 1
                IEFP_VSF.A{roi}(:,sub) = (nanmean(condBetasA_permMean) + nanmean(condBetasC_permMean))/2; %(1:numVoxels);
                IEFP_VSF.B{roi}(:,sub) = (nanmean(condBetasB_permMean) + nanmean(condBetasD_permMean))/2; %(1:numVoxels);
                IEFP_VSF.C{roi}(:,sub) = (nanmean(condBetasE_permMean) + nanmean(condBetasF_permMean))/2; %(1:numVoxels);
            elseif motionDiffScores == 1
                IEFP_VSF.A{roi}(:,sub) = (nanmean(condBetasA_permMean) - nanmean(condBetasC_permMean)); %(1:numVoxels);
                IEFP_VSF.B{roi}(:,sub) = (nanmean(condBetasB_permMean) - nanmean(condBetasD_permMean)); %(1:numVoxels);
                IEFP_VSF.C{roi}(:,sub) = (nanmean(condBetasE_permMean) - nanmean(condBetasF_permMean)); %(1:numVoxels);
            elseif sceneMinusObject == 1
                IEFP_VSF.A{roi}(:,sub) = (nanmean(condBetasB_permMean) - nanmean(condBetasE_permMean)); %dyn scene - dyn obj
                IEFP_VSF.B{roi}(:,sub) = ((nanmean(condBetasB_permMean) + nanmean(condBetasD_permMean))/2) - ((nanmean(condBetasE_permMean) + nanmean(condBetasF_permMean))/2); %all scene - all obj
                IEFP_VSF.C{roi}(:,sub) = ((nanmean(condBetasB_permMean) + nanmean(condBetasD_permMean))/2) - ((nanmean(condBetasA_permMean) + nanmean(condBetasC_permMean) + nanmean(condBetasE_permMean) + nanmean(condBetasF_permMean))/4); %all scene - all face + obj
            end
            
            clear condBetasA condBetasB condBetasC condBetasD condBetasE condBetasF
        end
    end
end


%prep data for excel
for roi = 1:length(rois)
    excelData{roi}(:,1) = nanmean(IEFP_VSF.A{roi},1)';
    excelData{roi}(:,2) = nanmean(IEFP_VSF.C{roi},1)';
    excelData{roi}(:,3) = nanmean(IEFP_VSF.B{roi},1)';
    excelData{roi}(:,4) = nanmean(IEFP_VSF.D{roi},1)';
    excelData{roi}(:,5) = nanmean(IEFP_VSF.E{roi},1)';
    excelData{roi}(:,6) = nanmean(IEFP_VSF.F{roi},1)';
end

%prep for spss
spss = [excelData{1},excelData{2},excelData{3},excelData{4},excelData{5},excelData{6},excelData{7},excelData{8},excelData{9},excelData{10}];
spss_hc_preproc = [(excelData{1}+excelData{2})/2 ...
            (excelData{3}+excelData{4})/2 ...
            (excelData{5}+excelData{6})/2 ...
            (excelData{7}+excelData{8})/2 ...
            (excelData{9}+excelData{10})/2];

%hard coded condition averaging
spss_hc = nan(32,30);
for region = 1:6:25
    spss_hc(:,region) = spss_hc_preproc(:,region+3); %static scenes
    spss_hc(:,region+1) = spss_hc_preproc(:,region+5); %static objects
    spss_hc(:,region+2) = spss_hc_preproc(:,region+1); %static faces
    spss_hc(:,region+3) = spss_hc_preproc(:,region+2)-spss_hc_preproc(:,region+3); %scene motion
    spss_hc(:,region+4) = spss_hc_preproc(:,region+4)-spss_hc_preproc(:,region+5); %object motion
    spss_hc(:,region+5) = spss_hc_preproc(:,region)-spss_hc_preproc(:,region+1); %face motion
end

rdata = reshape(spss_hc,(size(spss_hc,2)*size(spss_hc,1)),1);
%append average V1 response to end
evcdata = mean(((excelData{9}+excelData{10})/2),2);
size(rdata)
rdata = [rdata;evcdata];
size(rdata)
        
%get dyn and stat scenes separately for OPA
OPAdynStatScene(:,1) = spss_hc_preproc(:,3); %dyn scene
OPAdynStatScene(:,2) = spss_hc_preproc(:,4); %stat scene
