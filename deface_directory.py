
import glob
import os
import pdb
from fnmatch import fnmatch
import subprocess

study = 'docnet'
sub_list = list(range(2001,2019))
data_dir = f'/lab_data/behrmannlab/vlad/{study}/'
sesh = 2
file_list = []
for ss in sub_list:
  anat_file = f'{data_dir}/sub-{study}{ss}/ses-0{sesh}/anat/sub-spaceloc{ss}_ses-01_T1w.nii.gz'
  
  if os.path.exists(anat_file):
    bash_cmd = f'pydeface {anat_file} --outfile {anat_file} --force'
    subprocess.run(bash_cmd.split(), check=True)
    print(anat_file)

  else:
    print('no anat file for', ss)

  

'''
for path, subdirs, files in os.walk(data_dir):
  for name in files:
    if fnmatch(name, '*_T1w.nii.gz'):
      file_list.append(os.path.join(path, name))
      bash_cmd = f'pydeface {name} --outfile {name} --force'
      subprocess.run(bash_cmd.split(), check=True)
      print(name)
'''



