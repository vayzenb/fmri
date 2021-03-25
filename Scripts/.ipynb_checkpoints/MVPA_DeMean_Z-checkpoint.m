% MVPA_DeMean.m
%
% save voxel coordinates and beta values for specified ROIs and contrasts
% save peak voxel coordinates out of specified ROIs and contrasts
%
%cd /Volumes/Zeus/MA-MRI/RSA/ 
%Extracts zstat from func images

setenv('FSLOUTPUTTYPE', 'NIFTI_GZ'); % this to tell what the output type would be
setenv('FSLDIR','/usr/local/fsl');

sub = {'MAMRI2000', 'MAMRI2001', 'MAMRI2002', 'MAMRI2003', 'MAMRI2004', 'MAMRI2005', 'MAMRI2006', 'MAMRI2007', 'MAMRI2008', 'MAMRI2009','MAMRI2010', ...
    'MAMRI2011','MAMRI2012', 'MAMRI2013', 'MAMRI2014', 'MAMRI2015', 'MAMRI2016', 'MAMRI2017', 'MAMRI2018', 'MAMRI2019'};
%sub = {'MAMRI2013', 'MAMRI2014'};
cond = {'RSA'};
roi = {'lV1', 'rV1', 'lV2', 'rV2', 'lV3', 'rV3', 'lV4', 'rV4', 'lLO','rLO','lPFS','rPFS','lEBA_noLO','rEBA_noLO', 'lFBA', 'rFBA'};
locCopeNum = [4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 1, 1, 1, 1];%localizor copes  
homeDir = '/Volumes/Zeus/MA-MRI';
outDir = sprintf('%s/RSA', homeDir);
expCopeNum = 2:13; %experimantal copes

for s = 1:length(sub)
    roiDir = [homeDir,'/', sub{s}, '/ROIs'];
    
    %for r = 1:1
    for r = 1:length(roi)
        
        roiMask = [roiDir, '/',roi{r}, '.nii.gz'];
        
        
        if exist(roiMask)~=0
                                   
            % grab ROI voxels from the foss localizer
            %If EVC parcels, use the voxxels from the probabilistic maps
            if locCopeNum(r) ~= 4
                fbossCmd{r} = ['/usr/local/fsl/bin/fslmeants -i ', homeDir, '/', sub{s}, '/FBOSS_func/HighLevel.gfeat/cope',int2str(locCopeNum (r)), '.feat/stats/zstat1.nii.gz -o ',...
                    outDir, '/', roi{r},'_FBOSS.txt -m ', roiMask, ' --showall --transpose']
            else
                fbossCmd{r} = ['/usr/local/fsl/bin/fslmeants -i ', '/Volumes/Zeus/MA-MRI/', sub{s},'/ROIs/', roi{r}, '_prob.nii.gz -o ',...
                    outDir, '/', roi{r},'_FBOSS.txt -m ', roiMask, ' --showall --transpose']
            end

           system(fbossCmd{r});            %execture fsl function
           fboss = load([outDir, '/',roi{r}, '_FBOSS.txt']);  % load foss voxel mat (contains vox coordinates and values)
            
            
                
                mkdir([outDir,'/',cond{1}]); 
               
                 %% grab voxels from the experimental conditions
                for ii = 1:length(expCopeNum)
                   cmd{ii} = ['/usr/local/fsl/bin/fslmeants -i ', homeDir, '/', sub{s},'/MAMRI_func/HighLevel_', cond{1}, '.gfeat/cope', int2str(expCopeNum(ii)), '.feat/stats/zstat1.nii.gz -o ',...
                       outDir, '/', cond{1}, '/',sub{s},'_', cond{1},'_', roi{r}, '_',int2str(expCopeNum(ii)), '.txt -m ', roiMask, ' --showall --transpose']
                   system(cmd{ii});
                   condData{1, ii} = load([outDir, '/', cond{1}, '/', sub{s}, '_', cond{1}, '_',roi{r},'_', int2str(expCopeNum(ii)),'.txt']);
                end
                              
                
                %% demean
                condCat = fboss(:,:);
                for ii = 1:length(condData)
                    condCat = [condCat, condData{1, ii}(:,4)];
                end
                
                %Remove any zeros
                condCat = condCat(condCat(:,5)~=0, :);
                
                condsCat_sorted = sortrows(condCat,4); % sort rows based on the foss voxel values
                condsSort = condsCat_sorted(:,5:end); % get rid of the foss part of the matrix
                condsSort_flipped = flipud(condsSort); % flip the matrix so that it is descending
                
                m = mean(condsSort_flipped,2); % get mean across rows
                
                dmVals{1} = condsSort_flipped;
                                      
                
                for ii = 1:length(expCopeNum)
                     MAMRIDATA.subject(1).ROI(r).RSA(:,ii) = condsSort_flipped(:,ii) - m;;
                end
        

        else %put a NaN in place if no ROI exists
            MAMRIDATA.subject(1).ROI(r).RSA = NaN;
           
        end;
    end


    save(['MAMRIDATA_',sub{s}(6:end)],'MAMRIDATA');
    clear MAMRIDATA
end

