# Conda environment and package installation
In this tutorial, we will go through the following:
1. Creating a conda environment
3. Activating it and deactivating it
4. Installing a package in an environment
___
## Creating a conda environment
There are multiple reasons we might want to create a conda environment, and among them, one of the most important reason is to avoid package conflicts. Imagine a scenario where you want to install software A and B, but each requiring different versions of Python. This will introduce version incompatibility when installing them simultaneously. One solution is to create two different environments and install A and B separately. It is much like creating two folders to avoid version conflict. 
Creating a conda environment is applicable to both the cluster and personal computer setting. Since both cases are highly similar, we will go through them at the same time, and I will point out the minor differences along the way. 
1. You need either conda or mamba. These are both amazing package management tools, but I personally found mamba a lot smarter in managing package compatibility and resolving conflicts. You may use `conda info` or `mamba info` to check the pre-existing installation. On personal computers, you can install either by following instruction on [Mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html) or [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html). If you are working with a cluster (most likely managed by your school), load the corresponding module. You need to know what's the module names. On FASRC (one of Harvard's main clusters), `module load Mambaforge`. See more details [here](https://docs.rc.fas.harvard.edu/kb/python-package-installation). Oh, also don't forget to **log in to a computing node** before you module load anything. 
2. Let's create an environment. You will need a name, at least, to start. Sometimes you have a designated package to install in this environment, then you can put its name after the environment name. Most of the time, `conda` and `mamba` can be used interchangeably. For convenience, we will stick with the `conda` command in the later instructions.
```bat
## for mamba user
mamba create -n <ENV_NAME> <PACKAGES>
## for conda user
conda create -n <ENV_NAME> <PACKAGES>
```

## Activating and deactivating the environment
After you created the environment, you need to activate it. It is much like you need to get into the folder to see what has been put there. You need to activate it before you can use the packages installed there. Simply use `conda activate <ENV_NAME>`.  To check whether you have successfully activated the environment, you should see in your terminal that the `ENV_NAME` appears in the environment prefix. Let's look at the below example:
```bat
## before I activate the environment MOFA
(base) ziqi_fu@Ziqis-MacBook-Pro-4 ~ %
## after I activate the environment
(MOFA) ziqi_fu@Ziqis-MacBook-Pro-4 ~ %
```
Sometimes, we might forget how we exactly named our environments. Use `conda env list` to list all the created environments. The current activated environment should have a `*` sign in front. 
In practice, you want to either want to run something in the activated environment (let's say a Python script or a software you installed) or edit the environment (let's say you want to update or install a software).
### Continue to install softwares
This is simple. Have the package name ready. You can Google it and find the installation command on https://anaconda.org. Most of the time, `mamba install <PACKAGE>` will work. 
### Running installed softwares 
On personal computers, you can enter the commands you wish to run. On cluster, especially if you need write a bash script and submit it as a job, you can put the below commands right before your software commands:
```bash
module load Mambaforge # load mamba or conda
mamba activate <ENV_NAME> # activate the environment

# <YOUR SOFTWARE COMMANDS BEGIN HERE>
```
### Deactivating it
Sometimes you need to change the environment. Let's say you write a pipeline that uses two softwares, and they are installed in two different environments due to package incompatibility. To switch from an active environment to another, simple run the following commands:
```bat
mamba deactivate # this will get you back to the (base) environment
mamba activate <ENV_NAME2> # activate the 2nd environment
```

## Deleting an environment
Let's say you want to remove an environment you no longer use. Proceed with caution:
```
conda remove -n ENV_NAME --all
```
