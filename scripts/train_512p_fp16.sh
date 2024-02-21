#!/bin/sh
### Using labels only
python -m torch.distributed.launch pix2pixhd/train.py --fp16
