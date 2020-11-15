#!/bin/sh

# Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="docnet1001" #03 04 05 06 07 08 09 10 11 12 13 14 15 16"
runs="1 2 3 4 5 6"
exp="docnet"
cond="spaceloc adaptation"


dataDir=/lab_data/behrmannlab/vlad/${exp}

for sub in $subj_list
do

subjDir=$dataDir/sub-${sub}/ses-01/derivatives/fsl

    for cc in $cond
    do
        #feat $subjDir/${cc}/run-01/1stLevel.fsf 
        feat $subjDir/${cc}/run-02/1stLevel.fsf &
        feat $subjDir/${cc}/run-03/1stLevel.fsf &
        feat $subjDir/${cc}/run-04/1stLevel.fsf &
        feat $subjDir/${cc}/run-05/1stLevel.fsf &
        feat $subjDir/${cc}/run-06/1stLevel.fsf 


    done

#feat $subjDir/HighLevel_Activation.fsf
echo "Done ${s}"
done


