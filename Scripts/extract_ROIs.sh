#!/bin/bash

#Create ROIs


calc(){ awk "BEGIN { print "$*" }"; }

subj_list="1000 1001 1002 1003 1004 1005 1006 1007 1008 1009"

roi=("LO" "PFS" "V3ab" "PPC" "APC")                          

#Specify copes (contrasts) of interest
copeNum=("2" "2" "3" "3" "3")

#Extract top n% voxels in ROI
n=90

dir="/Volumes/Zeus/DOC"
parcelDir="$dir/Parcels"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"
	funcDir="$subjDir/DOTS_func/HighLevel.gfeat"
	roiDir="$subjDir/ROIs"
	mkdir $roiDir

	for r in 0 1 2 3 4
	do
		echo cope${copeNum[${r}]}
		echo l${roi[${r}]}

		fslmaths $funcDir/cope${copeNum[${r}]}.feat/stats/zstat1.nii.gz -mul $parcelDir/l${roi[${r}]}_Binary.nii.gz -thr 0 $roiDir/l${roi[${r}]}
		fslmaths $roiDir/l${roi[${r}]} -thrP $n -bin $roiDir/l${roi[${r}]}

		fslmaths $funcDir/cope${copeNum[${r}]}.feat/stats/zstat1.nii.gz -mul $parcelDir/r${roi[${r}]}_Binary.nii.gz -thr 0 $roiDir/r${roi[${r}]}
		fslmaths $roiDir/r${roi[${r}]} -thrP $n -bin $roiDir/r${roi[${r}]}

	done
done
echo "DUNZO!!"