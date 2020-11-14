#!/bin/bash

#Register and combine runs for PPI
nRuns="1 2 3 4 5 6 7 8"

subj_list="1002"

dir="/Volumes/Zeus/DOC"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"
	funcDir="$subjDir/DOC_func/"
	ppiDir="$subjDir/PPI"

	mkdir $ppiDir

	for n in $nRuns
	do
		#normalize raw data
		fslmaths $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_data.nii.gz -sub $funcDir/Run${n}/1stLevel_filtered.feat/mean_func.nii.gz $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_norm.nii.gz	

		if [ "$n" = "1" ]; then
			#echo $n
			#if run 1, copy to PPI folder
			cp $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_norm.nii.gz $ppiDir/DOC${s}_filtered_func.nii.gz

		else
			#if not run 1 then
				#create registration matrix between nth run and run1 fuiltered func
			flirt -in $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_norm.nii.gz -ref $ppiDir/DOC${s}_filtered_func.nii.gz -omat $funcDir/Run${n}/1stLevel_filtered.feat/filter_func.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12

			#Register the two filtered func images to one another
			flirt -in $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_norm.nii.gz -ref $ppiDir/DOC${s}_filtered_func.nii.gz -out $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_norm.nii.gz -applyxfm -init $funcDir/Run${n}/1stLevel_filtered.feat/filter_func.mat -interp trilinear
			
			#Concatenate them
			fslmerge -tr $ppiDir/DOC${s}_filtered_func.nii.gz $ppiDir/DOC${s}_filtered_func.nii.gz $funcDir/Run${n}/1stLevel_filtered.feat/filtered_func_norm.nii.gz 1
 			#echo not 1
		fi

		
	done
done
