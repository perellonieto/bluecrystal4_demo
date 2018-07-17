#!/bin/bash

#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=0-0:2:0
#SBATCH --mem=200M

module load languages/anaconda3

source ./venv/bin/activate

hosts=$(srun bash -c hostname)
echo "List of all the allocated hosts is ${hosts}"

echo 'Running all jobs'
python -m scoop --host ${hosts} -v main.py
