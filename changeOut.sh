#!/bin/sh

#  Copies firstLevel from one run to the others
#  
#
#  Created by VA + JK on 8/13/19.
#


subj_list="docnet1001"
runs=("1" "2" "3" "4" "5" "6")
ogSub="docnet1001"
exp="docnet"
cond="spaceloc adaptation"
#suffix="1stLevel_Activation" ${suffix}

dataDir=/lab_data/behrmannlab/vlad/${exp}

###############################
ogDir=$dataDir/sub-${ogSub}/ses-01/derivatives/fsl
for sub in $subj_list
do

subjDir=$dataDir/sub-${sub}/ses-01/derivatives/fsl

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

	#cp $dataDir/DOC${ogSub}/${exp}_func/HighLevel_Activation.fsf $subjDir/HighLevel_Activation.fsf #copies fsf from run 1 into the other runs (cp = copy)
	#sed -i '' "s/${ogSub}/${s}/g" $subjDir/HighLevel_Activation.fsf

	echo $s
	done
done

echo 'Dunzo!!!'