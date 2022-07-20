import subprocess
import os
import pdb

remote_dir = f'/lab_data/behrmannlab/vlad/hemispace'
local_dir = f'C:/Users/vayze/Documents/Research/Projects/HemiSpace/data'

subs = ['hemispace1001','hemispace1002','hemispace1003', 'hemispace1004',
        'hemispace1005','hemispace1006','hemispace1007',
        'hemispace2001','hemispace2002','hemispace2003']

tasks = ['loc','spaceloc','toolloc']
copes =[[1,4, 10,12],[1,2,4,5],[1,2,3,4,6,7,8]]
conds = [['face','word','face-scramble','word-scramble'],
['space','feature','space-fix','feature-fix'],
['tool','non-tool','tool-scramble','non-tool-scramble','tool-fix','non-tool-fix', 'scramble-fix']]


for sub in subs:
    os.makedirs(f'{local_dir}/{sub}', exist_ok=True)
    sub_dir = f'{remote_dir}/sub-{sub}/ses-01'
    
    #copy anat
    bash_cmd = f'scp -r vayzenbe@mind.cs.cmu.edu:{sub_dir}/anat/sub-{sub}_ses-01_T1w_brain.nii.gz {local_dir}/{sub}/'
    subprocess.run(bash_cmd.split(),check = True)

    for task in enumerate(tasks):
        for cope in enumerate(copes[task[0]]):
            
            #copy func
            bash_cmd = f'scp -r vayzenbe@mind.cs.cmu.edu:{sub_dir}/derivatives/fsl/{task[1]}/HighLevel_roi.gfeat/cope{cope[1]}.feat/stats/zstat1.nii.gz {local_dir}/{sub}/{sub}_{task[1]}_{conds[task[0]][cope[0]]}.nii.gz'
            
            
            subprocess.run(bash_cmd.split(),check = True)
    

