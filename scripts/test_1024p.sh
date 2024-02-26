#!/bin/bash
################################ Testing ################################
# labels only
pix2pixhd-test --netG local --ngf 32 --resize_or_crop none "$@"
