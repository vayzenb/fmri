#!/bin/bash

subj_list="docnet1001 docnet1002" #03 04 05 06 07 08 09 10 11 12 13 14 15 16"
runs="1 2 3 4 5 6"
exp="docnet"
cond="spaceloc adaptation"
cond="spaceloc"


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
			#echo $subjDir/${cc}/run-0${rr}/1stLevel.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel.feat
		done
	done
done


