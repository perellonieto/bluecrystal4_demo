The following is an example of a script to be run in two nodes

    #!/bin/bash

    #SBATCH --job-name=test_job
    #SBATCH --partition=test
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=2
    #SBATCH --cpus-per-task=1
    #SBATCH --time=0-0:0:10
    #SBATCH --mem=100M

    echo 'My first job'
    time srun hostname

Once the script is allocated to the specified nodes, we will get an output file
containing all the standard output messages.

    $ sbatch add_queue_simple_script_01.sh
    Submitted batch job 1264457
    $ ls
    README.md  add_queue_simple_script_01.sh  add_queue_simple_script_02.sh slurm-1264457.out
    $ cat slurm-1264457.out
    My first job
    compute097.bc4.acrc.priv
    compute110.bc4.acrc.priv
    compute097.bc4.acrc.priv
    compute110.bc4.acrc.priv

    real    0m0.196s
    user    0m0.035s
    sys 0m0.005s

Because this is a really fast execution we will not have time to see the job in
the queue waiting and finally running. For that reason, we can run the second
script that will sleep for 10 seconds, thus giving us enough time to check our
queue and see how the job is waiting or running.

    $ sbatch add_queue_simple_script_02.sh
    Submitted batch job 1264419
    $ squeue -u mp15688
                 JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
               1264419      test test_job  mp15688  R       0:05      2 compute[097,110]

And after the 10 seconds we will get the corresponding output file:

    $ cat slurm-1264419.out
    My first job

    real    0m10.004s
    user    0m0.000s
    sys 0m0.001s
    compute097.bc4.acrc.priv
    compute097.bc4.acrc.priv
    compute110.bc4.acrc.priv
    compute110.bc4.acrc.priv
