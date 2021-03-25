#!/bin/bash

#create cortex segmentation
#Extract anatomical level covs (CSF , White matter, gray matter)
subj_list="1007	1008 1009"

dir="/Volumes/Zeus/DOC"

for s in $subj_list;
do

subjDir="$dir/DOC${s}"
funcDir="$subjDir/DOC_func/"
ppiDir="$subjDir/PPI"

#Register anatomical to filtered_func_space 
#flirt -in ${subjDir}/anat/DOC${s}_anatomy_brain.nii.gz -ref $ppiDir/DOC${s}_filtered_func.nii.gz -out ${subjDir}/ROIs/DOC${s}_anatomy_brain.nii.gz -applyxfm -init $funcDir/Run1/1stLevel.feat/reg/standard2example_func.mat -interp trilinear

#Extract CSF, WM, GM segments from anatomical
fast -t 1 -n 3 -H 0.1 -I 4 -l 20 -g -o ${subjDir}/ROIs/sgmt ${subjDir}/anat/DOC${s}_anatomy_brain.nii.gz

#seg0 = CSF
#seg1 = GM
#seg2 = WM

#Extract meanTS in each mask; save as a text file to be used as a cov
fslmeants -i $ppiDir/DOC${s}_filtered_func.nii.gz -o $ppiDir/DOC${s}_CSF.txt -m ${subjDir}/anat/DOC${s}_sgmt_seg_0.nii.gz
fslmeants -i $ppiDir/DOC${s}_filtered_func.nii.gz -o $ppiDir/DOC${s}_GM.txt -m ${subjDir}/anat/DOC${s}_sgmt_seg_1.nii.gz
fslmeants -i $ppiDir/DOC${s}_filtered_func.nii.gz -o $ppiDir/DOC${s}_WM.txt -m ${subjDir}/anat/DOC${s}_sgmt_seg_2.nii.gz


done
