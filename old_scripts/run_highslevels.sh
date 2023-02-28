#!/bin/sh

#Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="hemispace1001 hemispace1002 hemispace1003 hemispace2001 hemispace2002 hemispace2003" 
runs="1 2 3 4 5 6"
exp="hemispace"

cond="loc toolloc spaceloc"
suf="_roi_stand"


dataDir=/lab_data/behrmannlab/vlad/${exp}
for cc in $cond
do

    feat $dataDir/sub-${exp}1001/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}1002/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}1003/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf 
    feat $dataDir/sub-${exp}2001/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}2002/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    feat $dataDir/sub-${exp}2003/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf 
    #feat $dataDir/sub-${exp}1007/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    #feat $dataDir/sub-${exp}1008/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf 
    #feat $dataDir/sub-${exp}1009/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    #feat $dataDir/sub-${exp}1010/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    #feat $dataDir/sub-${exp}1011/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf &
    #feat $dataDir/sub-${exp}1012/ses-01/derivatives/fsl/${cc}/HighLevel${suf}.fsf

done

