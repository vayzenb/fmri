#!/bin/bash

#Create peak voxel mask for PPI


calc(){ awk "BEGIN { print "$*" }"; }

subj_list="2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019"
#subj_list="2000"

roi="lEBA rEBA rFBA"
#roi="lLO rLO lPFS rPFS"


#Specify copes (contrasts) of interest
copeNum=1
run="1 2 3"
#Extract top n voxels in ROI
n=2000
exp=ma_mri

study_dir=/lab_data/behrmannlab/vlad/${exp}

for s in $subj_list
do
	echo $s
	subjDir=$study_dir/MAMRI${s}
	
	roiDir=$subjDir/rois


		for r in $roi
		do
			#Count number of voxels in ROI
			nVox=`fslstats ${roiDir}/parcels/${r}.nii.gz -V`
			nVox=(${nVox[@]})

			#Determine what percentage = n voxels
			topPerc=$(calc $n/$nVox)
			topPerc=$(calc $topPerc*100)
			topPerc=$(calc 100-$topPerc)

			for rn in $run
			do
				runDir=funcDir/Run0$rn
				funcDir=$subjDir/FBOSS_func/Run0${rn}/1stLevel_object.feat

				#find coords of peak vox
				#peakVox=`fslstats ${roiDir}/${r}.nii.gz -x`

				#draw sphere around voxel
				#fslmaths ${roiDir}/${r}.nii.gz -mul 0 -add 1 -roi $peakVox $roiDir/${r}_peakVox.nii.gz

				

				#create nifty with only functional voxels in ROI
				fslmaths $funcDir/stats/zstat${copeNum}_reg.nii.gz -mul $roiDir/parcels/$r.nii.gz $roiDir/${r}_func.nii.gz

				#Find threshold given the top n percentage
				thresh=`fslstats $roiDir/${r}_func.nii.gz -P $topPerc`

				#echo $thresh
				#Create new mask with just the peak voxels
				fslmaths $roiDir/${r}_func.nii.gz -thr $thresh -bin $roiDir/${r}_peak.nii.gz
				
				fslmeants -i $funcDir/stats/zstat${copeNum}_reg.nii.gz -m $roiDir/parcels/${r}.nii.gz -o $roiDir/data/${r}_${rn}_acts.txt --showall --transpose

			done

		#do same for highlevels
		funcDir=$subjDir/FBOSS_func/HighLevel_object.gfeat
		#create nifty with only functional voxels in ROI
		#fslmaths $funcDir/cope${copeNum}/stats/zstat1.nii.gz -mul $roiDir/parcels/$r.nii.gz $roiDir/${r}_func.nii.gz

		#Find threshold given the top n percentage
		#thresh=`fslstats $roiDir/${r}_func.nii.gz -P $topPerc`

		#echo $thresh
		#Create new mask with just the peak voxels
		#fslmaths $roiDir/${r}_func.nii.gz -thr $thresh -bin $roiDir/${r}_peak.nii.gz
		
		#fslmeants -i $funcDir/stats/zstat${copeNum}_reg.nii.gz -m $roiDir/${r}_peak.nii.gz -o $roiDir/data/${r}_high_peak.txt --showall --transpose
		fslmeants -i $funcDir/cope${copeNum}.feat/stats/zstat1.nii.gz -m $roiDir/parcels/${r}.nii.gz -o $roiDir/data/${r}_group_acts.txt --showall --transpose

	done
done
echo "DUNZO!!"