#!/bin/sh

#  Copies firstLevel from one run to the others
#  
#
#  Created by VA + JK on 8/13/19.
#


subj_list="2003"
runs=("1" "2" "3" "4")
ogSub="2003"
exp="docnet"
cond="catmvpa"
#cond="toolloc"
suf=""
#subj_list="1001 1002"
#runs=("1" "2")


dataDir=/lab_data/behrmannlab/vlad/${exp}

###############################
ogDir=$dataDir/sub-${exp}${ogSub}/ses-02/derivatives/fsl
for sub in $subj_list
do
	
	subjDir=$dataDir/sub-${exp}${sub}/ses-02/derivatives/fsl

#cd $subjDir

	for cc in $cond; do
		runDir=$subjDir/${cc}
		ogRun=$ogDir/${cc}

		echo $runDir
		echo $ogDir
		for r in "${runs[@]}";
		do

			echo ${ogRun}/run-01/1stLevel${suf}.fsf
			cp ${ogRun}/run-01/1stLevel${suf}.fsf $runDir/run-0${r}/1stLevel${suf}.fsf #copies fsf from run 1 into the other runs (cp = copy)

			sed -i "s/${ogSub}/${sub}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change subject
			sed -i "s/run-01/run-0${r}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change run for file and output
			sed -i "s/run1/run${r}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change run for file and output
			sed -i "s/Run1/Run${r}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change run for covs

		done

		#cp ${ogRun}/HighLevel${suf}.fsf $runDir/HighLevel${suf}.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel${suf}.fsf

		#cp ${ogRun}/HighLevel.fsf $runDir/HighLevel.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel.fsf

		#cp ${ogRun}/HighLevel_roi.fsf $runDir/HighLevel_roi.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_roi.fsf

		#cp ${ogRun}/HighLevel_roi_2runs.fsf $runDir/HighLevel_roi_2runs.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_roi_2runs.fsf

	#rm $runDir/HighLevel_roi_2run.fsf 
	#rm $runDir/HighLevel_roi_run.fsf 
	#cp ${ogRun}/HighLevel_6Runs.fsf $runDir/HighLevel_6Runs.fsf #copies fsf from run 1 into the other runs (cp = copy)
	#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_6Runs.fsf

	echo $s
	done
done

echo 'Dunzo!!!'