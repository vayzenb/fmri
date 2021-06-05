import subprocess
import os
from glob import glob
import pdb


subj_list=["2003"]
exp = "docnet"
cond=["cattask"]
runs=[1, 2, 3, 4, 5, 6]
suf=""
rois = ["LO_toolloc", 'PFS_toolloc', 'PPC_spaceloc', 'APC_spaceloc']
#rois = ["LO_toolloc"]

exp_dir=f"/lab_data/behrmannlab/vlad/{exp}"


for ss in subj_list:
    print(ss)
    sub_dir = f"{exp_dir}/sub-{exp}{ss}/ses-02/derivatives"
    roi_dir = f'{sub_dir}/rois'
    for cc in cond:
        task_dir = f"{sub_dir}/fsl/{cc}"

        for rr in runs:
            
            new_roi = f'{task_dir}/run-0{rr}/1stLevel{suf}.feat/rois'
            os.makedirs(new_roi,exist_ok= True)
            
            reg = f'{task_dir}/run-0{rr}/1stLevel{suf}.feat/reg'
            
            for roi in rois:
                for lr in ["l", "r"]:
                
                    roi_nifti = f'{roi_dir}/{lr}{roi}_peak.nii.gz' #set roi

                    if os.path.exists(roi_nifti):
                        bash_cmd = f'flirt -in {roi_nifti} -ref {reg}/example_func.nii.gz -out {new_roi}/{lr}{roi}_peak.nii.gz -applyxfm -init {reg}/standard2example_func.mat -interp trilinear'
                        subprocess.run(bash_cmd.split(), check=True)



        
