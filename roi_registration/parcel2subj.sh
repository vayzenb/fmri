#!/bin/bash

module load fsl-6.0.3



subj_list="1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012"
subj_list="025 038 057 059 064 067 068 071 083 084 085 087 088 093 094 095 096 097\
 103 104 105 106 107\
  hemispace1001 hemispace1002 hemispace1003 hemispace2001 hemispace2002 hemispace2003\
   spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006\
    spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012\
	 spaceloc2013 spaceloc2014 spaceloc2015 spaceloc2016 spaceloc2017 spaceloc2018"
subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006\
    spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012\
	 spaceloc2013 spaceloc2014 spaceloc2015 spaceloc2016 spaceloc2017 spaceloc2018"

exp="bwoc"

#roi="PPC APC"
roi="LO PFS"
parcelType=mruczek_parcels/binary
parcelType=julian_parcels
mniBrain=$FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz #this is the parcel for both julian and mruczek
anat=$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz #all subs were registered to a 2mm brain

parcelDir=/user_data/vayzenbe/GitHub_Repos/fmri/roiParcels/$parcelType
studyDir=/lab_data/behrmannlab/vlad/${exp}
#labelDir=/home/vayzenbe/GitHub_Repos/fmri/roiParcels/$parcelType

erode_n=1

for sub in $subj_list
do
	echo $sub
	subjDir=$studyDir/sub-${sub}/ses-01/derivatives
	#anat=$studyDir/sub-${sub}/ses-01/anat/sub-${sub}_ses-01_T1w_brain_mirrored.nii.gz	
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
		#flirt -in $parcelDir/${rr}.nii.gz -ref $anat -out $roiDir/${rr}.nii.gz -applyxfm -init $roiDir/stand2func.mat -interp trilinear	

		#fill holes in the binary files
		fslmaths $roiDir/l${rr}.nii.gz -fillh $roiDir/l${rr}.nii.gz
		fslmaths $roiDir/r${rr}.nii.gz -fillh $roiDir/r${rr}.nii.gz

		#erode the binary files for erode_n steps
		for ((i=0; i<$erode_n; i++))
		do
			fslmaths $roiDir/l${rr}.nii.gz -kernel 3D -ero $roiDir/l${rr}.nii.gz
			fslmaths $roiDir/r${rr}.nii.gz -kernel 3D -ero $roiDir/r${rr}.nii.gz
		done



	done

done
