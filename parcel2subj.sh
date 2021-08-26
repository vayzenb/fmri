#!/bin/bash

module load fsl-6.0.3



subj_list="1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012"
subj_list=""
exp="spaceloc"
roi="V3ab V4 PPC APC"
roi="LO1 LO2 LO"
parcelType=mruczek_parcels/LabledROIs
#parcelType=julian_parcels
mniBrain=$FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz #this is the parcel for both julian and mruczek
anat=$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz #all subs were registered to a 2mm brain

parcelDir=/home/vayzenbe/GitHub_Repos/fmri/roiParcels/$parcelType
studyDir=/lab_data/behrmannlab/vlad/${exp}
#labelDir=/home/vayzenbe/GitHub_Repos/fmri/roiParcels/$parcelType

for sub in $subj_list
do
	subjDir=$studyDir/sub-${exp}${sub}/ses-01/derivatives
	#anat=$studyDir/sub-${exp}${sub}/ses-01/anat/sub-${exp}${sub}_ses-01_T1w_brain.nii.gz	
    #anat=$studyDir/preprocessed_data/sub-${sub}/sub-${sub}_normed_anat.nii.gz
	mkdir $subjDir/rois
	mkdir $subjDir/rois/parcels
	roiDir=$subjDir/rois/parcels
	
	#Create registration matrix from MNI to anatomy
	flirt -in $mniBrain -ref $anat -omat $roiDir/stand2func.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12	
	
	for rr in $roi
	do
		#Register binary files to anatomical
		flirt -in $parcelDir/l${rr}.nii.gz -ref $anat -out $roiDir/l${rr}.nii.gz -applyxfm -init $roiDir/stand2func.mat -interp trilinear
		flirt -in $parcelDir/r${rr}.nii.gz -ref $anat -out $roiDir/r${rr}.nii.gz -applyxfm -init $roiDir/stand2func.mat -interp trilinear	
	done

done
