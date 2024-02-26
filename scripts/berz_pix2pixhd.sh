#!/bin/bash
#
#SBATCH --nodes 1
#SBATCH --gpus 1
#SBATCH --time 1-00:00:00
#SBATCH --output /proj/agp/users/%u/logs/%A.out
#SBATCH -A Berzelius-2023-211
#SBATCH --job-name=pix2pixhd
#

name=${1:?"No name given"}
script=${SCRIPT:-train_1024_24G.sh}
dataroot=${DATAROOT:-./data}
batchsize=${BATCHSIZE:-1}
num_gpu=${NUM_GPU:-1}

# calculate learning rate as sqrt(batchsize) * 0.0002
lr=$(echo "sqrt($batchsize) * 0.0002" | bc)

# set lr arg to empty string if test in script name
# else, --lr $lr
lr=${script#*test*} && lr="--lr $lr"

# set batchsize to batchsize * num_gpu
batchsize=$((batchsize * num_gpu))

# create gpu argument, e.g. --gpu_ids 0,1,2,3,4,5,6,7 for 8 gpus
gpu_ids=$(seq -s, 0 $((num_gpu - 1)))
 

singularity exec --nv \
    --bind /proj:/proj \
    /proj/agp/containers/pix2pixhd.sif \
    $script \
    --dataroot $dataroot \
    --name $name \
    --label_nc 0 \
    --no_instance \
    --batchSize $batchsize \
    --gpu_ids $gpu_ids \
    $lr \
    ${@:2}

# train on 512: SCRIPT=train_512p.sh DATAROOT=data/neurad_fullnerf2real sbatch berz_pix2pixhd.sh pix2pixhd4nerf512 
# train on 1024: SCRIPT=train_1024p_24G.sh DATAROOT=data/neurad_fullnerf2real sbatch berz_pix2pixhd.sh pix2pixhd4nerf --load_pretrain /checkpoints/pix2pixhd4nerf512/
# test on 1024: SCRIPT=test_1024p.sh DATAROOT=path/to/realimgs sbatch berz_pix2pixhd.sh <name> --checkpoints_dir /checkpoints/pix2pixhd4nerf512/ 
#
#EOF
