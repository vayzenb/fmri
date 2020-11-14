#!/bin/bash

sub="1002 1003"
run="1 2 3 4 5 6 7 8"

for i in $sub;
do

#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOC_func/HighLevel_Activation.gfeat
rm -rf /Volumes/Zeus/DOC/DOC${i}/DOTS_func/*.gfeat
#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOTS_func/*.fsf

for j in $run
do
#echo "nothing"
#rm -rf /Volumes/Zeus/DOC/DOC${i}/ROIs
rm -rf /Volumes/Zeus/DOC/DOC${i}/DOTS_func/Run${j}/*.feat
#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOTS_func/Run${j}/*.fsf
#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_d30p0b0_PPI.feat
#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_d60p0b0_PPI.feat
#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run${j}/1stLevel_d90p0b0_PPI.feat
#rm -rf /Volumes/Zeus/DOC/DOC${i}/DOC_func/Run0${j}/1stLevel_allPam.feat
#mv /Volumes/Zeus/MA-MRI/MAMRI${i}/MAMRI_func/Run0${j}/MAMRI${i}_MAMRI_Run_0${j}_spikes.txt /Volumes/Zeus/MA-MRI/MAMRI${i}/MAMRI_func/Run0${j}/MAMRI${i}_MAMRI_Run0${j}_spikes.txt


	done

done

