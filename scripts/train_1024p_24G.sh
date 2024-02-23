#!/bin/sh
############## To train images at 2048 x 1024 resolution after training 1024 x 512 resolution models #############
######## Using GPUs with 24G memory
# Using labels only
pix2pixhd-train --netG local --ngf 32 --num_D 3 --niter 50 --niter_decay 50 --niter_fix_global 10 --resize_or_crop none "$@"
