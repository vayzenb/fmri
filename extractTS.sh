#!/bin/bash

#Extract timeseries for each ROI and save as a cov
exp_dir=ginn/preschool_fmri/derivatives
study_dir=/lab_data/behrmannlab/vlad/${exp_dir}
roi_dir=$study_dir/ROIs
subj_dir=$study_dir/preprocessed_data
ROIs="LO PFS"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"

#fslmeants input ()
		for r in $ROIs
		do
			fslmeants -i $subjDir/PPI/DOC${s}_filtered_func.nii.gz -o $subjDir/PPI/${r}_timecourse.txt -m $subjDir/ROIs/${r}_peak.nii.gz


	done
done

for dir in $subj_dir/*/; do
    sub="$dir"
	#sub=$(echo "$sub" | sed "s/$subj_dir/ /g")
	sub=$(echo "$sub" | sed 's/.$//')

	echo $sub
done