# Environment Modules

The environment modules allows an easy solution to load and unload libraries,
binaries, and packages of different versions during a session. This is done by
modifying on real time certain environment variables like **$PATH** or
**$LD_LIBRARY_PATH** in a transparent way calling the program **module**

In order to obtain some additional modules it will be necessary to add the
following line in our **.bashrc** file

    module use /mnt/storage/easybuild/modules/local

An extensive guide can be found in [ACRC How-To: Customising Your Linux
Environment with Environment Variables](https://www.acrc.bris.ac.uk/acrc/pdf/customising-environment-variables.pdf)

## Available modules

The command **module avail** shows a list with all the
available modules. These are arranged on different folders by use. The
following is a small example of the output:

    --------------------------------- /mnt/storage/easybuild/modules/local ----------------------------------
       apps/fasttree/2.1.10                       languages/anaconda2/5.0.1                  (D)
       apps/gctf/1.18                             languages/anaconda3/3.5-4.2.0-tflow-1.7
       apps/gromacs/5.1.4-plumed-mpi-intel        languages/anaconda3/5.2.0-tflow-1.7        (L,D)

One detail to have in mind is that **module avail** uses the standard error
output instead of the output channel. This may be confusing if we try to search
for a pattern with **grep**. If we want to filter any text you should first
redirect the sterr to stout channel. See the following example

    $ module avail 2>&1 | grep anaconda3
       languages/anaconda3/3.5-4.2.0-tflow-1.7
       languages/anaconda3/5.2.0-tflow-1.7        (D)

## List currently loaded modules

It is possible to see the modules that are currently loaded with **module
list**. The following is an example of the output:

    Currently Loaded Modules:
      1) GCCcore/5.4.0                  5) libs/cudnn/7.1-cuda-9.0
      2) binutils/2.26-GCCcore-5.4.0    6) languages/java/sdk-1.8.0.141
      3) GCC/5.4.0-2.26                 7) languages/anaconda3/5.2.0-tflow-1.7
      4) libs/cuda/9.0-gcc-5.4.0-2.26   8) tools/git/2.18.0

## Load a module

You can load a given module with **module load nameofthemodule**. The name can
be the just the begining and it will match to the corresponding module. If
several modules start with the same pattern, the default one will be selected
(marked with D). The currently loaded modules are marked with an L.

For example, we may load the Python Anaconda3 environment with tensorflow, and
check that now the python version has changed:

    $ python --version
    Python 2.7.5
    $ module load languages/anaconda3
    $ python --version
    Python 3.6.5 :: Anaconda, Inc.

## Unload a module

In the same manner that a module is loaded, it is possible to unload with the
command **module unload nameofthemodule**. Following the previous example we
can unload Anaconda3 and check that we get back the default Python.

    $ module unload languages/anaconda3
    $ python --version
    Python 2.7.5

## Your own modules

For example, this is my own module watch

    Modules/
    |-- modulefiles
    |   `-- watch
    |       `-- 0.3.1.lua
    `-- modules
        `-- watch
            `-- 0.3.1
                `-- bin
                    `-- watch

Then, it is required to add the load our modulefiles in our **.bashrc** file by
adding the following line

    module use ~/Modules/modulefiles/

And the content of the **0.3.1.lua** file is (TODO: need to update description)

    help([[

    Description
    ===========
    Git is a free and open source distributed version control system designed
    to handle everything from small to very large projects with speed and
    efficiency.


    More information
    ================
    - Homepage: http://git-scm.com/ ]])

    whatis([[
    Description: Git is a free and open source distributed version control system
    designed
    to handle everything from small to very large projects with speed and
    efficiency. ]])
    whatis([[Homepage: http://git-scm.com/ ]])

    local root = "/mnt/storage/home/mp15688/Modules/modules/watch/0.3.1"

    prepend_path("PATH", pathJoin(root, "bin"))
