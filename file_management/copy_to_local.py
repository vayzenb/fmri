'''
SCP files to local machine
'''

import subprocess
import os

exp = 'hemispace'
tasks = ['spaceloc', 'toolloc','loc','loc']
conds = ['space', 'tool','word','face']
copes = [1,1,4,1]
ses = 1
runs = [1,2]

study_dir = f'/lab_data/behrmannlab/vlad/{exp}'
out_dir = '/Users/vayze/Documents/Research/Projects/HemiSpace/data/'

subs = ['sub-hemispace1001','sub-hemispace1002','sub-hemispace1003', 'sub-hemispace1004', 'sub-hemispace1006', 'sub-hemispace1007', 'sub-108', 'sub-109']
out_subs = ['KT', 'SI', 'FO','BI','KN','BN','EB','XC']

for sub, out_sub in zip(subs, out_subs):

    os.makedirs(f'{out_dir}/{out_sub}', exist_ok=True)

    #copy anat
    anat_dir = f'{study_dir}/{sub}/ses-{ses:02d}/anat'
    bash_cmd = f'scp -r vayzenbe@mind.cs.cmu.edu:{anat_dir} {out_dir}/{out_sub}/'
    subprocess.run(bash_cmd.split(),check = True)


    #copy rois
    roi_dir = f'{study_dir}/{sub}/ses-{ses:02d}/derivatives/rois'
    bash_cmd = f'scp -r vayzenbe@mind.cs.cmu.edu:{roi_dir} {out_dir}/{out_sub}/'
    subprocess.run(bash_cmd.split(),check = True)


    for task, cond, cope in zip(tasks, conds, copes):
        try:
            print('Copying:', out_sub,  cond)
            os.makedirs(f'{out_dir}/{out_sub}/{cond}', exist_ok=True)

            cond_file = f'{study_dir}/{sub}/ses-{ses:02d}/derivatives/fsl/{task}/HighLevel.gfeat/cope{cope}.feat/stats/zstat1.nii.gz'
            bash_cmd = f'scp -r vayzenbe@mind.cs.cmu.edu:{cond_file} {out_dir}/{out_sub}/{cond}/'
            subprocess.run(bash_cmd.split(),check = True)

            cond_file = f'{study_dir}/{sub}/ses-{ses:02d}/derivatives/fsl/{task}/HighLevel.gfeat/cope{cope}.feat/stats/zstat1_reg.nii.gz'
            bash_cmd = f'scp -r vayzenbe@mind.cs.cmu.edu:{cond_file} {out_dir}/{out_sub}/{cond}/'
            subprocess.run(bash_cmd.split(),check = True)

        except:
            print('Failed:', out_sub,  cond)


