#!/bin/sh

# Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006 spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012" 



subj_list="hemispace1007" 
runs="1 2 3"
exp="hemispace"
cond="spaceloc toolloc loc"

#cond="FBOSS_func"
#cond="spaceloc depthloc toolloc distloc"
#cond="spaceloc depthloc toolloc distloc"
suf="_roi"
sesh="01"


dataDir=/lab_data/behrmannlab/vlad/${exp}

for sub in $subj_list
do
echo $sub
    subjDir=$dataDir/sub-${sub}/ses-${sesh}/derivatives/fsl
    #subjDir=$dataDir/${sub}/

    for cc in $cond
    do
        echo ${cc}
        #feat $subjDir/${cc}/Run01/1stLevel_object.feat &
        #feat $subjDir/${cc}/Run02/1stLevel_object.feat &
        #feat $subjDir/${cc}/Run03/1stLevel_object.feat 
        echo $subjDir/${cc}/run-01/1stLevel${suf}.fsf 
        feat $subjDir/${cc}/run-01/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-02/1stLevel${suf}.fsf 
        feat $subjDir/${cc}/run-03/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-04/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-05/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-06/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-07/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-08/1stLevel${suf}.fsf 
                       

        #feat $subjDir/${cc}/run-02/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-03/1stLevel${suf}.fsf 
        #feat $subjDir/${cc}/run-04/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-05/1stLevel${suf}.fsf &
        #feat $subjDir/${cc}/run-06/1stLevel${suf}.fsf &        
        #feat $subjDir/${cc}/run-07/1stLevel${suf}.fsf         
        #feat $subjDir/${cc}/run-08/1stLevel${suf}.fsf         

        feat $subjDir/${cc}/HighLevel${suf}.fsf &
        #feat $subjDir/${cc}/HighLevel_roi.fsf 
    done
    
    #feat $subjDir/spaceloc/HighLevel${suf}.fsf &
    #feat $subjDir/depthloc/HighLevel${suf}.fsf 
    #feat $subjDir/toolloc/HighLevel${suf}.fsf 
    #feat $subjDir/distloc/HighLevel${suf}.fsf 
#feat $subjDir/${cc}/HighLevel_odd.fsf &
#feat $subjDir/${cc}/HighLevel_even.fsf 
echo "Done ${sub}"
done

#feat $subjDir/${cc}/HighLevel${suf}.fsf 