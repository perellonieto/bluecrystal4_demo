#!/bin/bash

#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:0:10
#SBATCH --mem=100M

# Show the current python version
python --version

# Load a module
module load languages/anaconda3

echo 'Job to test environment modules'
time srun python --version
