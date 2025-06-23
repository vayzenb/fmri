# %%
import numpy as np
import pandas as pd
import scipy
import scipy.stats as stats
import scipy.io as sio
import matplotlib.pyplot as plt
import nibabel as nib

import os
from os.path import join, exists, split
import sys
import time
import urllib.request
import copy
import warnings
from tqdm import tqdm
from pprint import pprint
warnings.filterwarnings('ignore')

import glmsingle
from glmsingle.glmsingle import GLM_single

# note: the fracridge repository is also necessary to run this code
# for example, you could do:
#      git clone https://github.com/nrdg/fracridge.git

datadir = '/zpool/vladlab/data_drive/fmri_tutorial/glmsingle_data'
outputdir = '/zpool/vladlab/data_drive/fmri_tutorial/glmsingle_output'
# get path to the directory to which GLMsingle was installed
os.makedirs(datadir,exist_ok=True)
os.makedirs(outputdir,exist_ok=True)

print(f'directory to save example dataset:\n\t{datadir}\n')
print(f'directory to save example2 outputs:\n\t{outputdir}\n')

# %%
# download example dataset from GLMsingle OSF repository
# data comes from subject1, floc session from NSD dataset.
# https://www.biorxiv.org/content/10.1101/2021.02.22.432340v1.full.pdf

datafn = join(datadir,'nsdflocexampledataset.mat')

# to save time, we'll skip the download if the example dataset already exists on disk
if not exists(datafn):
    
    print(f'Downloading example dataset and saving to:\n{datafn}')
    
    dataurl = 'https://osf.io/g42tm/download'
    
    # download the .mat file to the specified directory
    urllib.request.urlretrieve(dataurl, datafn)
    
# load struct containing example dataset
X = sio.loadmat(datafn)

# %%
# variables that will contain bold time-series and design matrices from each run
data = []
design = []

nruns = len(X['data'][0])

# iterate through each run of data
#This creates a design file with each row corresponding to a TR of data
for r in range(nruns):
    
    # index into struct, append each run's timeseries data to list
    data.append(X['data'][0,r])
    
    # convert each run design matrix from sparse array to full numpy array, append
    design.append(scipy.sparse.csr_matrix.toarray(X['design'][0,r]))
    
# get shape of data volume (XYZ) for convenience
xyz = data[0].shape[:3]
xyzt = data[0].shape

# get total number of blocks - this will be the dimensionality of output betas from GLMsingle
nblocks = int(np.sum(np.concatenate(design)))

# get metadata about stimulus duration and TR
stimdur = X['stimdur'][0][0]
tr = X['tr'][0][0]

# %%
design[0].shape

# %%
data[0].shape

# %%
#convert design[0] to a pandas DataFrame
# this will be useful for plotting later
design_df = pd.DataFrame(design[0], columns=['cond1', 'cond2', 'cond3', 'cond4', 'cond5', 'cond6', 'cond7', 'cond8', 'cond9', 'cond10'])

# %%
V1_roi = X['visual'].item()[0] == 1   # for V1
FFA_roi = X['floc'].item()[0] == 2    # for FFA-1

'''
# plot example slices from runs 1 and 2
plt.figure(figsize=(20,6))
plt.subplot(121)
plt.imshow(data[0][:,:,20,0])
plt.title('example slice from run 1',fontsize=16)
plt.subplot(122)
plt.imshow(data[1][:,:,20,0])
plt.title('example slice from run 2',fontsize=16)

# plot example design matrix from run 1
plt.figure(figsize=(10,10))
plt.imshow(design[0],aspect='auto',interpolation='none')
plt.title('example design matrix from run 1',fontsize=16)
plt.xlabel('conditions',fontsize=16)
plt.ylabel('time (TR)',fontsize=16);
'''
# %%
# print some relevant metadata
print(f'Data has {len(data)} runs\n')
print(f'There are {nblocks} total blocks in runs 1-4\n')
print(f'Shape of data from each run is: {data[0].shape}\n')
print(f'XYZ dimensionality is: {data[0].shape[:3]} (one slice only)\n')
print(f'N = {data[0].shape[3]} TRs per run\n')
print(f'Numeric precision of data is: {type(data[0][0,0,0,0])}\n')
print(f'There are {np.sum(FFA_roi)} voxels in the included FFA ROI\n')
print(f'There are {np.sum(V1_roi)} voxels in the included V1 ROI')

# %%
# create a directory for saving GLMsingle outputs
outputdir_glmsingle = join(outputdir,'examples','example2outputs','GLMsingle')
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
opt['wantfileoutputs'] = [1,1,1,1]
#opt['wantmemoryoutputs'] = [1,1,1,1]

# running python GLMsingle involves creating a GLM_single object
# and then running the procedure using the .fit() routine
glmsingle_obj = GLM_single(opt)

# visualize all the hyperparameters
pprint(glmsingle_obj.params)

# %%

start_time = time.time()
results_glmsingle = glmsingle_obj.fit(
    design,
    data,
    stimdur,
    tr,
    outputdir=outputdir_glmsingle)

elapsed_time = time.time() - start_time

print(
    '\telapsed time: ',
    f'{time.strftime("%H:%M:%S", time.gmtime(elapsed_time))}')

# %%
# this example saves output files to the folder  "example2outputs/GLMsingle"
# if these outputs don't already exist, we will perform the time-consuming call to GLMsingle;
# otherwise, we will just load from disk.

start_time = time.time()

if not exists(outputdir_glmsingle):

    print(f'running GLMsingle...')
    
    # run GLMsingle
    results_glmsingle = glmsingle_obj.fit(
       design,
       data,
       stimdur,
       tr,
       outputdir=outputdir_glmsingle)
    
    # we assign outputs of GLMsingle to the "results_glmsingle" variable.
    # note that results_glmsingle['typea'] contains GLM estimates from an ONOFF model,
    # where all images are treated as the same condition. these estimates
    # could be potentially used to find cortical areas that respond to
    # visual stimuli. we want to compare beta weights between conditions
    # therefore we are not going to include the ONOFF betas in any analyses of 
    # voxel reliability
    
else:
    print(f'loading existing GLMsingle outputs from directory:\n\t{outputdir_glmsingle}')
    
    # load existing file outputs if they exist
    results_glmsingle = dict()
    results_glmsingle['typea'] = np.load(join(outputdir_glmsingle,'TYPEA_ONOFF.npy'),allow_pickle=True).item()
    results_glmsingle['typeb'] = np.load(join(outputdir_glmsingle,'TYPEB_FITHRF.npy'),allow_pickle=True).item()
    results_glmsingle['typec'] = np.load(join(outputdir_glmsingle,'TYPEC_FITHRF_GLMDENOISE.npy'),allow_pickle=True).item()
    results_glmsingle['typed'] = np.load(join(outputdir_glmsingle,'TYPED_FITHRF_GLMDENOISE_RR.npy'),allow_pickle=True).item()

elapsed_time = time.time() - start_time

print(
    '\telapsed time: ',
    f'{time.strftime("%H:%M:%S", time.gmtime(elapsed_time))}')


