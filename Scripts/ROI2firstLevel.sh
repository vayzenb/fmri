#!/bin/bash

#Register ROIs fomr anatomical space to 1stLevel filtered func space
nRuns="1 2 3 4 5 6 7 8"

subj_list="1007 1008 1009"

dir="/Volumes/Zeus/DOC"

roi="lLO_peak rLO_peak sgmt_seg_0 sgmt_seg_1 sgmt_seg_2"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"
	funcDir="$subjDir/DOC_func"
	roiDir="$subjDir/ROIs"
	#ppiDir="$subjDir/PPI"

	mkdir $ppiDir

	for n in $nRuns
	do
		mkdir $funcDir/Run${n}/ROIs/
		for r in $roi
		do
				#Register ROIs fomr anatomical space to 1stLevel filtered func space
				flirt -in $roiDir/${r} -ref $funcDir/Run${n}/1stLevel_Activation.feat/example_func.nii.gz -out $funcDir/Run${n}/ROIs/${r}.nii.gz  -applyxfm -init $funcDir/Run${n}/1stLevel_Activation.feat/reg/standard2example_func.mat -interp trilinear

		#Ensure they are binarized
		fslmaths $funcDir/Run${n}/ROIs/${r}.nii.gz -bin $funcDir/Run${n}/ROIs/${r}.nii.gz
			done	
	done	
done
echo "DUNZO!!!"