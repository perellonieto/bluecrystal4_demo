# Sbatch environment modules

As we mentioned before, it is possible to load different modules while in a
session. Because every project will have its own dependencies, it is a good
practice to load the required modules for each script. The following is an
example loading the Anaconda 3 package.

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

We will get the following output where every task on every node shows the
loaded python version

    $ cat slurm-1264612.out
    Python 2.7.5
    Job to test environment modules
    Python 3.6.5 :: Anaconda, Inc.
    Python 3.6.5 :: Anaconda, Inc.
    Python 3.6.5 :: Anaconda, Inc.
    Python 3.6.5 :: Anaconda, Inc.

    real    0m0.193s
    user    0m0.035s
    sys 0m0.006s

