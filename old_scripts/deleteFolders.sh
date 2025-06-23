#!/bin/bash

subj_list="sub-hemispace1001 sub-hemispace1002 sub-hemispace1003 sub-hemispace1004 sub-hemispace1006 sub-hemispace1007 sub-108 sub-109 sub-hemispace2001 sub-hemispace2002 sub-hemispace2003 sub-103 sub-106 sub-107 sub-025 sub-038 sub-057 sub-059 sub-064 sub-067 sub-068 sub-071 sub-083 sub-084 sub-085 sub-087 sub-088 sub-093 sub-094 sub-095 sub-096 sub-097 sub-104 sub-105 sub-spaceloc1001 sub-spaceloc1002 sub-spaceloc1003 sub-spaceloc1004 sub-spaceloc1005 sub-spaceloc1006 sub-spaceloc1007 sub-spaceloc1008 sub-spaceloc1009 sub-spaceloc1010 sub-spaceloc1011 sub-spaceloc1012 sub-spaceloc2013 sub-spaceloc2014 sub-spaceloc2015 sub-spaceloc2016 sub-spaceloc2017 sub-spaceloc2018" 
subj_list="sub-hemispace1001 sub-hemispace1002 sub-hemispace1003 sub-hemispace1004 sub-hemispace1006 sub-hemispace1007 sub-108 sub-109 sub-hemispace2002 sub-hemispace2003 sub-103 sub-106 sub-107 sub-025 sub-038 sub-057 sub-059 sub-064 sub-067 sub-068 sub-071 sub-083 sub-084 sub-085 sub-087 sub-088 sub-093 sub-094 sub-095 sub-096 sub-097 sub-104 sub-105 sub-spaceloc1001 sub-spaceloc1002 sub-spaceloc1003 sub-spaceloc1004 sub-spaceloc1005 sub-spaceloc1006 sub-spaceloc1007 sub-spaceloc1008 sub-spaceloc1009 sub-spaceloc1010 sub-spaceloc1011 sub-spaceloc1012 sub-spaceloc2013 sub-spaceloc2014 sub-spaceloc2015 sub-spaceloc2016 sub-spaceloc2017 sub-spaceloc2018" 
subj_list="sub-057 sub-068 sub-095 sub-104 sub-105 sub-spaceloc1005 sub-spaceloc1006 sub-spaceloc1011 sub-spaceloc1012 sub-spaceloc2017 sub-spaceloc2018" 
#subj_list="MAMRI2000 MAMRI2001 MAMRI2002 MAMRI2003 MAMRI2004 MAMRI2005 MAMRI2006 MAMRI2007 MAMRI2008 MAMRI2009 MAMRI2010 MAMRI2011 MAMRI2012 MAMRI2013 MAMRI2014 MAMRI2015 MAMRI2016 MAMRI2017 MAMRI2018 MAMRI2019"
runs="1 2 3"
exp="hemispace"
cond="loc spaceloc toolloc"
#cond="toolloc"


dataDir=/lab_data/behrmannlab/vlad/${exp}

#echo $dataDir
for sub in $subj_list
do
	echo $sub
	subjDir=$dataDir/${sub}/ses-01/derivatives/fsl

	#rm -rf $subjDir/rois/*.nii.gz
	#rm -rf $subjDir/rois/spheres/*.nii.gz
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
			echo $subjDir/${cc}/run-0${rr}/1stLevel+.feat
			#echo $subjDir/${cc}/run-0${rr}/1stLevel_roi_stand.feat
			rm -rf $subjDir/fsl/${cc}/run-0${rr}/1stLevel+.feat
			#echo $subjDir/${cc}/run-0${rr}/1stLevel_roi.feat
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi+.feat
			rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi++.feat
			#rm -rf $subjDir/${cc}/run${rr}
			
			
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel++.feat &
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi++.feat
			#rm -rf $subjDir/${cc}/run-0${rr}/1stLevel_roi+.feat
		done
		echo $subjDir/${cc}/HighLevel_roi.gfeat 
		rm -rf $subjDir/${cc}/HighLevel_roi.gfeat 
		rm -rf $subjDir/${cc}/HighLevel_roi+.gfeat 
		#rm -rf $subjDir/fsl/${cc}/HighLevel_roi_stand.gfeat 
		#rm -rf $subjDir/${cc}/HighLevel+.gfeat
		#rm -rf $subjDir/${cc}/HighLevel++.gfeat 
		#rm -rf $subjDir/${cc}/HighLevel+++.gfeat 
	done
done


