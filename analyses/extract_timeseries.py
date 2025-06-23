import subprocess
import os
from glob import glob

#import pdb

#set up folders and ROIS

subj_list=["2003"]
exp = "docnet"
cond=["cattask"]
suf=""
rois = ["LO_toolloc", 'PFS_toolloc', 'PPC_spaceloc', 'APC_spaceloc']
#rois = ["LO_toolloc"]

exp_dir=f"/lab_data/behrmannlab/vlad/{exp}"

#loop through subs
for ss in subj_list:
    #grab  functional image in each sub dir
    sub_dir = f"{exp_dir}/sub-{exp}{ss}/ses-02/derivatives"
    os.makedirs(f'{sub_dir}/results/timeseries', exist_ok=True)
    out_dir= f'{sub_dir}/results/timeseries'
    
    for cc in cond:
        task_dir = f"{sub_dir}/fsl/{cc}"
        runs = glob(f'{task_dir}/run-0*/')
    
        for rn, rr in enumerate(runs):
            filtered_func = f'{rr}1stLevel{suf}.feat/filtered_func_data.nii.gz'
            print(rr)
            for roi in rois:
                for lr in ["l", "r"]:
                    
                    roi_nifti = f'{rr}/1stLevel{suf}.feat/rois/{lr}{roi}_peak.nii.gz' #set roi
                    print(roi_nifti)
                    if os.path.exists(roi_nifti):
                        bash_cmd = f'fslmeants -i {filtered_func} -o {out_dir}/{cc}_run-0{rn+1}_{lr}{roi}_timecourse.txt -m {roi_nifti}'
                        subprocess.run(bash_cmd.split(), check=True)
                        #bash_out = subprocess.run(bash_cmd.split(),check=True, capture_output=True, text=True)
                        


