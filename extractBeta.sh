#!/bin/bash
#Calculate percent signal change (PSC) to each task condition of interest

subj_list="docnet1001"


subj_list="docnet1001"
exp="docnet"
cond="spaceloc"

#Rois
roi="V3ab PPC APC LO PFS"
#roi=("V3ab" "PPC" "APC" "LO" "PFS" )     
#Specify copes (contrasts) of interest
cope="1 2 3 4 5 6"


dataDir=/lab_data/behrmannlab/vlad/docnet

for sub in $subj_list
do
	subjDir=$dataDir/sub-${sub}/ses-01/derivatives
	roiDir=$subjDir/rois
	funcDir=$subjDir/fsl/$cond/HighLevel_6Runs.gfeat

	mkdir $subjDir/beta
	resultDir=$subjDir/beta

	for r in $roi
	do
		echo ${r}
		#for rt in $runType
		#do
			for c in $cope
			do
				#echo ${funcDir}_${rt}.gfeat/cope${c}.feat/stats/cope1.nii.gz
				#Extract mean beta from each ROI and write to file
				fslstats $funcDir/cope${c}.feat/stats/zstat1.nii.gz -k $roiDir/l${r}.nii.gz -M >> $resultDir/l${r}.txt
				fslstats $funcDir/cope${c}.feat/stats/zstat1.nii.gz -k $roiDir/r${r}.nii.gz -M >> $resultDir/r${r}.txt

				echo ${c}

			done

		done
	done


echo "Dunzo!!"
#_${rt}