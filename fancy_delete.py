import os
import shutil
import subprocess
from glob import glob as glob
import re
import pdb

study_dir = '/lab_data/behrmannlab/vlad/spaceloc'

sub_list = list(range(1001,1013)) + list(range(2013,2019))
#sub_list= [1001]

folders = ['func','derivatives/']

criteria = [['depthloc','distloc','run-04','run-05','run-06'],'']


for sub in sub_list:
    print(sub)
    #globa each folder in folders
    for folder in folders:
        #glob each file in folder
        #if it meets criteria delete it
        if len(criteria[folders.index(folder)]) == 0:
            shutil.rmtree(f'{study_dir}/sub-spaceloc{sub}/ses-01/{folder}', ignore_errors=True)
            #print(f'{study_dir}/sub-spaceloc{sub}/ses-01/{folder}')
        else:
            for file in glob(f'{study_dir}/sub-spaceloc{sub}/ses-01/{folder}/*'):
                #if string contains any of the criteria
                if any(crit in file for crit in criteria[folders.index(folder)]):
                    #delete it
                    os.remove(file)
                    #print(file)


