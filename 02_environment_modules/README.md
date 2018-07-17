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

You can also include your own modules.

    git@github.com:tj/watch.git
    cd watch
    git checkout tags/0.3.1
    mkdir -p ~/Modules/modules/watch/0.3.1/bin
    PREFIX=~/Modules/modules/watch/0.3.1 make install

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
    A tiny C program used to periodically execute a command.

    More information
    ================
    - https://github.com/tj/watch/tree/0.3.1 ]])

    whatis([[A tiny C program used to periodically execute a command.]])
    whatis([[Homepage: http://git-scm.com/ ]])

    local root = "/mnt/storage/home/mp15688/Modules/modules/watch/0.3.1"

    prepend_path("PATH", pathJoin(root, "bin"))

We can also install an older version

    cd watch
    git checkout tags/0.1.0
    mkdir -p ~/Modules/modules/watch/0.1.0/bin
    PREFIX=~/Modules/modules/watch/0.1.0 make install

And we need to create the lua file ~/Modules/modulefiles/watch/0.1.0.lua

    help([[

    Description
    ===========
    A tiny C program used to periodically execute a command.

    More information
    ================
    - https://github.com/tj/watch/tree/0.1.0 ]])

    whatis([[A tiny C program used to periodically execute a command.]])
    whatis([[Homepage: http://git-scm.com/ ]])

    local root = "/mnt/storage/home/mp15688/Modules/modules/watch/0.1.0"

    prepend_path("PATH", pathJoin(root, "bin"))

The final tree of directories and files should look like this:

    Modules/
    |-- modulefiles
    |   `-- watch
    |       |-- 0.1.0.lua
    |       `-- 0.3.1.lua
    `-- modules
        `-- watch
            |-- 0.1.0
            |   `-- bin
            |       `-- watch
            `-- 0.3.1
                `-- bin
                    `-- watch

    8 directories, 4 files


Now we can load and unload the different modules

    $ module load watch/0.1.0
    $ watch --version
    0.1.0
    $ module load watch/0.3.1

    The following have been reloaded with a version change:
      1) watch/0.1.0 => watch/0.3.1

    $ watch --version
    0.3.1

# TODO: Another example install Python

Another example with Python

    wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz

Check that the md5sum is the same

    $ md5sum Python-3.7.0.tar.xz
    eb8c2a6b1447d50813c02714af4681f3  Python-3.7.0.tar.xz

Then uncompress the file

    tar xf Python-3.7.0.tar.xz

Create a folder for the installation

    mkdir -p ~/Modules/modules/Python/3.7.0/

Then install as follows:

    ./configure --prefix=$HOME/Modules/modules/Python/3.7.0
    make
    make install

## Possible problems

Problem 1

    Could not build the ssl module!
    Python requires an OpenSSL 1.0.2 or 1.1 compatible libssl with
    X509_VERIFY_PARAM_set1_host().
    LibreSSL 2.6.4 and earlier do not provide the necessary APIs,
    https://github.com/libressl-portable/portable/issues/381

Another problem

    from _ctypes import Union, Structure, Array
    ModuleNotFoundError: No module named '_ctypes'
    make: *** [install] Error 1

