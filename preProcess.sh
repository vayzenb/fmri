#!/bin/bash

# takes in previously created nifti files from the "rawData" folder, and then: skull-strips anatomicals, gets motion outlier covariates & cleans up the data directory before running FSL scripts.
# fk + ch 8/18/17
# Modified for DOTS by VA 12.5.18

# # get FreeSurfer on path
# export FREESURFER_HOME=/Applications/freesurfer
# source $FREESURFER_HOME/SetUpFreeSurfer.sh
module load fsl-6.0.3
subj_list="hemispace1001"
#subj_list="docnet2013 docnet2014 docnet2015 docnet2016"
proj="hemispace"
#cond="spaceloc depthloc distloc toolloc"
cond="spaceloc toolloc"
#MRI acquisition number
epi_list_exp=(5 6 8 9 11 12 14 15)
epi_list_loc=(7 10 13 16)
#MRI run number
expNum=(1 2 3)


# main directory where setup files are stored
dataDir=/lab_data/behrmannlab/vlad/$proj/



for sub in $subj_list; do
        echo $sub
        #Make subject, anat, and func directories
        subj_dir=$dataDir/sub-${sub}/ses-01
        cd $subj_dir
        mkdir $subj_dir/derivatives
        mkdir $subj_dir/derivatives/fsl
        mkdir $subj_dir/covs

        #echo $sub
        #bet $subj_dir/anat/sub-${sub}_ses-01_T1w.nii.gz $subj_dir/anat/sub-${sub}_ses-01_T1w_brain.nii.gz -R -B #-f 0.5

        for cc in $cond; do
                cd derivatives/fsl
                mkdir $cc                

                for exp in "${expNum[@]}"; do
                        mkdir ${cc}/run-0${exp} #create run folder
                        
                        fsl_motion_outliers -i $subj_dir/func/sub-${sub}_ses-01_task-${cc}_run-0${exp}_bold.nii.gz -o ${cc}/run-0${exp}/sub-${sub}_ses-01_task-${cc}_run-0${exp}_bold_spikes.txt --dummy=0 #calculate motion spikes from nifty
                        
                done
                
        done
done
