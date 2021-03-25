#!/bin/bash

#Extract timeseries for each ROI and save as a cov
dir="/Volumes/Zeus/DOC"

subj_list="1002"
#ROIs="lLO rLO lV3ab rV3ab lpIPS rpIPS laIPS raIPS"
#ROIs="lLO rLO"
ROIs="lV3 rV3"

runNum="1 2 3 4 5 6 7 8"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"

#fslmeants input ()
		for r in $ROIs
		do
			fslmeants -i $subjDir/PPI/DOC${s}_filtered_func.nii.gz -o $subjDir/PPI/${r}_timecourse.txt -m $subjDir/ROIs/${r}_peak.nii.gz


	done
done

