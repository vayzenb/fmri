#!/bin/sh

# Runs Activation feats, a few at a time for multiple subjects
#  
#
# Created by VA on 2.23.20


subj_list="1002" #03 04 05 06 07 08 09 10 11 12 13 14 15 16"
runs="1 2 3 4 5 6 7 8"
exp="DOC"
cond="d30p0b0 d60p0b0 d90p0b0 d0p30b1 d0p150b2 d0p180b2"
roi="lLO"

dataDir=/Volumes/Zeus/DOC

for s in $subj_list
do

subjDir=$dataDir/${exp}${s}/${exp}_func


feat $subjDir/Run1/1stLevel_Activation.fsf 
feat $subjDir/Run2/1stLevel_Activation.fsf 
feat $subjDir/Run3/1stLevel_Activation.fsf &
feat $subjDir/Run4/1stLevel_Activation.fsf
feat $subjDir/Run5/1stLevel_Activation.fsf &
feat $subjDir/Run6/1stLevel_Activation.fsf &
feat $subjDir/Run7/1stLevel_Activation.fsf 
feat $subjDir/Run8/1stLevel_Activation.fsf



feat $subjDir/HighLevel_Activation.fsf
echo "Done ${s}"
done


