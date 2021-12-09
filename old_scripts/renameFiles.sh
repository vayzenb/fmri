#!/bin/bash

sub="1002 1003"
run="1 2 3 4 5 6 7 8 9 10"

for i in $sub;
do

for j in $run
do

#rename 1stLevel_filtered to 1stLevel_Activation
#mv /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_filtered.fsf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_Activation.fsf 

#rename 1stLevel_Run to 1stLevel_PPI_Depth_lLO
#mv /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_Run.fsf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_PPI_Depth_lLO.fsf 

#Delete OG 1stLevel 
rm -rf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel.fsf /Volumes/Zeus/DOC/DOC1000/DOC_func
	done

done





