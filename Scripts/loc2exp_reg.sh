#!/bin/bash
#Register localizer ROIs to experimental session ROIs

subj_list="1002 1003"

roi="V1"
#roi="LO_peak"

dir="/Volumes/Zeus/DOC"


for s in $subj_list
do
	locDir="$dir/DOC${s}"
	expDir="$dir/DOC${s}"
	
	mkdir $expDir/ROIs
	
	#Create registration matrix from localizer anat to exp anatomy
	flirt -in $locDir/anat/DOC${s}_anatomy_brain.nii.gz -ref $expDir/anat/DOC${s}_anatomy_brain.nii.gz -omat $expDir/anat/loc2expFunc.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12	

	for r in $roi
	do
		#Register localizer ROIs to exp anat
		flirt -in $locDir/ROIs/l$r.nii.gz -ref $expDir/anat/DOC${s}_anatomy_brain.nii.gz -out $expDir/ROIs/l$r.nii.gz  -applyxfm -init $expDir/anat/loc2expFunc.mat -interp trilinear
		flirt -in $locDir/ROIs/r$r.nii.gz -ref $expDir/anat/DOC${s}_anatomy_brain.nii.gz -out $expDir/ROIs/r$r.nii.gz  -applyxfm -init $expDir/anat/loc2expFunc.mat -interp trilinear

		#Ensure they are binarized
		fslmaths $expDir/ROIs/l$r.nii.gz -bin $expDir/ROIs/l$r.nii.gz
		fslmaths $expDir/ROIs/r$r.nii.gz -bin $expDir/ROIs/r$r.nii.gz
	done
done

echo "Dunzo!!!"