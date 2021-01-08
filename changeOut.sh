#!/bin/sh

#  Copies firstLevel from one run to the others
#  
#
#  Created by VA + JK on 8/13/19.
#


subj_list="1002"
runs=("1" "2" "3" "4" "5" "6")
ogSub="1001"
exp="docnet"
cond="spaceloc adaptation"
#suffix="1stLevel_Activation" ${suffix}

dataDir=/lab_data/behrmannlab/vlad/${exp}

###############################
ogDir=$dataDir/sub-${exp}${ogSub}/ses-01/derivatives/fsl
for sub in $subj_list
do

subjDir=$dataDir/sub-${exp}${sub}/ses-01/derivatives/fsl

#cd $subjDir

	for cc in $cond; do
		runDir=$subjDir/${cc}
		ogRun=$ogDir/${cc}

		echo $runDir
		echo $ogDir
		for r in "${runs[@]}";
		do


			cp ${ogRun}/run-01/1stLevel.fsf $runDir/run-0${r}/1stLevel.fsf #copies fsf from run 1 into the other runs (cp = copy)

			sed -i "s/${ogSub}/${sub}/g" $runDir/run-0${r}/1stLevel.fsf #change subject
			sed -i "s/run-01/run-0${r}/g" $runDir/run-0${r}/1stLevel.fsf #change run for file and output
			sed -i "s/Run1/Run${r}/g" $runDir/run-0${r}/1stLevel.fsf #change run for covs

		done

	cp ${ogRun}/HighLevel_4Runs.fsf $runDir/HighLevel_4Runs.fsf #copies fsf from run 1 into the other runs (cp = copy)
	sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_4Runs.fsf
	
	cp ${ogRun}/HighLevel_6Runs.fsf $runDir/HighLevel_6Runs.fsf #copies fsf from run 1 into the other runs (cp = copy)
	sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_6Runs.fsf

	echo $s
	done
done

echo 'Dunzo!!!'