#!/bin/sh

#  Copies firstLevel from one run to the others
#  
#
#  Created by VA + JK on 8/13/19.
#


subj_list="1002"
runs=("1" "2" "3" "4" "5" "6" "7" "8")
cbls=("1" "2" "3" "4" "5" "6" "7" "8")  #will also use these for the fun file numbers
ogCBL="9"
ogSub="1006"
ogType="Novel" 
exp="DOC"
#objType=("Familiar" "Novel" "Familiar" "Novel" "Familiar" "Novel" "Familiar" "Novel")
objType=("Novel" "Familiar" "Novel" "Familiar" "Novel" "Familiar" "Novel" "Familiar" )
#suffix="1stLevel_Activation" ${suffix}

dataDir=/Volumes/Zeus/DOC

###############################

for s in $subj_list
do

subjDir=$dataDir/${exp}${s}/${exp}_func
cd $subjDir

for r in 0 1 2 3 4 5 6 7 8   
do

cp $dataDir/DOC${ogSub}/${exp}_func/Run1/1stLevel_Activation.fsf $subjDir/Run${runs[${r}]}/1stLevel_Activation.fsf #copies fsf from run 1 into the other runs (cp = copy)

#sed -i '' "s/run1/run${runs[${r}]}/g" $subjDir/Run${runs[${r}]}/1stLevel_Activation.fsf
sed -i '' "s/${ogSub}/${s}/g" $subjDir/Run${r}/1stLevel_Activation.fsf #change subject
sed -i '' "s/Run1/Run${runs[${r}]}/g" $subjDir/Run${runs[${r}]}/1stLevel_Activation.fsf
sed -i '' "s/CBL${ogCBL}/CBL${cbls[${r}]}/g" $subjDir/Run${runs[${r}]}/1stLevel_Activation.fsf
sed -i '' "s/${ogType}/${objType[${r}]}/g" $subjDir/Run${runs[${r}]}/1stLevel_Activation.fsf

done

cp $dataDir/DOC${ogSub}/${exp}_func/HighLevel_Activation.fsf $subjDir/HighLevel_Activation.fsf #copies fsf from run 1 into the other runs (cp = copy)

sed -i '' "s/${ogSub}/${s}/g" $subjDir/HighLevel_Activation.fsf

echo $s
done

echo 'Dunzo!!!'