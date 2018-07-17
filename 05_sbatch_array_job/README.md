# Sbatch Job arrays

We can also create an array of individual jobs, each one with a different set
of parameters. 

## Simple example with array value

In this example we define the set of values that we want to use with the
**--array=0-5** argument indicating values from 0 to 5.

    #!/bin/bash

    #SBATCH --job-name=test_job
    #SBATCH --partition=test
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --time=0-0:0:10
    #SBATCH --mem=100M
    #SBATCH --array=0-5

    echo 'Running parallel jobs'
    srun echo $SLURM_ARRAY_TASK_ID

This will run the same script 6 times with the values 0 to 5

    $ cat slurm-1264846_*.out
    Running parallel jobs
    0
    Running parallel jobs
    1
    Running parallel jobs
    2
    Running parallel jobs
    3
    Running parallel jobs
    4
    Running parallel jobs
    5

## Example with an array

The next example defines an array of arguments and selects each argument with
the array id

    $ cat add_queue_array_jobs_02.sh
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

The resulting files will contain something like

    $ cat slurm-1264858_*.out
    This instance runs ls on the folder /
    0
    bin
    dev
    etc
    gpfs
    home
    lib
    lib64
    media
    mnt
    opt
    proc
    root
    run
    sbin
    srv
    sys
    tmp
    usr
    var
    xcatpost
    This instance runs ls on the folder /var/
    adm
    cache
    db
    empty
    games
    gopher
    kerberos
    lib
    local
    lock
    log
    mail
    mmfs
    nis
    opt
    preserve
    run
    spool
    tmp
    yp
    This instance runs ls on the folder /var/log/
    boot.log
    btmp
    dmesg
    journal
    lastlog
    maillog
    messages
    munge
    mybeat
    nhc.log
    ntpstats
    salt
    samba
    secure
    slurmd.log
    spooler
    sssd
    tallylog
    wtmp
    xcat
    yum.log


## Example with two arrays

In the following example instead of parameters for a command, we
will echo different messages. We will iterate over two arrays and create all
the possible combination of parameters:

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

As we mentioned beWe will see in the queue all the jobs differentiated by a subindex indicating
the jobarray number

    $ squeue -u mp15688
                 JOBID PARTITION     NAME     USER ST       TIME  NODES
    NODELIST(REASON)
         1264836_[0-5]      test test_job  mp15688 PD       0:00      1 (Resources)


Once executed, we will have one output file per task. Let's see the output of
all the files

    $ cat slurm-1264836_*.out
    Running parallel jobs
    option_1 = abc, option_2 = 111
    Running parallel jobs
    option_1 = def, option_2 = 111
    Running parallel jobs
    option_1 = ghi, option_2 = 111
    Running parallel jobs
    option_1 = abc, option_2 = 222
    Running parallel jobs
    option_1 = def, option_2 = 222
    Running parallel jobs
    option_1 = ghi, option_2 = 222
