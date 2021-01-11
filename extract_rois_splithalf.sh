#!/bin/bash

#Uses odd/even runs to make seperate ROIs
#The general approach is to make a masks from a combo cluster corrected maps & broad anatomical parcels
#Mask image to just broad anatomical region, then mask within cluster corrected map
module load fsl-6.0.3

calc(){ awk "BEGIN { print "$*" }"; }

subj_list="docnet1001 docnet1002"
exp="docnet"
cond="spaceloc"
suff="_odd _even"

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
		mkdir $roiDir
		
	for sf in $suff
	do

		funcDir=$subjDir/fsl/$cond/HighLevel${sf}_smooth.gfeat
			

		for r in 0 1 2 3 4
		do
			echo cope${copeNum[${r}]}
			echo l${roi[${r}]}

			#Make a mask by multiplying the cluster-correct mask by broad anatomical parcel
			fslmaths $funcDir/cope${copeNum[${r}]}.feat/cluster_mask_zstat1.nii.gz -mul $roiDir/parcels/l${roi[${r}]}.nii.gz -bin $roiDir/l${roi[${r}]}${sf}
			#check if parcel is empty; delete if it is
			vox_num=$(fslstats $roiDir/l${roi[${r}]}${sf}.nii.gz -V)
			if [[ ${vox_num::1} -eq "0" ]]; then 
				rm -f $roiDir/l${roi[${r}]}${sf}.nii.gz
			fi

			fslmaths $funcDir/cope${copeNum[${r}]}.feat/cluster_mask_zstat1.nii.gz -mul $roiDir/parcels/r${roi[${r}]}.nii.gz -bin $roiDir/r${roi[${r}]}${sf}
			#check if parcel is empty; delete if it is
			vox_num=$(fslstats $roiDir/r${roi[${r}]}${sf}.nii.gz -V) #calcualtes number of voxels in mask
			if [[ ${vox_num::1} -eq "0" ]]; then 
				rm -f $roiDir/r${roi[${r}]}${sf}.nii.gz
			fi
			
		done

	done
done
echo "DUNZO!!"