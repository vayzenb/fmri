#!/bin/sh

#  Copies firstLevel from one run to the others
#  
#
#  Created by VA + JK on 8/13/19.
#


#subj_list="1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 2013 2014 2015 2016 2017 2018"
subj_list="025 038 057 059 064 067 068 071 083 084 085 087 088 093 094 095 096 097 103 104 105 106 107 hemispace1001 hemispace1002 hemispace1003 hemispace2001 hemispace2002 hemispace2003"
subj_list="108 109"
runs=("1" "2" "3" "4" "5" "6" "7" "8")
runs=("1" "2" "3")
ogSub="hemispace2001"
exp="hemispace"
#exp="docnet"
#cond="spaceloc depthloc distloc toolloc"
cond="spaceloc toolloc loc"
suf=""
sesh="01"


dataDir=/lab_data/behrmannlab/vlad/${exp}

###############################
ogDir=$dataDir/sub-${ogSub}/ses-${sesh}/derivatives/fsl
for sub in $subj_list
do
	
	subjDir=$dataDir/sub-${sub}/ses-${sesh}/derivatives/fsl

#cd $subjDir

	for cc in $cond; do
		runDir=$subjDir/${cc}
		ogRun=$ogDir/${cc}

		
		echo ${ogRun}/run-01/1stLevel${suf}.fsf
		for r in "${runs[@]}";
		do

			
			cp ${ogRun}/run-01/1stLevel${suf}.fsf $runDir/run-0${r}/1stLevel${suf}.fsf #copies fsf from run 1 into the other runs (cp = copy)

			sed -i "s/${ogSub}/${sub}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change subject
			sed -i "s/run-01/run-0${r}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change run for file and output
			sed -i "s/run1/run${r}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change run for file and output
			sed -i "s/Run1/Run${r}/g" $runDir/run-0${r}/1stLevel${suf}.fsf #change run for covs

			#copy catloc files
			
			continue

		done

		cp ${ogRun}/HighLevel${suf}.fsf $runDir/HighLevel${suf}.fsf #copies fsf from run 1 into the other runs (cp = copy)
		sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel${suf}.fsf

		#cp ${ogRun}/HighLevel_odd.fsf $runDir/HighLevel_odd.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_odd.fsf

		#cp ${ogRun}/HighLevel_even.fsf $runDir/HighLevel_even.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_even.fsf

		#cp ${ogRun}/HighLevel_roi_2runs.fsf $runDir/HighLevel_roi_2runs.fsf #copies fsf from run 1 into the other runs (cp = copy)
		#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_roi_2runs.fsf

	#rm $runDir/HighLevel_roi_2run.fsf 
	#rm $runDir/HighLevel_roi_run.fsf 
	#cp ${ogRun}/HighLevel_6Runs.fsf $runDir/HighLevel_6Runs.fsf #copies fsf from run 1 into the other runs (cp = copy)
	#sed -i "s/${ogSub}/${sub}/g" $runDir/HighLevel_6Runs.fsf

	echo $s
	done
done

echo "Dunzo!!!"