#!/bin/bash
export FREESURFER_HOME=/Applications/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

SUBJECTS_DIR="/Applications/freesurfer/subjects"

sub="1007 1008 1009"

for i in $sub;
do
#create original and ROI label folders in subject directory
mkdir -p /Applications/freesurfer/subjects/DOC${i}/
mkdir -p /Applications/freesurfer/subjects/DOC${i}/mri/orig
mkdir -p /Applications/freesurfer/subjects/DOC${i}/label

#convert anatomical NIFTY to .mgz
mri_convert /Volumes/Zeus/DOC/DOC${i}/anat/DOC${i}_anatomy_brain.nii.gz /Applications/freesurfer/subjects/DOC${i}/mri/orig/anat.mgz

done