# Example of Python Scoop for parallel programming

We will load Anaconda 3 as it comes with Python3.6 and we can then create a
virtual environment and load it.

    $ module load languages/anaconda3
    [mp15688@bc4login1 06_python_scoop_parallel]$ python -m venv venv
    [mp15688@bc4login1 06_python_scoop_parallel]$ source venv/bin/activate

Then we can install the Python library scoop

    (venv) [mp15688@bc4login1 06_python_scoop_parallel]$ pip install scoop
    Collecting scoop
    Collecting pyzmq>=13.1.0 (from scoop)
      Using cached
    https://files.pythonhosted.org/packages/94/e8/6b39ec62b4f7821eeefd69e0c1ddfd56744cd6613f8216fc972cfc8d7765/pyzmq-17.1.0-cp36-cp36m-manylinux1_x86_64.whl
    Collecting greenlet>=0.3.4 (from scoop)
      Using cached
    https://files.pythonhosted.org/packages/dd/ce/7b3a19a3eb8c79e6237ba1fb7a8729b39034dd2de8753b8d27e5abc59fd5/greenlet-0.4.13-cp36-cp36m-manylinux1_x86_64.whl
    Collecting argparse>=1.1 (from scoop)
      Using cached
    https://files.pythonhosted.org/packages/f2/94/3af39d34be01a24a6e65433d19e107099374224905f1e0cc6bbe1fd22a2f/argparse-1.4.0-py2.py3-none-any.whl
    Installing collected packages: pyzmq, greenlet, argparse, scoop
    Successfully installed argparse-1.4.0 greenlet-0.4.13 pyzmq-17.1.0
    scoop-0.7.1.1
    You are using pip version 9.0.3, however version 10.0.1 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.

The following is an example using scoop to compute several sums on parallel

    $ cat main.py
    from scoop import futures

    def sum_arguments(args):
        (arg1, arg2) = args
        return arg1 + arg2

    def main():
        args = [[1, 2], [3, 4], [5, 6], [7, 8]]
        results = futures.map(sum_arguments, args)
        for i, res in enumerate(results):
            print('results[{}] = {}'.format(i, res))

    if __name__=='__main__':
        main()

We then define the number of nodes and how many cpus whant to use on each node

    $ cat add_queue_scoop_01.sh
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

And there will be only one output file

    $ cat slurm-1264862.out
    List of all the allocated hosts is compute097.bc4.acrc.priv
    compute110.bc4.acrc.priv
    Running all jobs
    [2018-07-17 19:39:44,847] launcher  INFO    SCOOP 0.7 1.1 on linux using Python 3.6.5 |Anaconda, Inc.| (default, Apr 29 2018, 16:14:56) [GCC 7.2.0], API: 1013
    [2018-07-17 19:39:44,847] launcher  INFO    Detected SLURM environment.
    [2018-07-17 19:39:44,847] launcher  INFO    Deploying 2 worker(s) over 2 host(s).
    [2018-07-17 19:39:44,847] launcher  DEBUG   Using hostname/ip: "compute097.bc4.acrc.priv" as external broker reference.
    [2018-07-17 19:39:44,847] launcher  DEBUG   The python executable to execute the program with is: /mnt/storage/home/mp15688/git/bluecrystal4_demo/06_python_scoop_parallel/venv/bin/python.
    [2018-07-17 19:39:44,847] launcher  INFO    Worker distribution:
    [2018-07-17 19:39:44,847] launcher  INFO       compute097.bc4.acrc.priv:    0 + origin
    [2018-07-17 19:39:44,847] launcher  INFO       compute110.bc4.acrc.priv:    1
    [2018-07-17 19:39:44,847] brokerLaunch DEBUG   Launching remote broker: ssh -x -n -oStrictHostKeyChecking=no compute097.bc4.acrc.priv /mnt/storage/home/mp15688/git/bluecrystal4_demo/06_python_scoop_parallel/venv/bin/python -m scoop.broker.__main__ --echoGroup --echoPorts --backend ZMQ
    [2018-07-17 19:39:45,412] brokerLaunch DEBUG   Foreign broker launched on ports 44122, 43802 of host compute097.bc4.acrc.priv.
    [2018-07-17 19:39:45,412] launcher  DEBUG   Initialising remote worker 2 [compute110.bc4.acrc.priv].
    [2018-07-17 19:39:45,412] launcher  DEBUG   compute110.bc4.acrc.priv: Launching '(/mnt/storage/home/mp15688/git/bluecrystal4_demo/06_python_scoop_parallel/venv/bin/python -m scoop.bootstrap.__main__ --echoGroup  --size 2 --workingDirectory /mnt/storage/home/mp15688/git/bluecrystal4_demo/06_python_scoop_parallel --brokerHostname compute097.bc4.acrc.priv --externalBrokerHostname compute097.bc4.acrc.priv --taskPort 44122 --metaPort 43802 --backend=ZMQ -v main.py)'
    [2018-07-17 19:39:46,074] launcher  DEBUG   Initialising remote origin worker 1 [compute097.bc4.acrc.priv].
    [2018-07-17 19:39:46,074] launcher  DEBUG   compute097.bc4.acrc.priv: Launching '(/mnt/storage/home/mp15688/git/bluecrystal4_demo/06_python_scoop_parallel/venv/bin/python -m scoop.bootstrap.__main__ --echoGroup  --size 2 --workingDirectory /mnt/storage/home/mp15688/git/bluecrystal4_demo/06_python_scoop_parallel --brokerHostname 127.0.0.1 --externalBrokerHostname compute097.bc4.acrc.priv --taskPort 44122 --metaPort 43802 --origin --backend=ZMQ -v main.py)'
    [2018-07-17 19:39:46,607] __main__  INFO    Worker(s) launched using /bin/bash
    results[0] = 3
    results[1] = 7
    results[2] = 11
    results[3] = 15
    [2018-07-17 19:39:46,982] launcher  INFO    Root process is done.
    [2018-07-17 19:39:46,983] workerLaunch DEBUG   Closing workers on compute110.bc4.acrc.priv (1 workers).
    [2018-07-17 18:39:46,073] __main__  INFO    Worker(s) launched using /bin/bash
    [2018-07-17 18:39:46,670] scoopzmq  (b'10.142.10.110:50747') DEBUG   b'10.142.10.110:50747': Could not send result directly to peer b'10.142.10.97:49394', routing through broker.
    [2018-07-17 19:39:47,490] workerLaunch DEBUG   Closing workers on compute097.bc4.acrc.priv (1 workers).
    [2018-07-17 19:39:47,976] brokerLaunch DEBUG   Closing broker on host compute097.bc4.acrc.priv.
    [2018-07-17 19:39:48,448] launcher  INFO    Finished cleaning spawned subprocesses.

