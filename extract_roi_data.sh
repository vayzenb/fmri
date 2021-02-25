#!/bin/bash
module load fsl-6.0.3

subj_list="docnet1001" #subs to analyze
exp="spaceloc"
suf="_odd _even _all" #runs to pull ROIs from
roi=("V3ab" "PPC" "APC" "LO" "PFS")    #Rois
loc_cope=("1" "1" "1" "2" "2" "2")
exp_cope=("8" "9" "10" "11")
#suf="_even" #runs to pull ROIs from

data_dir=/lab_data/behrmannlab/vlad/docnet

for ss in $subj_list
do
    subj_dir=$data_dir/sub-${ss}/ses-01/derivatives
	results_dir=$subj_dir/beta/selectivity

    #mkdir $subjDir/beta
    rm -rf $results_dir
    mkdir $results_dir

    for sf_loc in $suf; do  #loop across run type for the masks
        for rr in 0 1; do #loop across rois
            for lr in "l" "r"; do #loop across left and right hemis
                roi_nifti=$subj_dir/rois/${lr}${roi[${rr}]}${sf_loc}.nii.gz #set ROI
                
                #check if ROI exists
                if test -f "$roi_nifti"; then
                    echo ${sf_loc}

                    if [[ "$sf_loc" = "_all" ]] 
                    then
                        loc_suf=${sf_loc}
                        
                    else
                        loc_suf=${sf_loc}_smooth
                        
                    fi
                    #echo $loc_suf


                    cope_nifti=$subj_dir/fsl/$exp/HighLevel${loc_suf}.gfeat/cope${loc_cope[${rr}]}.feat/stats/zstat1.nii.gz
                    out=$results_dir/${lr}${roi[${rr}]}${sf_loc}_localizer.txt
                    echo $cope_nifti
                    echo $out

                    fslmeants -i $cope_nifti -m $roi_nifti -o $out --showall --transpose


                fi
            done
        done
    done
done

