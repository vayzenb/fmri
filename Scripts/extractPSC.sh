#!/bin/bash
#Calculate percent signal change (PSC) to each task condition of interest

subj_list="1000 1001 1002 1003 1004 1005 1006 1007 1008 1009"

roi="LO PFS V3ab PPC APC IPL SPL"
#roi="V1"

#Specify copes (contrasts) of interest
copeNum="1 2 3 4 5 6 7 8"

#Test each run type
#runType=""
#runType="10Runs"
dir="/Volumes/Zeus/DOC"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"
	funcDir="$subjDir/DOC_func/HighLevel_Activation"
	roiDir="$subjDir/ROIs"
	PSCDir="$subjDir/PSC"

	mkdir $PSCDir

	rm -rf $PSCDir/*.txt

	for r in $roi
	do

		#for rt in $runType
		#do
			for c in $copeNum
			do
				#echo ${funcDir}_${rt}.gfeat/cope${c}.feat/stats/cope1.nii.gz
				#For each ROI, run type, and cope:
				#divide cope image by global mean (mean_func), multiply by 100 (to make percent) and multiply by mask (to extract only in that region), create new nifty with %
				fslmaths ${funcDir}.gfeat/cope${c}.feat/stats/cope1.nii.gz -div ${funcDir}.gfeat/mean_func.nii.gz -mul 100 -mul ${roiDir}/l${r}.nii.gz ${PSCDir}/l${r}_cope${c}.nii.gz
				fslmaths ${funcDir}.gfeat/cope${c}.feat/stats/cope1.nii.gz -div ${funcDir}.gfeat/mean_func.nii.gz -mul 100 -mul ${roiDir}/r${r}.nii.gz ${PSCDir}/r${r}_cope${c}.nii.gz

				#Extract mean percent from each ROI and write to file
				fslstats ${PSCDir}/l${r}_cope${c}.nii.gz -M >> ${PSCDir}/l${r}.txt
				fslstats ${PSCDir}/r${r}_cope${c}.nii.gz -M >> ${PSCDir}/r${r}.txt

				
			done

		done
		rm -rf $PSCDir/*nii.gz
	done


echo "Dunzo!!"
#_${rt}