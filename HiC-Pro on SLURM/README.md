## Introduction to the package
We refer to this amazing software https://github.com/nservant/HiC-Pro that processes Hi-C data from raw fastq files to count matrices. The current version is 3.X.
## Installation
I found the easiest way to run Hi-C-Pro on cluster (even locally) is to 
1. Create a conda environment and activate it
2. Install Hi-C pro using conda
Activate the environment each time you need to run the software. This way is convenient as it avoids potential package conflicts with other softwares. 
## Configuration file
The command for running Hi-C-Pro is extremely elegant, however, this comes at the cost of having a correctly written configuration file, whose template is available [here](https://github.com/nservant/HiC-Pro/blob/master/config-hicpro.txt). In this file, you will need to specify the following things:
1. The naming scheme of your paired fastq files `PAIR1_EXT` and `PAIR2_EXT`. For example, if I have sampleName_1.fastq and sampleName_2.fastq, then `PAIR1_EXT = _1`.
2. Location to your bowtie2 index path. You must build a bowtie2 index prior to using Hi-C pro. Put it here: `BOWTIE2_IDX_PATH = /dcl01/hongkai1/data/zfu17/Ecoli_bowtie2_index`. You can also specify other bowtie2 alignment parameters as needed, but optional.
3. The name of your bowtie2 index comes after `REFERENCE_GENOME`. It is the *prefix* of all the index files. If you are not sure, `cd` into the directory you put in #2 and look at the prefix. This name was previously specified when the index was created. 
4. The location to the genome fragment file follows after `GENOME_FRAGMENT`. This is a `.bed` file you need to build using a known `LIGATION_SITE`. There is a python script [bin/utils/digest_genome.py](https://github.com/nservant/HiC-Pro/blob/master/bin/utils/digest_genome.py) you can use. Check their [UTILS.md](https://github.com/nservant/HiC-Pro/blob/master/doc/UTILS.md) for further information. To find the ligation site, you can go to https://www.neb.com/en-us. For example, [HpaII](https://www.neb.com/en-us/products/r0171-hpaii) has ligation site CCGCGG.
5. What resolutions do you need? How big or small should the count matrices be? You can specify multiple bin size in the `BIN_SIZE` argument. For example, `BIN_SIZE = 5000 7500 8000 10000 20000 50000`. The maximum resolution is always specified in the data publishing article. You can always go lower (by increasing the binning size) but not higher. 

I will later write another README for constructing bowtie2 index.
## The actual command
See the example command below:
```
HiC-Pro -i PATH_TO_MY_DATA \
		-o PATH_TO_OUTPUT \
		-c PATH_TO_configuration.txt
```
- `-i`: the PARENT directory of the fastq files. This is tricky. In this directory, the fastq files *must* be organized in a specific way. The sub-directories are the sample names (which will be used for the output as well), and each of them contains the actual fastq files of the same prefix. In practice, it is easy to mistakenly put the directory that actually contains the fastq files as the input, especially if you only process one sample. 
```
   + PATH_TO_MY_DATA
     + sample1
       ++ file1_1.fastq.gz
       ++ file1_2.fastq.gz
       ++ ...
     + sample2
       ++ file1_1.fastq.gz
       ++ file1_2.fastq.gz
     *...
```
- `-o`:  where do you want your output to be? This will be the PARENT directory of all your processed sample sub-directories. 
## Understanding the output files
All the result files are stored `PATH_TO_OUTPUT/hic_results`. In general, there are two important things we care about:
1. How good/bad is an experiment? Which replicate is better? 
	Check the number of all valid pairs in `/hic_results/stats/[sampleName]/[sampleName].allValidPairs.mergestat`. A good experiment captures a large number of interacting pairs of genomic loci. This can also be used to pick a better replicate to put in the main result.
2. Where are the count matrices?
	You will see two directories under `hic_results/matrix/[sampleName]`: `/iced` and `/raw`. They both store count matrices. The `iced` directory stores the count matrices after [ICE normalization](https://www.nature.com/articles/nmeth.2148). This is a popular method for Hi-C data trying to correct for loci-specific bias. The big idea is that the corrected matrices assume all genomic loci have an equal probability of getting captured. The `/raw` directory keeps the uncorrected count matrices. Raw here means un-normalized counts, not the raw sequencing data. Inside these directories, matrices are organized in directories named with bin sizes. 
## Step-wise usage
HiC-Pro has a stepwise function that allows you to re-analyze the data without the need to remap all fragments. `/hic_results/data` contains `[sampleName].allValidPairs` that can be reused later if you need to e.g. aggregate the experiments or construct matrices of different resolutions. This `/data` directory can be put as `-i` with other stepwise options in the command like `-s build_contact_maps -s ice_norm`.
## project related scripts in ./scripts
- `sra-geo.sh`: download the fastq files from GEO using sra-toolkits
- `config-hicpro_ecoli.txt`: the config file used on JHPCE
-  `run-hicpro.sh`: SLURM script submitted