#!/bin/bash

#Directories
origDir="/Volumes/Zeus/DOC/Scripts/roiParcels/ProbAtlas_v4/subj_vol_all"
binaryDir="/Volumes/Zeus/DOC/Scripts/roiParcels/ProbAtlas_v4/Binary"
thresh=1

roi="20 21 22 23 24 25"

for r in $roi
do
	#Convert left and right hemispheres to Binary 

	#with hole filling
	fslmaths $origDir/perc_VTPM_vol_roi${r}_lh.nii.gz -thr $thresh -bin -fillh $binaryDir/perc_VTPM_vol_roi${r}_lh.nii.gz
	fslmaths $origDir/perc_VTPM_vol_roi${r}_rh.nii.gz -thr $thresh -bin -fillh $binaryDir/perc_VTPM_vol_roi${r}_rh.nii.gz

	#without hole filling
	#fslmaths $origDir/perc_VTPM_vol_roi${r}_lh.nii.gz -thr $thresh -bin $binaryDir/perc_VTPM_vol_roi${r}_lh.nii.gz
	#fslmaths $origDir/perc_VTPM_vol_roi${r}_rh.nii.gz -thr $thresh -bin  $binaryDir/perc_VTPM_vol_roi${r}_rh.nii.gz

done