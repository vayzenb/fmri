# -*- coding: utf-8 -*-
"""
Created on Mon Nov  2 10:41:21 2020

@author: vayze
"""
import flywheel


dataDir  = 'C:/Users/vayze/Documents/Research/Projects/DocNet/fmri_data' #directory to download to

fwGroup = 'mbehrmannlab' #group name
fwProj = 'DocNet' #project name
subj = ['20.10.27-16:04:04-DST-1.3.12.2.1107.5.2.43.166114'] #subject name

fwID = 'bridge-center.flywheel.io:IIJ0hyuXDKKJx1lyLh' #personal flywheel id

fw = flywheel.Client(fwID) #Create flywheel client

project = fw.lookup(f'{fwGroup}/{fwProj}') #get current project info

session = fw.lookup(f'{fwGroup}/{fwProj}/{subj[0]}/ses-01') #get current subject info for session 1

project.download_tar(f'{dataDir}/test-project.tar', include_types=['nifti'])  

session = subject.sessions()

fw.download_tar(session,f'{dataDir}/DocNet_test.tar', include_types=['nifti'])


with flywheel.GearContext() as context:
   # Setup basic logging
   context.init_logging()

   # Log the configuration for this job
   #context.log_config()
   
   session = fw.lookup(f'{fwGroup}/{fwProj}/{subj[0]}/ses-01') #get current subject info for session 1
   bids_path = context.download_session_bids(target_dir=dataDir,folders=['anat', 'func'])


    


for subject in project.subjects():
        print('%s: %s' % (subject.id, subject.label))