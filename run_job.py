import subprocess
from glob import glob
import os
import time
import pdb

job_name = 'fsl_job'
mem = 24
run_time = "1-00:00:00"

pause_crit = 10
pause_time = 15

runs=list(range(1,4))
exp = 'spaceloc'
sub_list = list(range(1002,1013)) + list(range(2013,2019))

sub_list = [f'spaceloc{sub}' for sub in sub_list]

tasks = ['spaceloc','toolloc']
study_dir= f'/lab_data/behrmannlab/vlad/{exp}'
ses = 1
suf = ''
#sub_list = list(range(103,108))
'''
exp="ma_mri"
#cond="catmvpa"
cond=["FBOSS_func"]

loc_suf ='_object'
'''
#the sbatch setup info
run_1stlevel = False
run_highlevel =True

preprocess = False



def setup_sbatch(job_name, script_name):
    sbatch_setup = f"""#!/bin/bash -l

# Job name
#SBATCH --job-name={job_name}

#SBATCH --mail-type=ALL
#SBATCH --mail-user=vayzenb@cmu.edu

# Submit job to cpu queue                
#SBATCH -p cpu

#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:0
#SBATCH --exclude=mind-0-15,mind-0-14,mind-0-16
# Job memory request
#SBATCH --mem={mem}gb

# Time limit days-hrs:min:sec
#SBATCH --time {run_time}

# Standard output and error log
#SBATCH --output=slurm_out/{job_name}.out

module load fsl-6.0.3
conda activate fmri_new

{script_name}

"""
    return sbatch_setup

def create_job(job_name, job_cmd):
    print(job_name)
    f = open(f"{job_name}.sh", "a")
    f.writelines(setup_sbatch(job_name, job_cmd))
    f.close()

    subprocess.run(['sbatch', f"{job_name}.sh"],check=True, capture_output=True, text=True)
    os.remove(f"{job_name}.sh")

n = 0 
for sub in sub_list:
    sub_dir = f"{study_dir}/sub-{sub}/ses-0{ses}"
    if preprocess == True:
        job_name = f'{sub}_preprocess'
        

        job_cmd = f'python preprocess.py {exp} {sub}'
        create_job(job_name, job_cmd)
        n+=1
        

    if run_1stlevel == True:
        for task in tasks:
            task_dir = f'{sub_dir}/derivatives/fsl/{task}'
            for run in runs:
                
                job_name = f'{sub}_{task}_{run}'
                job_cmd = f'feat {task_dir}/run-0{run}/1stLevel{suf}.fsf'

                create_job(job_name, job_cmd)
                n += 1

    if run_highlevel == True:
        for task in tasks:
            task_dir = f'{sub_dir}/derivatives/fsl/{task}'
        
            job_name = f'{sub}_{task}_high'
            job_cmd = f'feat {task_dir}/HighLevel{suf}.fsf'

            create_job(job_name, job_cmd)
            n += 1



    if n >= pause_crit:
        #wait X minutes
        time.sleep(pause_time*60)
        n = 0
            



'''
#run first and highlevels
for ss in subj_list:
    sub_dir = f"{study_dir}/MAMRI{ss}"
    

    for cc_num, cc in enumerate(cond):
        func_dir = f'{sub_dir}/{cc}'

        if run_1stlevel == True:
            for rr in runs:
                job_cmd = f'feat {func_dir}/Run0{rr}/1stLevel{loc_suf}.fsf'
                suf = f'{ss}_{rr}'
                f = open(f"{job_name}.sh", "a")
                f.writelines(setup_sbatch(suf))
                f.writelines(job_cmd)
                f.close()

                
                #pdb.set_trace()
                subprocess.run(['sbatch', f"{job_name}.sh"],check=True, capture_output=True, text=True)
                
                os.remove(f"{job_name}.sh")

        if run_highlevel == True:
            job_cmd = f'feat {func_dir}/HighLevel{loc_suf}.fsf'
            suf = f'{ss}'
            f = open(f"{job_name}.sh", "a")
            f.writelines(setup_sbatch(suf))
            f.writelines(job_cmd)
            f.close()

            
            
            subprocess.run(['sbatch', f"{job_name}.sh"],check=True, capture_output=True, text=True)
            
            os.remove(f"{job_name}.sh")

    #break
'''






