
subj_list="1000 1001 1002 1003 1004 1005 1006 1007 1008 1009"

roi=("lIPL" "rIPL" "lSPL" "rSPL")

mni="/Volumes/Zeus/DOC/MNI152_T1_2mm_brain.nii.gz"

#Voxel coordinates
#note these were drawn by pulling MNI coords and figuring out where the would be in FSL space

x=(65 26 54 31)
y=(44 42 31 32)
z=(59 58 62 62)

dir="/Volumes/Zeus/DOC"
parcelDir="$dir/Parcels"

n=50

for r in 0 1 2 3
do
	#Select point in MNI space
	fslmaths $mni -mul 0 -add 1 -roi ${x[${r}]} 1 ${y[${r}]} 1 ${z[${r}]} 1 0 1 $parcelDir/${roi[${r}]}.nii.gz -odt float

	#Create sphere around that point
	fslmaths $parcelDir/${roi[${r}]}.nii.gz -kernel sphere 5 -fmean $parcelDir/${roi[${r}]}.nii.gz -odt float


	#Binarize the sphere
	fslmaths $parcelDir/${roi[${r}]}.nii.gz -bin $parcelDir/${roi[${r}]}.nii.gz

	echo ${roi[${r}]}

	for sub in $subj_list
	do
	cp $parcelDir/${roi[${r}]}.nii.gz $dir/DOC${sub}/ROIs/${roi[${r}]}.nii.gz


	done

done




