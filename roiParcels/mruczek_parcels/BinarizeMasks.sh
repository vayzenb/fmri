#!/bin/bash

#Directories
origDir=/home/vayzenbe/GitHub_Repos/fmri/roiParcels/mruczek_parcels/subj_vol_all
binaryDir=/home/vayzenbe/GitHub_Repos/fmri/roiParcels/mruczek_parcels/binary
labelDir=/home/vayzenbe/GitHub_Repos/fmri/roiParcels/mruczek_parcels/LabledROIs
thresh=1

roi="20 21 22 23 24 25"
roi_num=("14" "15")
roi_name=("LO2" "LO1")

for rr in 0 1
do
	#Convert left and right hemispheres to Binary 
	echo $origDir/perc_VTPM_vol_roi${roi_num[${rr}]}
	#with hole filling
	fslmaths $origDir/perc_VTPM_vol_roi${roi_num[${rr}]}_lh.nii.gz -thr $thresh -bin -fillh $binaryDir/l${roi_name[${rr}]}.nii.gz
	fslmaths $origDir/perc_VTPM_vol_roi${roi_num[${rr}]}_rh.nii.gz -thr $thresh -bin -fillh $binaryDir/r${roi_name[${rr}]}.nii.gz

	#copy and relabel with probabilistic values
	cp $origDir/perc_VTPM_vol_roi${roi_num[${rr}]}_lh.nii.gz $labelDir/l${roi_name[${rr}]}.nii.gz
	cp $origDir/perc_VTPM_vol_roi${roi_num[${rr}]}_rh.nii.gz $labelDir/r${roi_name[${rr}]}.nii.gz
	#fslmaths $origDir/perc_VTPM_vol_roi${roi_num[${rr}]}_lh.nii.gz -thr $thresh -bin -fillh $binaryDir/l${roi_name[${rr}]}.nii.gz
	#fslmaths $origDir/perc_VTPM_vol_roi${roi_num[${r}]}_rh.nii.gz -thr $thresh -bin -fillh $binaryDir/r${roi_name[${rr}]}.nii.gz
	#fslmaths $origDir/perc_VTPM_vol_roi${r}_lh.nii.gz -thr $thresh -bin $binaryDir/perc_VTPM_vol_roi${r}_lh.nii.gz
	#fslmaths $origDir/perc_VTPM_vol_roi${r}_rh.nii.gz -thr $thresh -bin  $binaryDir/perc_VTPM_vol_roi${r}_rh.nii.gz

done