#!/bin/bash

roi=("dist_lSPL" "dist_rSPL" "dist_rIPL" "depth_lvIPS" "depth_rvIPS" "depth_ldIPS" "depth_rdIPS" "tool_rhand" "tool_laIPS" "WM_lsIPS" "WM_rsIPS")
mni=$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz

#Voxel coordinates
#note these were drawn by pulling MNI coords and figuring out where the would be in FSL space

x=(54 34 20 57 26 58 34 29 63 62 25)
y=(32 33 47 27 23 31 32 47 38 35 35)
z=(63 66 52 55 46 64 64 64 59 62 61)

proj_dir="/lab_data/behrmannlab/vlad/spaceloc/"
parcelDir="$proj_dir/derivatives/rois/dorsal_spheres"

n=50

for r in 0 1 2 3 4 5 6 7 8 9 10
do
	#Select point in MNI space
	fslmaths $mni -mul 0 -add 1 -roi ${x[${r}]} 1 ${y[${r}]} 1 ${z[${r}]} 1 0 1 $parcelDir/${roi[${r}]}.nii.gz -odt float

	#Create sphere around that point
	fslmaths $parcelDir/${roi[${r}]}.nii.gz -kernel sphere 5 -fmean $parcelDir/${roi[${r}]}.nii.gz -odt float


	#Binarize the sphere
	fslmaths $parcelDir/${roi[${r}]}.nii.gz -bin $parcelDir/${roi[${r}]}.nii.gz

	echo ${roi[${r}]}

done

#fslmaths $mni -mul 0 -add 1 -roi 54 1 32 1 63 1 0 1 $parcelDir/dist_lSPL.nii.gz -odt float