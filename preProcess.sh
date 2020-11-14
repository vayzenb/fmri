#!/bin/bash

# takes in previously created nifti files from the "rawData" folder, and then: skull-strips anatomicals, gets motion outlier covariates & cleans up the data directory before running FSL scripts.
# fk + ch 8/18/17
# Modified for DOTS by VA 12.5.18

# # get FreeSurfer on path
# export FREESURFER_HOME=/Applications/freesurfer
# source $FREESURFER_HOME/SetUpFreeSurfer.sh

subj_list="docnet1001"
cond="spaceloc adaptation"
#MRI acquisition number
epi_list_exp=(5 6 8 9 11 12 14 15)
epi_list_loc=(7 10 13 16)
#MRI run number
expNum=(1 2 3 4 5 6)
locNum=(1 2 3 4)

# main directory where setup files are stored
dataDir=/lab_data/behrmannlab/vlad/DocNet/


for sub in $subj_list; do
#Make subject, anat, and func directories
subj_dir=$dataDir/sub-${sub}/ses-01
cd $subj_dir
mkdir derivatives
mkdir /derivatives/fsl

#echo $sub
bet $subj_dir/anat/sub-${sub}_ses01_T1w.nii.gz $subj_dir/anat/sub-${sub}_ses01_T1w_brain.nii.gz -R -B #-f 0.5

for cc in $cond; do
cd derivatives/fsl
mkdir $cc

cd derivatives/fsl/${cc}

for exp in "${expNum[@]}"; do
	mkdir run0${exp} #create run folder
	#cd $subj_dir/DOC_func/run0${exp} #create run folder
	fsl_motion_outliers -i $subj_dir/func/sub-${sub}_ses-01_task-{$cc}_run-0${exp}_bold.nii.gz -o sub-${sub}_ses-01_task-{$cc}_run-0${exp}_bold_spikes.txt --dummy=0 #calculate motion spikes from nifty

done

done
done