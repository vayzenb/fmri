import os
import shutil
import subprocess
from multiprocessing import Pool

pool_object = Pool()
exp = 'spaceloc'
sub_list = list(range(1001,1013)) + list(range(2013,2019))
tasks = ['spaceloc','toolloc']

ses = 1
runs = [1,2,3]

study_dir = f'/lab_data/behrmannlab/vlad/{exp}'

def calc_motion_outliers(task, run):
    #make directory for run if it doesnt exist
    os.makedirs(f'{sub_dir}/derivatives/fsl/{task}/run-0{run}', exist_ok=True)

    #calcualte motion outliers
    bash_cmd = f'fsl_motion_outliers -i {sub_dir}/func/sub-{exp}{sub}_ses-{ses:02d}_task-{task}_run-0{run}_bold.nii.gz -o {sub_dir}/derivatives/fsl/{task}/run-0{run}/sub-{exp}{sub}_ses-{ses:02d}_task-{task}_run-0{run}_bold_spikes.txt --dummy=0'
    

for sub in sub_list:
    print(sub)
    #instatiate sub dir
    sub_dir = f'{study_dir}/sub-{exp}{sub}/ses-{ses:02d}'
    #make derivatives folder
    os.makedirs(f'{sub_dir}/derivatives', exist_ok=True)
    #make fsl folder
    os.makedirs(f'{sub_dir}/derivatives/fsl', exist_ok=True)
    #make covs folder
    os.makedirs(f'{sub_dir}/derivatives/covs', exist_ok=True)

    #check if deskulled brain exists, else make it
    if not os.path.exists(f'{sub_dir}/anat/sub-{exp}{sub}_ses-{ses:02d}_T1w_brain.nii.gz'):
        #deskull brain
        bash_cmd = f'bet {sub_dir}/anat/sub-{exp}{sub}_ses-{ses:02d}_T1w.nii.gz {sub_dir}/anat/sub-{exp}{sub}_ses-{ses:02d}_T1w_brain.nii.gz -R -B'
        subprocess.run(bash_cmd.split(),check = True)
    
    for task in tasks:
        #make task folder
        os.makedirs(f'{sub_dir}/derivatives/fsl/{task}', exist_ok=True)

        #calc motion outliers in parallel
        pool_object.map(calc_motion_outliers, [task]*len(runs), runs)



