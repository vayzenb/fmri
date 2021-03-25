#!/bin/bash

# makes .nii roi masks from the FS labels.
# puts masks in subject's roi dir in the local ppaLayout experiment dir.

subj_list="1002"

roi="V1"
#roi="rpIPS"

 
# ""
# get FreeSurfer on path
export FREESURFER_HOME=/Applications/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

for i in $subj_list
do

inDir="/Applications/freesurfer/subjects/DOTS${i}/label"
outDir="/Volumes/Zeus/DOC/DOC${i}/ROIoutdir"
tempDir="/Applications/freesurfer/subjects/DOTS${i}/mri/orig"
niiDir="/Volumes/Zeus/DOC/DOC${i}/ROIs"

#mkdir $outDir
mkdir $niiDir

for j in $roi
do

mri_label2vol --label $inDir/$j.label --temp $tempDir/anat.mgz --identity --o $niiDir/$j.nii.gz
done

#mv $outDir/* $niiDir
#rm -rf $outDir
done
