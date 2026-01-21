# %%
from nilearn import image, plotting
import numpy as np
import pandas as pd
import os
import glmsingle
from glmsingle.glmsingle import GLM_single
import time
import pdb
import subprocess

#set the number of threads for OpenBLAS to 8
# This is necessary to avoid memory issues when running the GLM_single
#bash_cmd = 'export OPENBLAS_NUM_THREADS=8'
#subprocess.run(bash_cmd, shell=True)
# %%
input_directory='/zpool/vladlab/data_drive/fmri_tutorial/derivatives' # The dataset to process
target_directory='/zpool/vladlab/data_drive/fmri_tutorial/derivatives' # The directory to store the preprocessed data
subject='spaceloc1001' # The subject to process

brain_mask = image.load_img(f'{input_directory}/sub-{subject}/ses-01/func/sub-spaceloc1001_ses-01_task-spaceloc_run-01_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz')
brain_mask_data = brain_mask.get_fdata()

vols = 321 # Number of volumes in the fMRI data
tr = 1 # Repetition time in seconds
runs = 4 # Number of runs in the fMRI data
runs2use = [2,4,6]

suf = '_even'

#load func file for run-01

stimdur = 20 # Duration of the stimulus in seconds


output_directory = f'{target_directory}/sub-{subject}/ses-01/glmsingle/highlevel{suf}'
print(f'Output directory: {output_directory}')

# Create the output directory if it doesn't exist
os.makedirs(output_directory, exist_ok=True)

# %% [markdown]
# ### Convert covariates into TR matched design matrix

# %%
conds = ['SA','FT'] # Conditions of the experiment

def create_covs():
    design_matrix = []
    design_matrix_full = []
    # loop through and load the condition files
    for run in runs2use:
        run_design = pd.DataFrame(np.zeros((vols, len(conds))), columns=conds)
        run_design_full = pd.DataFrame(np.zeros((vols, len(conds))), columns =conds)
        for cond in conds:

            cov = pd.read_csv(f'{input_directory}/sub-{subject}/ses-01/covs/SpaceLoc_spaceloc1001_Run{run}_{cond}.txt', sep='\t', header=None)
            cov.columns = ['onset', 'duration', 'value']
            # Downsample the covariate to match the TR
            cov['onset'] = (cov['onset'] / tr).astype(int)
            cov['duration'] = (cov['duration'] / tr).astype(int)

            #add a 1 to the design matrix for the onset of each condition
            run_design.loc[cov['onset'], cond] = 1

            #add a 1 to the design matrix for the onset of each condition and the duration
            #for onset, duration in zip(cov['onset'], cov['duration']):
            #    run_design_full.loc[onset:onset+(duration)-1, cond] = 1

        #concatenate the design matrix for each run
        design_matrix.append(run_design.values)
        #design_matrix_full.append(run_design_full.values)
    
    

    nblocks = int(np.sum(np.concatenate(design_matrix)))
    print('Total number of trials', nblocks)

# %% [markdown]
# ### Load func images and concatenate them

    def run_glm():
    # %%
    img4d = []
    for run in runs2use:
        img = image.load_img(f'{input_directory}/sub-{subject}/ses-01/func/sub-{subject}_ses-01_task-spaceloc_run-0{run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz')
        
        img4d.append(img.get_fdata())

    # Stack the 3D images into a 4D image
    #img4d_data = np.stack(img4d, axis=-1)
    #print(f'img4d_data shape: {img4d.shape}')

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
        outputdir=f'{output_directory}',
        figuredir=f'{output_directory}/figures')
    elapsed_time = time.time() - start_time
    print(f'GLM_single processing time: {elapsed_time:.2f} seconds')

# %% [markdown]
def compute_contrasts(results,file_name):
    '''
    Load the results and compute contrasts
    '''

    design_info = np.load(f'{output_directory}/DESIGNINFO.npy', allow_pickle=True).item()
    results = np.load(f'{output_directory}/TYPED_FITHRF_GLMDENOISE_RR.npy', allow_pickle=True).item()
    results_onoff = np.load(f'{output_directory}/TYPEA_ONOFF.npy', allow_pickle=True).item()
    #results_full = np.load(f'{output_directory}/glmsingle/design_full/TYPED_FITHRF_GLMDENOISE_RR.npy', allow_pickle=True).item()


    #stack design matrix
    full_design = np.vstack(design_matrix)
    #using design_df, extract each 1 value in order and list its scondition 
    conditions = []
    condition_index = []
    #loop through each row of the design_df
    for i in range(len(full_design)):
        #check if the row is all zeros
        if np.all(full_design[i,:] == 0):
            # if so, skip this row
            continue
        #get the columns where the value is 1
        cols = np.where(full_design[i,:] == 1)[0]
        #get the condition name from the first column
        condition = conds[cols[0]]
        #append the condition to the list
        conditions.append(condition)
        #append the index of the condition to the list
        condition_index.append(i)

    # Create a list of indices for each condition
    cond_inds = []
    for i in range(0,len(conds)):
        cond_inds.append([kk for kk, condition in enumerate(conditions) if condition in conds[i]])




    '''
    Compute contrats using a t-test between the two conditions
    '''
    all_betas = results['betasmd']

    #extract betas from SA and FT conditions
    sa_betas = all_betas[:,:,:,cond_inds[0]]
    ft_betas = all_betas[:,:,:,cond_inds[1]]

    #mask out using the brain mask
    sa_betas = sa_betas * brain_mask_data[..., np.newaxis]
    ft_betas = ft_betas * brain_mask_data[..., np.newaxis]


    #convert nans to zeros
    #sa_betas = np.nan_to_num(sa_betas)
    #ft_betas = np.nan_to_num(ft_betas)
    #

    #do a t-test between the numpy arrays 
    from scipy import stats
    t_stat, p_value = stats.ttest_ind(sa_betas, ft_betas, axis=3)

    #convert to a z-score
    z_map = stats.norm.ppf(1 - p_value / 2)  # two-tailed test

    # Save the z_map as a Nifti image
    z_map_img = image.new_img_like(brain_mask, z_map)
    t_map_img = image.new_img_like(brain_mask, t_stat)

    #smooth both maps
    z_map_img = image.smooth_img(z_map_img, fwhm=6)
    t_map_img = image.smooth_img(t_map_img, fwhm=6)


    #save z and t maps
    z_map_img.to_filename(f'{output_directory}/z_map.nii.gz')
    t_map_img.to_filename(f'{output_directory}/t_map.nii.gz')