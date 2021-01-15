import subprocess
import os

subj_list=["docnet1001"]
exp="docnet"
cond="spaceloc"
suff=["_all", "_odd", "_even"]

#Rois
roi=["V3ab", "PPC", "APC", "V4", "LO", "PFS"]

#Specify copes (contrasts) of interest
cope_num=[1, 1, 1, 2, 2, 2]

#Extract top 1-n % voxels in ROI
n=90

exp_dir=f"/lab_data/behrmannlab/vlad/{exp}"

for ss in subj_list:
    sub_dir = f"{exp_dir}/sub-{ss}/ses-01/derivatives"
    roi_dir = f'{sub_dir}/rois'

    os.makedirs(f'{roi_dir}/data', exist_ok=True)

    for sf in suff:
        func_dir = f'{sub_dir}/fsl/{cond}/HighLevel{sf}_smooth.gfeat'

        for rr in range(0,len(roi)):
            for lr in ["l", "r"]:
                #Maybe check if ROI and data exist before creating it
                print(ss, lr, rr, sf)

                #define ROI directory
                roi_nifti = f'{roi_dir}/{lr}{roi[rr]}{sf}.nii.gz'
                cope_dir = f'{func_dir}/cope{cope_num[rr]}.feat'
                #print(cope_dir)

                #Extract ROI by multiplying the cluster-correct mask by broad anatomical parcel
                bash_cmd = f'fslmaths {cope_dir}/cluster_mask_zstat1.nii.gz -mul {roi_dir}/parcels/{lr}{roi[rr]}.nii.gz -bin {roi_nifti}'
                subprocess.run(bash_cmd.split(), check=True)

                #check if the mask is empty, delete if it is
                bash_cmd = f'fslstats {roi_nifti} -V'
                vox_num = subprocess.run(bash_cmd.split(),check=True, capture_output=True, text=True) #this subprocess captures the output

                if vox_num.stdout[0] == "0":
                    os.remove(f'{roi_dir}/{lr}{roi[rr]}{sf}.nii.gz')
                    
                else: #else save functional data from mask
                    roi_data = f'{roi_dir}/data/{lr}{roi[rr]}{sf}'

                    bash_cmd = f'fslmeants -i {cope_dir}/stats/zstat1.nii.gz -m {roi_nifti} -o {roi_data}.txt --showall --transpose'
                    subprocess.run(bash_cmd.split(), check=True)






    