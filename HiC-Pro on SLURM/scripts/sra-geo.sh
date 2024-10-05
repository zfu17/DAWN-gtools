#!/bin/bash
#
#SBATCH --job-name=geo2
#SBATCH --error=/dcs07/hongkai/data/zfu17/EO/sra2.err
#SBATCH --output=/dcs07/hongkai/data/zfu17/EO/sra2.out
#SBATCH --time 0-5:00:00 
#SBATCH --mail-user=zfu17@jhu.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=30G
#SBATCH -N 1

# we need to obtain all the SRR files first from GEO using sra-tools (conda package)
module load conda
conda activate sraTools 
cd /dcs07/hongkai/data/zfu17/HiC-Fran/fastq_data

## can always split into multiple jobs for parallel submission
for run in {"SRR7001742","SRR6354567"}; do
    echo "working on $run"
    fasterq-dump $run -S -O ./$run
    echo "finished $run"
done

for run in {"SRR7001734","SRR6354556"}; do
    echo "working on $run"
    fasterq-dump $run -S -O ./$run
    echo "finished $run"
done