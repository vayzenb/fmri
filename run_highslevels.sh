#!/bin/sh

#Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012"
runs="1 2 3 4 5 6"
exp="spaceloc"

cond="spaceloc depthloc toolloc distloc"
suf=""


dataDir=/lab_data/behrmannlab/vlad/${exp}
for cc in $cond
do

    feat $dataDir/sub-${exp}1008/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}1009/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}1010/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}1011/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf 
    feat $dataDir/sub-${exp}1012/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf

done

