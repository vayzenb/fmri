#!/bin/bash

#Create peak voxel mask for PPI


calc(){ awk "BEGIN { print "$*" }"; }

subj_list="1007 1008 1009"

roi="lLO rLO"

#Specify copes (contrasts) of interest
copeNum="2"
#Extract top n voxels in ROI
n=60

dir="/Volumes/Zeus/DOC"

for s in $subj_list
do
	subjDir="$dir/DOC${s}"
	funcDir="$subjDir/DOTS_func/HighLevel.gfeat"
	roiDir="$subjDir/ROIs"

	for r in $roi
	do

		#find coords of peak vox
		#peakVox=`fslstats ${roiDir}/${r}.nii.gz -x`

		#draw sphere around voxel
		#fslmaths ${roiDir}/${r}.nii.gz -mul 0 -add 1 -roi $peakVox $roiDir/${r}_peakVox.nii.gz

		#draw 50 vox sphere around peak vox


		#Count number of voxels in ROI
		nVox=`fslstats ${roiDir}/${r}.nii.gz -V`
		nVox=(${nVox[@]})

		#Determine what percentage = n voxels
		topPerc=$(calc $n/$nVox)
		topPerc=$(calc $topPerc*100)
		topPerc=$(calc 100-$topPerc)

		#create nifty with only functional voxels in ROI
		fslmaths $funcDir/cope${copeNum}.feat/stats/zstat1.nii.gz -mul $roiDir/$r.nii.gz $roiDir/${r}_func.nii.gz

		#Find threshold given the top n percentage
		thresh=`fslstats $roiDir/${r}_func.nii.gz -P $topPerc`

		echo $thresh
		#Create new mask with just the peak voxels
		fslmaths $roiDir/${r}_func.nii.gz -thr $thresh -bin $roiDir/${r}_peak.nii.gz

	done
done
echo "DUNZO!!"