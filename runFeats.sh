#!/bin/sh

# Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="docnet2005"
runs="1 2 3 4 5 6"
exp="docnet"
cond="kornet"
#cond="spaceloc depthloc toolloc distloc"
suf=""


dataDir=/lab_data/behrmannlab/vlad/${exp}

for sub in $subj_list
do

subjDir=$dataDir/sub-${sub}/ses-02/derivatives/fsl

    for cc in $cond
    do
        feat $subjDir/${cc}/run-01/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-02/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-03/1stLevel${suf}.fsf 
        feat $subjDir/${cc}/run-04/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-05/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-06/1stLevel${suf}.fsf 


    done

feat $subjDir/${cc}/HighLevel${suf}.fsf 
echo "Done ${sub}"
done