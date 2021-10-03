import subprocess
from glob import glob
import os
import time
import pdb

job_name = 'fsl_job'
mem = 8
run_time = "1-00:00:00"

runs=list(range(1,4))
subj_list = list(range(2000,2020))
exp="ma_mri"
#cond="catmvpa"
cond=["FBOSS_func"]
study_dir= f'/lab_data/behrmannlab/vlad/{exp}'
loc_suf ='_object'
#the sbatch setup info
run_1stlevel = False
run_highlevel =True


def setup_sbatch(suf):
    sbatch_setup = f"""#!/bin/bash -l

# Job name
#SBATCH --job-name={job_name}_{suf}

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
#SBATCH --output=slurm_out/{job_name}_{suf}.out

module load fsl-6.0.3

"""
    return sbatch_setup



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







