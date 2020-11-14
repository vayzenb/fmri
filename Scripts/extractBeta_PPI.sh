#!/bin/bash
#Calculate percent signal change (PSC) to each task condition of interest

subj_list="1000 1001 1002 1003 1004 1005 1006 1007 1008 1009"

roi="V3ab pIPS aIPS V1"
#roi="EVC"

#Specify copes (contrasts) of interest
cond="d30p0b0 d60p0b0 d90p0b0 d0p30b1 d0p150b2 d0p180b2"

#Test each run type
#runType=""
#runType="10Runs"
dir="/Volumes/Zeus/DOC"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"
	funcDir="$subjDir/DOC_func/HighLevel"
	roiDir="$subjDir/ROIs"
	PPIDir="$subjDir/PPI"

	mkdir $PPIDir

	for r in $roi
	do

		#for rt in $runType
		#do
			for c in $cond
			do
				#echo ${funcDir}_${rt}.gfeat/cope${c}.feat/stats/cope1.nii.gz
				#For each ROI, run type, and cope:
				#divide cope image by global mean (mean_func), multiply by 100 (to make percent) and multiply by mask (to extract only in that region), create new nifty with %

				#Extract mean percent from each ROI and write to file
				#It extracts PPI for left hemi regions using the lLO and the seed; and right hemi from rLO
				fslstats ${funcDir}_${c}_lLO_PPI.gfeat/cope3.feat/stats/pe1.nii.gz -k ${roiDir}/l${r}.nii.gz -M >> ${PPIDir}/l${r}.txt
				fslstats ${funcDir}_${c}_rLO_PPI.gfeat/cope3.feat/stats/pe1.nii.gz -k ${roiDir}/r${r}.nii.gz -M >> ${PPIDir}/r${r}.txt

				echo l${r}

			done

		done
	done


echo "Dunzo!!"
#_${rt}