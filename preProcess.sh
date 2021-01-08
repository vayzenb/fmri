#!/bin/bash

# takes in previously created nifti files from the "rawData" folder, and then: skull-strips anatomicals, gets motion outlier covariates & cleans up the data directory before running FSL scripts.
# fk + ch 8/18/17
# Modified for DOTS by VA 12.5.18

module load fsl-6.0.3

subj_list="docnet1002"
cond="spaceloc adaptation"

#MRI run number
expNum=(1 2 3 4 5 6)
locNum=(1 2 3 4)

# main directory where setup files are stored
dataDir=/lab_data/behrmannlab/vlad/docnet


for sub in $subj_list; do
#Make subject, anat, and func directories
subj_dir=$dataDir/sub-${sub}/ses-01
cd $subj_dir
mkdir derivatives
mkdir derivatives/covs
mkdir derivatives/fsl
mkdir covs

#echo $sub
bet $subj_dir/anat/sub-${sub}_ses-01_T1w.nii.gz $subj_dir/anat/sub-${sub}_ses-01_T1w_brain.nii.gz #-R -B -f 0.5
cd derivatives/fsl
for cc in $cond; do

mkdir $cc

cd ${cc}

for exp in "${expNum[@]}"; do
	mkdir run-0${exp} #create run folder
	
	fsl_motion_outliers -i $subj_dir/func/sub-${sub}_ses-01_task-${cc}_run-0${exp}_bold.nii.gz -o run-0${exp}/sub-${sub}_ses-01_task-${cc}_run-0${exp}_bold_spikes.txt --dummy=0 #calculate motion spikes from nifty

done

cd ..

done
done