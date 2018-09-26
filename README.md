# Blue Crystal Phase 4 demo

This is a set of demos to illustrate different uses of Blue Crystal phase 4.

You can find the following links of interest and they are a pre-requisite for
the demos. However, a small summary is added here.

- [BlueCrystal Phase 4 User Documentation](https://www.acrc.bris.ac.uk/protected/bc4-docs/index.html)
- [Additional Guides for BlueCrystal users](https://www.acrc.bris.ac.uk/acrc/resources.htm)
- [Advanced Computing Research Centre workshops](https://www.acrc.bris.ac.uk/acrc/training.htm)
- [Parallel Programming with Python by Chrys Woods](http://chryswoods.com/parallel_python/index.html)
- [Other useful courses by Chrys Wood](http://chryswoods.com/main/courses.html)
- [BlueCrystal Phase 3 User Documentation](https://www.acrc.bris.ac.uk/acrc/pdf/bc-user-guide.pdf)

# Logging On

Blue Crystal is composed by a set of nodes divided in different partitions.
One of the partitions is the logging nodes that are used only to get a shell in
order to access to your personal space and add jobs into a queue of the job
scheduler Slurm.

To logging into a login node ssh with your university username as following

    ssh -X username@bc4login.acrc.bris.ac.uk

You can also logging into a GPU logging node as follows

    ssh -X username@bc4gpulogin.acrc.bris.ac.uk

It is possible to check a summary of partitions and nodes with **sinfo -s**

    $ sinfo -s
    PARTITION     AVAIL  TIMELIMIT   NODES(A/I/O/T)  NODELIST
    veryshort        up    6:00:00    393/34/27/454  compute[076-525],highmem[10-13]
    test             up    1:00:00    393/34/27/454  compute[076-525],highmem[10-13]
    cpu_test         up    1:00:00          1/1/0/2  compute[074-075]
    cpu*             up 14-00:00:0    389/34/27/450  compute[076-525]
    hmem             up 14-00:00:0          7/1/0/8  highmem[10-17]
    gpu              up 7-00:00:00        29/0/1/30  gpu[01-30]
    gpu_veryshort    up    1:00:00          2/0/0/2  gpu[31-32]
    serial           up 3-00:00:00          0/6/0/6  compute[068-073]
    dcv              up 14-00:00:0          1/0/0/1  bc4vis1

# Disk Space

## Home space

Every home has 20 Gibabytes of space.

## Sratch Space

However, there is a larger space per user
of 512 Gigabytes called **scratch**. You should store there big datasets or
results of your experiments. You can create a symbolic link for an easier
access into your home folder

    ln -s /mnt/storage/scratch/$USER scratch

## Purchased Project Space

Some groups have additional purchased space in

    /mnt/storage/private

