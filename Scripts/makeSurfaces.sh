#!/bin/sh

#  generate surfaces
#
#  Created by Kamps, Frederik Strand on 12/16/13.
#

export FREESURFER_HOME=/Applications/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

subs2analyze="2010 2011 2012 2013 2014"
# runs2analyze="01 02 03 04 05 06 07 08"
SUBJECTS_DIR="/Applications/freesurfer/subjects"


for sub in $subs2analyze; do

mkdir -p /Applications/freesurfer/subjects/MAMRI${sub}/mri/orig
mkdir /Applications/freesurfer/subjects/MAMRI${sub}/label

mri_convert /Volumes/Zeus/MA-MRI/MAMRI${sub}/anat/MAMRI${sub}_anatomy_brain.nii.gz $SUBJECTS_DIR/MAMRI${sub}/mri/orig/001.mgz

recon-all -s MAMRI${sub} -autorecon-all


done