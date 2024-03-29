#!/bin/bash
#register 1stlevels to anatomical
module load fsl-6.0.3


subj_list="1001 1002 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012"
subj_list="2001 2002 2003 2004 2005 2007 2008 2012 2013 2014 2015 2016"
subj_list="spaceloc1001 spaceloc1002 spaceloc1003 spaceloc1004 spaceloc1005 spaceloc1006\
    spaceloc1007 spaceloc1008 spaceloc1009 spaceloc1010 spaceloc1011 spaceloc1012\
	 spaceloc2013 spaceloc2014 spaceloc2015 spaceloc2016 spaceloc2017 spaceloc2018"

run="1 2 3 4 5 6 7 8"
#run="7 8"
exp=bwoc
#exp=spaceloc
cond="spaceloc toolloc distloc depthloc"
#cond="FBOSS_func"
cond="toolloc"
suf=""
stat="5"



dir=/lab_data/behrmannlab/vlad/${exp}

#mniBrain=$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz #this is the parcel for both julian and mruczek
anat=$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz #all subs were registered to a 2mm brain

for s in $subj_list
do
	echo ${s}
	subjDir=${dir}/sub-${s}/ses-01/derivatives/fsl
	#subjDir=${dir}/MAMRI${s}
	anat=${dir}/sub-${s}/ses-01/anat/sub-${s}_ses-01_T1w_brain.nii.gz
	
	#Create registration matrix from localizer anat to exp anatomy
	#flirt -in $locDir/anat/DOC${s}_anatomy_brain.nii.gz -ref $expDir/anat/DOC${s}_anatomy_brain.nii.gz -omat $expDir/anat/loc2expFunc.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12	

	for cc in $cond
	do
		loc_dir=${subjDir}/${cc}

		for r in $run
		do
			run_dir=${loc_dir}/run-0${r}/1stLevel${suf}.feat
			#run_dir=${loc_dir}/Run0${r}/1stLevel${suf}.feat
            flirt -in $run_dir/filtered_func_data.nii.gz -ref $anat -out $run_dir/filtered_func_data_reg.nii.gz -applyxfm -init $run_dir/reg/example_func2standard.mat -interp trilinear
			for zz in $stat
			do
			

			#Register 1stLevel to exp anat
			#flirt -in $run_dir/stats/zstat${zz}.nii.gz -ref $anat -out $run_dir/stats/zstat${zz}_reg.nii.gz -applyxfm -init $run_dir/reg/example_func2standard.mat -interp trilinear
            continue
            #Register filtered_func 
            
			done
		done
	done
done

echo "Dunzo!!!"