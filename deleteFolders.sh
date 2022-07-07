#!/bin/bash

subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006 spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012" 
subj_list="hemispace1004" 
#subj_list="MAMRI2000 MAMRI2001 MAMRI2002 MAMRI2003 MAMRI2004 MAMRI2005 MAMRI2006 MAMRI2007 MAMRI2008 MAMRI2009 MAMRI2010 MAMRI2011 MAMRI2012 MAMRI2013 MAMRI2014 MAMRI2015 MAMRI2016 MAMRI2017 MAMRI2018 MAMRI2019"
runs="1 2 3"
exp="hemispace"
cond="loc"
#cond="FBOSS_func"


dataDir=/lab_data/behrmannlab/vlad/${exp}

#echo $dataDir
for sub in $subj_list
do
	
	subjDir=$dataDir/sub-${sub}/ses-01/derivatives/fsl
	#subjDir=$dataDir/${sub}/
	#echo $subjDir
    for cc in $cond
    do
		
		#echo $subjDir/${cc}
		for rr in $runs
		do
			#echo $subjDir/${cc}/Run0${rr}/1stLevel_object.feat 
			#rm -rf $subjDir/${cc}/Run0${rr}/1stLevel_object.feat 
			#rm -rf $subjDir/${cc}/Run0${rr}/1stLevel_object+.feat 
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel.feat 
			echo $subjDir/${cc}/run-0${rr}/1stLevel_roi.feat
			echo $subjDir/${cc}/run-0${rr}/1stLevel_roi_stand.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi_stand.feat
			#rm -rf $subjDir/${cc}/run${rr}
			
			
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel++.feat &
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi++.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi+.feat
		done
		#rm -rf $subjDir/${cc}/HighLevel_object.gfeat 
		rm -rf $subjDir/${cc}/HighLevel+.gfeat
		#rm -rf $subjDir/${cc}/HighLevel+.gfeat &
		rm -rf $subjDir/${cc}/HighLevel_roi.gfeat
		rm -rf $subjDir/${cc}/HighLevel_roi+.gfeat
		rm -rf $subjDir/${cc}/HighLevel_roi_stand.gfeat
		rm -rf $subjDir/${cc}/HighLevel_roi_stand+.gfeat
		#rm -rf $subjDir/${cc}/HighLevel++.gfeat &
		#rm -rf $subjDir/${cc}/HighLevel_roi++.gfeat
		#rm -rf $subjDir/${cc}/HighLevel_roi_2runs.gfeat
		#rm -rf $subjDir/${cc}/HighLevel_odd.gfeat
		#rm -rf $subjDir/${cc}/HighLevel_even.gfeat
	done
done


