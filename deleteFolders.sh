#!/bin/bash

subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006 spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012" 
#subj_list="spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012" 
runs="1 2 3 4 5 6"
exp="spaceloc"
cond="spaceloc depthloc distloc toolloc"
cond="depthloc"


dataDir=/lab_data/behrmannlab/vlad/${exp}

#echo $dataDir
for sub in $subj_list
do
	
	subjDir=$dataDir/sub-${sub}/ses-01/derivatives/fsl
	#echo $subjDir
    for cc in $cond
    do
		
		#echo $subjDir/${cc}
		for rr in $runs
		do
			echo $subjDir/${cc}/run-0${rr}/1stLevel.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel.feat 
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi.feat
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel++.feat &
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi++.feat
		done
		rm -rf $subjDir/${cc}/HighLevel.gfeat 
		#rm -rf $subjDir/${cc}/HighLevel_roi.gfeat
		rm -rf $subjDir/${cc}/HighLevel+.gfeat &
		rm -rf $subjDir/${cc}/HighLevel_roi+.gfeat
		rm -rf $subjDir/${cc}/HighLevel++.gfeat &
		rm -rf $subjDir/${cc}/HighLevel_roi++.gfeat
		#rm -rf $subjDir/${cc}/HighLevel_roi_2runs.gfeat
		#rm -rf $subjDir/${cc}/HighLevel_odd.gfeat
		#rm -rf $subjDir/${cc}/HighLevel_even.gfeat
	done
done


