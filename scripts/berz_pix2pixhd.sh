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

singularity exec --nv \
    --bind /proj:/proj \
    /proj/agp/containers/pix2pixhd.sif \
    $script \
    --dataroot $dataroot \
    --name $name \
    --label_nc 0 \
    --no_instance \
    ${@:2}

# train on 512: SCRIPT=train_512p.sh DATAROOT=data/neurad_fullnerf2real sbatch berz_pix2pixhd.sh pix2pixhd4nerf512 
# train on 1024: SCRIPT=train_1024p_24G.sh DATAROOT=data/neurad_fullnerf2real sbatch berz_pix2pixhd.sh pix2pixhd4nerf --load_pretrain /checkpoints/pix2pixhd4nerf512/
#
#EOF
