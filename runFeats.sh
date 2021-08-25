#!/bin/sh

# Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006 spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012" 
subj_list="spaceloc1001" 
runs="1"
exp="spaceloc"
#cond="catmvpa"
cond="toolloc distloc"
#cond="spaceloc"
suf=""


dataDir=/lab_data/behrmannlab/vlad/${exp}

for sub in $subj_list
do
echo $sub
subjDir=$dataDir/sub-${sub}/ses-01/derivatives/fsl

    for cc in $cond
    do
        echo ${cc}
        feat $subjDir/${cc}/run-01/1stLevel${suf}.fsf 
        feat $subjDir/${cc}/run-02/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-03/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-04/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-05/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-06/1stLevel${suf}.fsf         

        feat $subjDir/${cc}/HighLevel${suf}.fsf 
        #feat $subjDir/${cc}/HighLevel_roi.fsf 
    done
    
    #feat $subjDir/spaceloc/HighLevel.fsf &
    #feat $subjDir/depthloc/HighLevel.fsf 
    #feat $subjDir/toolloc/HighLevel.fsf &
    #feat $subjDir/distloc/HighLevel.fsf 



#feat $subjDir/${cc}/HighLevel_odd.fsf &
#feat $subjDir/${cc}/HighLevel_even.fsf 
echo "Done ${sub}"
done