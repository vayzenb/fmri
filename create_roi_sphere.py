import numpy as np
import pandas as pd
import subprocess
import os
import pdb

subj_list=["spaceloc1001","spaceloc1002","spaceloc1003","spaceloc1004","spaceloc1005", "spaceloc1006",
"spaceloc1007","spaceloc1008","spaceloc1009","spaceloc1010", "spaceloc1011","spaceloc1012"]
subj_list=["spaceloc2013","spaceloc2014","spaceloc2015","spaceloc2016"]
#subj_list=["spaceloc1004","spaceloc1005"]

exp='spaceloc'
exp_dir=f"/lab_data/behrmannlab/vlad/{exp}"

rois=["PPC", "APC", "LO", "PFS"]
cond=["spaceloc", "depthloc", "distloc","toolloc"]
mni='/opt/fsl/6.0.3/data/standard/MNI152_T1_2mm_brain.nii.gz'
#mni='$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz' 

rad =6 #size in mm

for ss in subj_list:
    print(ss)
    sub_dir = f"{exp_dir}/sub-{ss}/ses-01/derivatives"
    
    roi_dir = f'{sub_dir}/rois'
    os.makedirs(f'{roi_dir}/spheres', exist_ok=True)

    for cc_num, cc in enumerate(cond):
        
        for rr in rois:
            
            for lr in ["l", "r"]:
                roi = f'{lr}{rr}_{cc}'
                
                if os.path.exists(f'{roi_dir}/{roi}.nii.gz'):
                    loc_df = pd.read_csv(f'{roi_dir}/data/{roi}.txt',sep="  ", header=None, names = ["x", "y", "z", "loc"], engine = 'python')
                    loc_df = loc_df.sort_values(by =['loc'], ascending=False)

                    x,y,z = loc_df.iloc[0,0],loc_df.iloc[0,1],loc_df.iloc[0,2]
                    
                    #Select point in MNI space
                    bash_cmd = f'fslmaths {mni} -mul 0 -add 1 -roi {x} 1 {y} 1 {z} 1 0 1 {roi_dir}/spheres/{roi}_sphere.nii.gz -odt float'
                    subprocess.run(bash_cmd.split(), check=True)

                    #Create sphere around that point
                    bash_cmd = f'fslmaths {roi_dir}/spheres/{roi}_sphere.nii.gz -kernel sphere {rad} -fmean {roi_dir}/spheres/{roi}_sphere.nii.gz -odt float'
                    subprocess.run(bash_cmd.split(), check=True)


                    #Binarize the sphere
                    bash_cmd = f'fslmaths {roi_dir}/spheres/{roi}_sphere.nii.gz -bin {roi_dir}/spheres/{roi}_sphere.nii.gz'
                    subprocess.run(bash_cmd.split(), check=True)











