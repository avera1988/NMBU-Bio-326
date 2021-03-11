# Basic exercises for best practices in Orion

**Login into orion** 

To login into Orin we need two things:
- Establish a VPN connection
- Use a secure-shell command [ssh](https://en.wikipedia.org/wiki/SSH_(Secure_Shell))

For login just type something like this. 

```bash
$ ssh bio326-21-0@login.nmbu.no
```
*Remember to change to your username bio326-21-x*

This will ask for your password. Type it

*Even you don't see anything the password is typed*

```bash
bio326-21-0@login.orion.nmbu.no's password: 
Last login: Tue Mar  2 11:18:13 2021 from 10.230.14.52

Welcome to the NMBU Orion compute cluster environment.

You are logged in to a machine that can be used to access your home directory,
edit your scripts, manage your files, and submit jobs to the cluster environment.
Do not run any jobs on this machine, as they might be automatically terminated.

IMPORTANT:
  - Orion introduction: https://orion.nmbu.no/
  - Orion can handle small-scale projects. Need more CPU hours? Please consider
    applying for national infrastructure resources: https://www.sigma2.no/
  - Please, PLEASE do compress your fastq, vcf and other non-compressed files
    using i.e. pigz.

For any Orion related enquiry: orion-support@nmbu.no
PS: We are on Teams: https://bit.ly/orion-teams

[bio326-21-0@login ~]$ 
```

**Now you are logged into the Orion login-node.**

### Orion main configuration 

Let's take a look into this figure: 

![Cluster](https://github.com/avera1988/NMBU-Bio-326/blob/main/images/cluster.png)

**NEVER RUN A JOB IN THE LOGIN NODE!!! THE LOGIN NODE IS ONLY FOR LOOKING AND MANAGING FILES, INSTALL SOFTWARE AND WRITE SCRIPTS** 

How can I be sure of the number of CPUs and RAM of this "login" computer node and other nodes?

* CPUS: Use the command nproc

```Bash
[bio326-21-0@login ~]$ nproc 
6
```

* RAM: We need to look for the "Total memory". All this info is allocated in the meminfo file at /proc directory. So we can use the grep command to look for this into the file.

```
bio326-21-0@login ~]$ grep MemTotal /proc/meminfo
MemTotal:       32744196 kB
```

As you can see, this computer is not well suitable for "heavy" computational work. So if we want to do some work (e.g. run BLAST or assembly a genome) we need to send this (job) into a compute node.

There are two ways for doing this:
* Interactive Job (via SLURM)
* Schedule a Job (via SLURM)

### What is SLURM? 

[Slurm](https://slurm.schedmd.com/) is an open source and highly scalable cluster management and job scheduling system for large and small Linux clusters. As a cluster workload manager, Slurm has three key functions.

- First, it allocates access to resources (compute nodes) to users for some duration of time so they can perform work
- Second, it provides a framework for starting, executing, and monitoring work (normally a parallel job) on the set of allocated nodes
- Finally, it arbitrates contention for resources by managing a queue of pending work (from Slurm overview)
It is important to know that:

**All Slurm commands start with letter “s" (e.g sbatch, scancel, srun, etc...)**

**Resource allocation depends on your fairshare i.e. priority in the queue, so remember not to be "greedy" when you submit a job!!!**

### Orion Resources and information through SLURM.

If we want to know the amount of CPU, RAM and other configuration in the cluster, we can use a set of tools (commands) SLURM provide to find available resources in Orion.

For example we can display the Partition, No. of CPUs, Memmory ammount of each node (computer) in Orion using the following instructions:

```bash
[bio326-21-0@login ~]$ sinfo --long --Node
Thu Mar 11 15:20:21 2021
NODELIST   NODES    PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
cn-1           1      hugemem       mixed 144    4:18:2 309453        0      1 cpu_xeon none                
cn-1           1  interactive       mixed 144    4:18:2 309453        0      1 cpu_xeon none                
cn-2           1      hugemem   allocated 80     40:1:2 103186        0      1 cpu_xeon none                
cn-2           1  interactive   allocated 80     40:1:2 103186        0      1 cpu_xeon none                
cn-3           1       orion*       mixed 80     40:1:2 103186        0      1 cpu_xeon none                
cn-3           1      hugemem       mixed 80     40:1:2 103186        0      1 cpu_xeon none                
cn-3           1  interactive       mixed 80     40:1:2 103186        0      1 cpu_xeon none                
cn-4           1       orion*   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-4           1     smallmem   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-4           1 verysmallmem   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-5           1       orion*       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-5           1     smallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-5           1 verysmallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-6           1       orion*   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-6           1     smallmem   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-6           1 verysmallmem   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-7           1       orion*       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-7           1 verysmallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-7           1       lowpri       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-8           1       orion*       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-8           1     smallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-8           1 verysmallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-9           1       orion*       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-9           1     smallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-9           1 verysmallmem       mixed 32     32:1:1 193230        0      1 cpu_xeon none                
cn-10          1       orion*   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-10          1     smallmem   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-10          1       lowpri   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-10          1 verysmallmem   allocated 32     32:1:1 193230        0      1 cpu_xeon none                
cn-12          1     smallmem       mixed 32      2:8:2 257738        0      1 cpu_xeon none                
cn-12          1 verysmallmem       mixed 32      2:8:2 257738        0      1 cpu_xeon none                
cn-13          1       orion*       mixed 12      2:6:1  31917        0      1 cpu_xeon none                
cn-13          1 verysmallmem       mixed 12      2:6:1  31917        0      1 cpu_xeon none                
cn-14          1      hugemem       mixed 256    2:64:2 205153        0      1 cpu_amd, none                
cn-14          1  interactive       mixed 256    2:64:2 205153        0      1 cpu_amd, none                
gn-0           1          gpu completing* 64     2:16:2 257710        0      1 cpu_amd, none                
gn-1           1          gpu       mixed 64     2:16:2 257710        0      1 cpu_amd, none                
gn-1           1  interactive       mixed 64     2:16:2 257710        0      1 cpu_amd, none                
gn-2           1          gpu     drained 64     2:16:2 257710        0      1 cpu_amd, Kill task failed    
gn-2           1  interactive     drained 64     2:16:2 257710        0      1 cpu_amd, Kill task failed    
gn-3           1          gpu       mixed 64     2:16:2 257710        0      1 cpu_amd, none   
```
In this case the State column showed status of the node. It means, how many resources can be allocated per node, in this example there are 4 different status: 

* allocated: The node has been allocated to one or more jobs.
* completing* : All jobs associated with this node are in the process of COMPLETING. This node state will be removed when all of the job's processes have terminated
* drained: The node is unavailable for use per system administrator request. 
* mixed: The node has some of its CPUs ALLOCATED while others are IDLE.

Summarizing, the only nodes that can accept jobs under the previous conditions are those with "MIXED" status. 

## Memory quota in $HOME, $SCRATHC and $TMPDIR 

As a user you can check the ammount of space used in different directories. To check all the disks and partitions in Orion we can run the following command:

```bash
bio326-21-0@login ~]$ df -h 
Filesystem                                   Size  Used Avail Use% Mounted on
devtmpfs                                      16G     0   16G   0% /dev
tmpfs                                         16G  316K   16G   1% /dev/shm
tmpfs                                         16G  837M   15G   6% /run
tmpfs                                         16G     0   16G   0% /sys/fs/cgroup
/dev/mapper/centos_login--0-root              28G   18G  9.8G  65% /
/dev/sdb                                     100G   29G   72G  29% /work
/dev/sda2                                   1014M  214M  801M  22% /boot
/dev/sda1                                    200M   12M  189M   6% /boot/efi
fs-1:/                                       973M  6.0M  967M   1% /net/fs-1
fs-1:/projects01                              95T   93T  2.3T  98% /net/fs-1/projects01
fs-1:/home01                                  76T   75T  1.8T  98% /net/fs-1/home01
tmpfs                                        3.2G  4.0K  3.2G   1% /run/user/1035
cn-1:/mnt/SCRATCH                             77T   66T   12T  86% /net/cn-1/mnt/SCRATCH
fs-1:/Transpose                               38T   38T  615G  99% /net/fs-1/Transpose
tmpfs                                        3.2G     0  3.2G   0% /run/user/10023
tmpfs                                        3.2G     0  3.2G   0% /run/user/10197
cn-1:/mnt/labdata01                           81T   79T  1.8T  98% /net/cn-1/mnt/labdata01
tmpfs                                        3.2G     0  3.2G   0% /run/user/1034
tmpfs                                        3.2G  8.0K  3.2G   1% /run/user/10209
fs-1:/SandveLab                               29T   22T  6.7T  77% /net/fs-1/SandveLab
cn-13:/mnt/SCRATCH2                          148T  145T  3.0T  99% /net/cn-13/mnt/SCRATCH2
cvmfs2                                       4.9G  3.4G  1.6G  69% /cvmfs/cvmfs-config.galaxyproject.org
cvmfs2                                       4.9G  3.4G  1.6G  69% /cvmfs/singularity.galaxyproject.org
tmpfs                                        3.2G     0  3.2G   0% /run/user/1018
fs-1:/Geno                                    29T   29T  103M 100% /net/fs-1/Geno
tmpfs                                        3.2G     0  3.2G   0% /run/user/30048
tmpfs                                        3.2G     0  3.2G   0% /run/user/1004
tmpfs                                        3.2G     0  3.2G   0% /run/user/10192
tmpfs                                        3.2G     0  3.2G   0% /run/user/10184
tmpfs                                        3.2G     0  3.2G   0% /run/user/1028
tmpfs                                        3.2G     0  3.2G   0% /run/user/10207
fs-1:/Ngoc                                   2.0T  1.2T  744G  62% /net/fs-1/Ngoc
fs-1:/Ngoc/.snapshot/weekly.2021-01-17_0010  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/weekly.2021-01-17_0010
fs-1:/PEPomics01                              34T   31T  2.4T  93% /net/fs-1/PEPomics01
fs-1:/Ngoc/.snapshot/daily.2021-01-28_0005   103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/daily.2021-01-28_0005
fs-1:/Ngoc/.snapshot/daily.2021-01-29_0005   103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/daily.2021-01-29_0005
fs-1:/Ngoc/.snapshot/hourly.2021-01-29_0000  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/hourly.2021-01-29_0000
fs-1:/Ngoc/.snapshot/hourly.2021-01-28_2100  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/hourly.2021-01-28_2100
fs-1:/Ngoc/.snapshot/hourly.2021-01-29_0100  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/hourly.2021-01-29_0100
fs-1:/Ngoc/.snapshot/hourly.2021-01-28_2200  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/hourly.2021-01-28_2200
fs-1:/Ngoc/.snapshot/hourly.2021-01-28_2300  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/hourly.2021-01-28_2300
fs-1:/Ngoc/.snapshot/hourly.2021-01-28_2000  103G  103G     0 100% /net/fs-1/Ngoc/.snapshot/hourly.2021-01-28_2000
tmpfs                                        3.2G     0  3.2G   0% /run/user/10305
tmpfs                                        3.2G     0  3.2G   0% /run/user/40015
tmpfs                                        3.2G     0  3.2G   0% /run/user/1080
tmpfs                                        3.2G     0  3.2G   0% /run/user/1002
tmpfs                                        3.2G     0  3.2G   0% /run/user/30053
tmpfs                                        3.2G     0  3.2G   0% /run/user/1029
tmpfs                                        3.2G     0  3.2G   0% /run/user/30064
tmpfs                                        3.2G     0  3.2G   0% /run/user/10027
tmpfs                                        3.2G     0  3.2G   0% /run/user/10205
tmpfs                                        3.2G     0  3.2G   0% /run/user/1032
tmpfs                                        3.2G     0  3.2G   0% /run/user/10230
tmpfs                                        3.2G     0  3.2G   0% /run/user/1011
tmpfs                                        3.2G     0  3.2G   0% /run/user/10297
fs-1:/IPVProjects01                           57T   55T  2.4T  96% /net/fs-1/IPVProjects01
fs-1:/Foreco                                  12T  1.5T   10T  13% /net/fs-1/Foreco
fs-1:/AmazonAcoustics                        9.5T  3.2T  6.4T  33% /net/fs-1/AmazonAcoustics
fs-1:/Home_alme                              973G  348G  626G  36% /net/fs-1/Home_alme
fs-1:/Home_rush                              973G  168G  806G  18% /net/fs-1/Home_rush
fs-1:/Home_turhamar                          973G  686G  288G  71% /net/fs-1/Home_turhamar
fs-1:/PreventADALL                           4.8T  1.4T  3.4T  30% /net/fs-1/PreventADALL
fs-1:/TestFile                               973G  774M  973G   1% /net/fs-1/TestFile
fs-1:/results01                               95T   90T  5.8T  94% /net/fs-1/results01
cvmfs2                                       4.9G  3.4G  1.6G  69% /cvmfs/main.galaxyproject.org
cn-13:/mnt/BACKUP                             71T   34T   38T  48% /net/cn-13/mnt/BACKUP
10.222.0.101:/mnt/SALMON-SEQDATA              37T   37T  168G 100% /net/10.222.0.101/mnt/SALMON-SEQDATA
fs-1:/results03                               48T   45T  3.3T  94% /net/fs-1/results03
fs-1:/HumGut                                  19T   15T  4.7T  76% /net/fs-1/HumGut
fs-1:/AquaGen                                 19T   13T  7.0T  64% /net/fs-1/AquaGen
//10.209.0.10/Completed_projects             932G  507G  425G  55% /mnt/smb/GT1
//10.209.0.205/Completed_Projects            932G  405G  527G  44% /mnt/smb/GT2
//10.209.0.204/Completed_Projects            932G  427G  505G  46% /mnt/smb/GT3
//10.209.0.203/Completed_Projects            932G  339G  594G  37% /mnt/smb/GT4
//10.209.0.202/Completed_Projects            932G  456G  477G  49% /mnt/smb/GT5
tmpfs                                        3.2G     0  3.2G   0% /run/user/30049
tmpfs                                        3.2G     0  3.2G   0% /run/user/30047
tmpfs                                        3.2G     0  3.2G   0% /run/user/1033
tmpfs                                        3.2G     0  3.2G   0% /run/user/4000
```

As you can notice there are plenty of directories in Orion, but let's focus in the $HOME partition. To do that you need to run:

```
[bio326-21-0@login ~]$ df -h .
Filesystem      Size  Used Avail Use% Mounted on
fs-1:/home01     76T   75T  1.8T  98% /net/fs-1/home01
```

**All users have access to the $HOME, so please DO NOT USE THE $HOME FOR STORAGE LARGE FILES (e.g. fastq, sam, databases). The $HOME directory is intended to allocate small software executables and SLURM scripts **

### Where can I storage large files? 

There are two dierectories designed to this:
* $SCRATCH
* $PROJECT

As a student of this course, we are using the $SCRATCH partition to keep our raw sequencing files and final results. This partition in contrast to the $HOME and $PROJECT is not backed up. Remember to make a copy of your important files!!! All students have a directory in that partition: /mnt/SCRATCH/bio326-21-x ; where x is the student number.

Let's move into that partition:

```
[bio326-21-0@login ~]$ cd /mnt/SCRATCH/bio326-21-0
```




