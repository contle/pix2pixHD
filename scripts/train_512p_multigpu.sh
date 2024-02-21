#!/bin/sh
######## Multi-GPU training example #######
pix2pixhd-train --batchSize 8 --gpu_ids 0,1,2,3,4,5,6,7
