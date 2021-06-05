import pandas as pd
import numpy as np 
import pdb
object_cats = ['boat', 'camera', 'car', 'lamp', 'guitar']
cov_dir = "/lab_data/behrmannlab/vlad/docnet//sub-docnet2003/ses-02/covs"

for rr in range(1,4):
    cov_file = f'{cov_dir}/CatIdent_mvpa_docnet2003_Run_{rr}_fix.txt'
    curr_cov = np.loadtxt(cov_file, dtype='str')
    del_cov = np.delete(curr_cov,0,1)
    #print(curr)
    new_file = cov_file.replace('CatIdent_mvpa', 'catmvpa')
    new_file = new_file.replace(f'Run_{rr}', f'run{rr}')
    np.savetxt(new_file, del_cov,fmt ='%s', delimiter ='\t')
    for oc in object_cats:
        for obn in range(1,6):
            cov_file = f'{cov_dir}/CatIdent_mvpa_docnet2003_Run_{rr}_{oc}_{obn}.txt'
            curr_cov = np.loadtxt(cov_file, dtype='str')
            del_cov = np.delete(curr_cov,0,1)
            #print(curr)
            new_file = cov_file.replace('CatIdent_mvpa', 'catmvpa')
            new_file = new_file.replace(f'Run_{rr}', f'run{rr}')
            np.savetxt(new_file, del_cov,fmt ='%s', delimiter ='\t')



