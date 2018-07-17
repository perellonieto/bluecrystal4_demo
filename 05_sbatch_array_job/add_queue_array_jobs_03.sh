#!/bin/bash

#SBATCH --job-name=test_job
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:0:10
#SBATCH --mem=100M
#SBATCH --array=0-5

declare -a options_1=(
    'abc'
    'def'
    'ghi'
    )

declare -a options_2=(
    '111'
    '222'
    )

option_1_id=$((SLURM_ARRAY_TASK_ID%3))
option_2_id=$((SLURM_ARRAY_TASK_ID/3))

option_1=${options_1[$option_1_id]}
option_2=${options_2[$option_2_id]}

echo 'Running parallel jobs'
srun echo "option_1 = ${option_1}, option_2 = ${option_2}"
