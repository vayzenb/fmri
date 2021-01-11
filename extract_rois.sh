#!/bin/bash

#Create ROIs via threshold
#uses broad anatomical parcels to localize ROIs
module load fsl-6.0.3

calc(){ awk "BEGIN { print "$*" }"; }

subj_list="docnet1001 docnet1002"
exp="docnet"
cond="spaceloc"
suf="_6Runs"

#Rois
roi=("V3ab" "PPC" "APC" "LO" "PFS" )                          

#Specify copes (contrasts) of interest
copeNum=("1" "1" "1" "2" "2")

#Extract top 1-n % voxels in ROI
n=90

dataDir=/lab_data/behrmannlab/vlad/docnet


for sub in $subj_list
do
	
	subjDir=$dataDir/sub-${sub}/ses-01/derivatives
	roiDir=$subjDir/rois
	funcDir=$subjDir/fsl/$cond/HighLevel$suf.gfeat
	
	mkdir $roiDir

	for r in 0 1 2 3 4
	do
		echo cope${copeNum[${r}]}
		echo l${roi[${r}]}

		fslmaths $funcDir/cope${copeNum[${r}]}.feat/cluster_mask_zstat1.nii.gz -mul $roiDir/parcels/l${roi[${r}]}.nii.gz -bin $roiDir/l${roi[${r}]}
		#check if parcel is empty; delete if it is
		vox_num=$(fslstats $roiDir/l${roi[${r}]}${sf}.nii.gz -V)
		if [[ ${vox_num::1} -eq "0" ]]; then 
			rm -f $roiDir/l${roi[${r}]}.nii.gz
		fi
		
		fslmaths $funcDir/cope${copeNum[${r}]}.feat/cluster_mask_zstat1.nii.gz -mul $roiDir/parcels/r${roi[${r}]}.nii.gz -bin $roiDir/r${roi[${r}]}
		#check if parcel is empty; delete if it is
		vox_num=$(fslstats $roiDir/r${roi[${r}]}${sf}.nii.gz -V)
		if [[ ${vox_num::1} -eq "0" ]]; then 
			rm -f $roiDir/r${roi[${r}]}.nii.gz
		fi
		#fslmaths $funcDir/cope${copeNum[${r}]}.feat/stats/zstat1.nii.gz -mul $roiDir/parcels/l${roi[${r}]}.nii.gz -thr 0 $roiDir/l${roi[${r}]}
		#fslmaths $roiDir/l${roi[${r}]} -thrP $n -bin $roiDir/l${roi[${r}]}
		#fslmaths $funcDir/cope${copeNum[${r}]}.feat/stats/zstat1.nii.gz -mul $roiDir/parcels/r${roi[${r}]}.nii.gz -thr 0 $roiDir/r${roi[${r}]}
		#fslmaths $roiDir/r${roi[${r}]} -thrP $n -bin $roiDir/r${roi[${r}]}

	done
done
echo "DUNZO!!"