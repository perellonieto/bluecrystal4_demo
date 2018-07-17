#!/bin/bash

#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:0:10
#SBATCH --mem=100M
#SBATCH --array=0-2

declare -a options_list=(
    '/'
    '/var/'
    '/var/log/'
    )

option=${options_list[$SLURM_ARRAY_TASK_ID]}

echo "This instance runs ls on the folder ${option}"
srun ls ${option}
