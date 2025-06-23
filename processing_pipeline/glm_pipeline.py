# %%
from nilearn import image, plotting
import numpy as np
import pandas as pd
import os
import glmsingle
from glmsingle.glmsingle import GLM_single
import time

# %%
input_directory='/zpool/vladlab/data_drive/fmri_tutorial' # The dataset to process
target_directory='/zpool/vladlab/data_drive/fmri_tutorial/derivatives' # The directory to store the preprocessed data
subject='spaceloc1001' # The subject to process

vols = 321 # Number of volumes in the fMRI data
tr = 1 # Repetition time in seconds
runs = 3 # Number of runs in the fMRI data

#load func file for run-01
func_file = f'{input_directory}/sub-{subject}/ses-01/func/sub-{subject}_ses-01_task-spaceloc_run-01_bold.nii.gz'
func_img = image.load_img(func_file)
stimdur = 20 # Duration of the stimulus in seconds



# %% [markdown]
# ### Convert covariates into TR matched design matrix

# %%
conds = ['SA','FT'] # Conditions of the experiment
design_matrix = []
design_matrix_full = []
# loop through and load the condition files
for run in range(1,runs+1):
    run_design = pd.DataFrame(np.zeros((vols, len(conds))), columns=conds)
    run_design_full = pd.DataFrame(np.zeros((vols, len(conds))), columns =conds)
    for cond in conds:

        cov = pd.read_csv(f'{input_directory}/sub-{subject}/ses-01/func/SpaceLoc_spaceloc1001_Run{run}_{cond}.txt', sep='\t', header=None)
        cov.columns = ['onset', 'duration', 'value']
        # Downsample the covariate to match the TR
        cov['onset'] = (cov['onset'] / tr).astype(int)
        cov['duration'] = (cov['duration'] / tr).astype(int)

        #add a 1 to the design matrix for the onset of each condition
        run_design.loc[cov['onset'], cond] = 1

        #add a 1 to the design matrix for the onset of each condition and the duration
        for onset, duration in zip(cov['onset'], cov['duration']):
            run_design_full.loc[onset:onset+duration, cond] = 1

    #concatenate the design matrix for each run
    design_matrix.append(run_design.values)
    design_matrix_full.append(run_design_full.values)
  
   



# %% [markdown]
# ### Load func images and concatenate them

# %%
img4d = []
for run in range(1, runs + 1):
    img = image.load_img(f'{input_directory}/sub-{subject}/ses-01/func/sub-{subject}_ses-01_task-spaceloc_run-0{run}_bold.nii.gz')
    img4d.append(img.get_fdata())

# Stack the 3D images into a 4D image
#img4d_data = np.stack(img4d, axis=-1)


# %%
opt = dict()

# set important fields for completeness (but these would be enabled by default)
# wantlibrary = 1 -> fit HRF to each voxel 
# wantglmdenoise = 1 -> use GLMdenoise 
# wantfracridge = 1 -> use ridge regression to improve beta estimates 
opt['wantlibrary'] = 1
opt['wantglmdenoise'] = 1
opt['wantfracridge'] = 1

# for the purpose of this example we will keep the relevant outputs in memory
# and also save them to the disk
opt['wantfileoutputs'] = [1,1,1]
opt['wantmemoryoutputs'] = [0,0,0]
glmsingle_obj = GLM_single(opt)

# %%
glmsingle_obj = GLM_single()

# %%
#create directory for the subject output
os.makedirs(f'{target_directory}/sub-{subject}/ses-01/glmsingle/', exist_ok=True)


start_time = time.time()
results_glmsingle = glmsingle_obj.fit(
    design_matrix,
    img4d,
    stimdur,
    tr,
    outputdir=f'{target_directory}/sub-{subject}/ses-01/glmsingle/')

elapsed_time = time.time() - start_time
print(f'GLM_single processing time: {elapsed_time:.2f} seconds')



# %%
#create directory for the subject output
os.makedirs(f'{target_directory}/sub-{subject}/ses-01/glmsingle/design_full', exist_ok=True)


start_time = time.time()
results_glmsingle = glmsingle_obj.fit(
    design_matrix_full.values,
    img4d,
    stimdur,
    tr,
    outputdir=f'{target_directory}/sub-{subject}/ses-01/glmsingle/design_full')

elapsed_time = time.time() - start_time
print(f'GLM_single processing time: {elapsed_time:.2f} seconds')

