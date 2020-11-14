#!/bin/bash

mniBrain="/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz"

subj_list="1000 1001 1002 1003 1004 1005 1006 1007 1008 1009"
#subj_list="2001"
roi=('LOC', 'PFS')
#roiNum=('14' '15' '16' '17' '18' '19')

binaryDir="/Volumes/Zeus/DOC/Scripts/roiParcels/Ventral_Parcels"
#origDir="/Volumes/Zeus/DOC/Scripts/roiParcels/ProbAtlas_v4/subj_vol_all"
dir="/Volumes/Zeus/DOC"


for s in $subj_list
do
	subjDir="$dir/DOC${s}/anat"
	roiDir="$dir/DOC${s}/ROIs/Parcels"

	#Create registration matrix from MNI to anatomy
	flirt -in $mniBrain -ref $subjDir/DOC${s}_anatomy_brain.nii.gz -omat $subjDir/stand2func.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12	

	for i in 0 1 
	do

		#Register binary files to anatomical
		flirt -in $binaryDir/parcel_l${roi[${i}]}.nii.gz -ref $subjDir/DOC${s}_anatomy_brain.nii.gz -out $roiDir/l${roi[${i}]}_binary.nii.gz  -applyxfm -init $subjDir/stand2func.mat -interp trilinear
		flirt -in $binaryDir/parcel_r${roi[${i}]}.nii.gz -ref $subjDir/DOC${s}_anatomy_brain.nii.gz -out $roiDir/r${roi[${i}]}_binary.nii.gz  -applyxfm -init $subjDir/stand2func.mat -interp trilinear
	done

done
