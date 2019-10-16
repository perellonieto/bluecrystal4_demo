# Interactive jobs

It is possible to ask access to a node in an interactive way. This means that
you can get a shell to one node to possibly test your code before submitting
jobs to the job manager.

The following is an example to ask for a node with 2 cpus for 59 minutes

    srun --partition test --nodes 2 --cpus-per-task 2 --time 0-00:59:00 --mem=1G --pty bash

The same call but shorter

    srun -p test -N 2 -c 2 -t 0-01:00:00 --mem=1G --pty bash

You can find more options calling **srun --help**

Once you have a shell in the node, you can list the nodes that you have
allocated. Eg.

    $ srun  bash -c hostname
    compute394.bc4.acrc.priv
    compute415.bc4.acrc.priv

It is also possible to ask for the full node to be sure that no other user/job
is sharing the node (and memory) with the flag **--exclusive**

    srun -p test -c 1 -t 0-00:05:00 --exclusive --pty bash

Also, it is possible to ask for one gpu

    srun -p gpu --gres=gpu:1 -t 0-00:30:00 --mem=4G --pty bash

It may be useful to define the following two aliases in your ~/.bashrc file to do quick tests of your code in a normal node or a GPU node

```
alias stest="srun -p test -t 0-00:15:00 --exclusive --pty bash"
alias stestgpu="srun -p gputest -t 0-00:15:00 --exclusive --pty bash"
```
