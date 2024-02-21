import argparse
import shutil
from pathlib import Path
import os

import concurrent.futures

def copy_file(src, dst):
    shutil.copy(src, dst)


def main(args):
    input_path = Path(args.input_path)
    output_path = Path(args.output_path)
    nuscenes_path = Path(args.nuscenes_path)
    os.makedirs(output_path, exist_ok=True)
    os.makedirs(output_path / "train_A", exist_ok=True)
    os.makedirs(output_path / "train_B", exist_ok=True)
    all_image_files = input_path.glob(f'**/*{args.file_extension}')
    all_nuscenes_image_files = list(nuscenes_path.glob(f'**/*{args.file_extension}'))
    all_nuscenes_image_filenames = [file.name for file in all_nuscenes_image_files]

    results = []
    with concurrent.futures.ThreadPoolExecutor(16) as executor:
        for i, img_file in enumerate(all_image_files):
            nuscenes_idx = all_nuscenes_image_filenames.index(img_file.name)
            nuscenes_eqiv = all_nuscenes_image_files[nuscenes_idx]
            
            res = executor.submit(copy_file, (img_file, output_path / "train_B" / img_file.name))
            results.append(res)
            res = executor.submit(copy_file, (nuscenes_eqiv, output_path / "train_A" / img_file.name))
            results.append(res)
            # shutil.copy(img_file, output_path / "train_A" / img_file.name)
            # shutil.copy(nuscenes_eqiv, output_path / "train_B" / img_file.name)
        for j in range(i):
            if j % 50 == 0:
                print(j)

    
                            
def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-path", type=str, help="Path to where images are stored in any folder structure")
    parser.add_argument("--nuscenes-path", type=str, default="/proj/adas-data/data/nuscenes", help="Root dir to nuscenes, where to search for same image")
    parser.add_argument("--file-extension", type=str, default=".jpg", help="File extension for image files")
    parser.add_argument("--output-path", type=str, help="Path to where images should be copied")
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = parse_args()
    main(args)

# example usage
# python scripts/create_dataset.py --input-path /proj/agp/renders/real2sim/fullnuscenes_clear_fullres_samples-split/ --output-path /proj/agp/renders/real2sim/pix2pixhd_data/nusc_samples-split