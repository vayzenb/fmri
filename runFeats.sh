#!/bin/sh

# Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20
module load fsl-6.0.3

subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006 spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012" 
subj_list="MAMRI2000 MAMRI2001 MAMRI2002 MAMRI2003 MAMRI2004 MAMRI2005 MAMRI2006 MAMRI2007 MAMRI2008 MAMRI2009 MAMRI2010 MAMRI2011 MAMRI2012 MAMRI2013 MAMRI2014 MAMRI2015 MAMRI2016 MAMRI2017 MAMRI2018 MAMRI2019"

subj_list="docnet2004" 
runs="1 2 3"
exp="docnet"
cond="catmvpa"
#cond="FBOSS_func"
#cond="spaceloc"
suf=""


dataDir=/lab_data/behrmannlab/vlad/${exp}

for sub in $subj_list
do
echo $sub
    subjDir=$dataDir/sub-${sub}/ses-02/derivatives/fsl
    #subjDir=$dataDir/${sub}/

    for cc in $cond
    do
        echo ${cc}
        #feat $subjDir/${cc}/Run01/1stLevel_object.feat &
        #feat $subjDir/${cc}/Run02/1stLevel_object.feat &
        #feat $subjDir/${cc}/Run03/1stLevel_object.feat 
        feat $subjDir/${cc}/run-01/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-02/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-03/1stLevel${suf}.fsf 
        feat $subjDir/${cc}/run-04/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-05/1stLevel${suf}.fsf &
        feat $subjDir/${cc}/run-06/1stLevel${suf}.fsf &        
        feat $subjDir/${cc}/run-07/1stLevel${suf}.fsf         
        feat $subjDir/${cc}/run-08/1stLevel${suf}.fsf         

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

#feat $subjDir/${cc}/HighLevel${suf}.fsf 