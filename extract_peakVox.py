import subprocess
import os
from glob import glob
import pdb

#percentage thresh
per = 90
num_vox = 100

subj_list=["spaceloc1001", "spaceloc1002", "spaceloc1003", "spaceloc1004", "spaceloc1005", "spaceloc1006", "spaceloc1007",
"spaceloc1008" ,"spaceloc1009", "spaceloc1010", "spaceloc1011" ,"spaceloc1012" ]

subj_list=["spaceloc2013", "spaceloc2014", "spaceloc2015", "spaceloc2016"]

exp="spaceloc"
cond=["spaceloc", "depthloc", "distloc", "toolloc"]
#cond=["toolloc"]
loc_suf="_roi"

#Rois
roi=["PPC", "APC"]
#roi=["LO", "PFS"]

#Specify copes (contrasts) of interest
cope_num=[[1, 1, 1, 2, 2, 2], [1, 1, 1, 2, 2, 2], [1, 1, 1, 2, 2, 2], [1,1,1,5,5,5]]
cope_num=[[1, 1], [1, 1], [1, 1], [1,1]]
#cope_num=[[5, 5]]

exp_dir=f"/lab_data/behrmannlab/vlad/{exp}"

for ss in subj_list:
    print(ss)
    sub_dir = f"{exp_dir}/sub-{ss}/ses-01/derivatives"
    roi_dir = f'{sub_dir}/rois'

    os.makedirs(f'{roi_dir}/data', exist_ok=True)

    for cc_num, cc in enumerate(cond):
        func_dir = f'{sub_dir}/fsl/{cc}/HighLevel{loc_suf}.gfeat'

        for rr in range(0,len(roi)):
            
            for lr in ["l", "r"]:
                
                
                roi_nifti = f'{roi_dir}/{lr}{roi[rr]}_{cc}' #set roi
                cope_dir = f'{func_dir}/cope{cope_num[cc_num][rr]}.feat' #set cope

                if os.path.exists(roi_nifti + ".nii.gz"):
                    

                    #Extract func data from cope within roi mask
                    bash_cmd = f'fslmaths {cope_dir}/stats/zstat1.nii.gz -mul {roi_nifti}.nii.gz {roi_nifti}_peak.nii.gz'
                    subprocess.run(bash_cmd.split(), check=True)

                    bash_cmd = f'fslmaths {roi_nifti}_peak.nii.gz -thrP {per} -bin {roi_nifti}_peak.nii.gz'
                    subprocess.run(bash_cmd.split(), check=True)
                    







