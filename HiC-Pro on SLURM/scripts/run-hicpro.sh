#!/bin/bash
#
#SBATCH --job-name=run-hic-pro
#SBATCH --error=/dcs07/hongkai/data/zfu17/EO/hicpro.err
#SBATCH --output=/dcs07/hongkai/data/zfu17/EO/hicpro.out
#SBATCH --time 0-24:00:00 
#SBATCH --mail-user=zfu17@jhu.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=80G
#SBATCH -N 1

module load conda
conda activate HiC-Pro_v3.1.0

HiC-Pro -i /dcs07/hongkai/data/zfu17/HiC-Fran/fastq_data \
        -o /dcs07/hongkai/data/zfu17/HiC-Fran/proc_data \
        -c /dcs07/hongkai/data/zfu17/HiC-Fran/scripts/config-hicpro_ecoli.txt \
        # -s build_contact_maps -s ice_norm