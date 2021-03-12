# Basic exercises for best practices in Orion

**Login into orion** 

To login into Orin we need two things:
- Establish a VPN connection
- Use a secure-shell command [ssh](https://en.wikipedia.org/wiki/SSH_(Secure_Shell))

For login just type something like this. 

```bash
$ ssh bio326-21-0@login.orion.nmbu.no
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
In this case, the State column showed the status of the node. It means, how many resources can be allocated per node, in this example there are 4 different status: 

* allocated: The node has been allocated to one or more jobs.
* completing* : All jobs associated with this node are in the process of COMPLETING. This node state will be removed when all of the job's processes have terminated
* drained: The node is unavailable for use per system administrator request. 
* mixed: The node has some of its CPUs ALLOCATED while others are IDLE.

Summarizing, the only nodes that can accept jobs under the previous conditions are those with "MIXED" status. 

## Memory quota in $HOME, $SCRATCH and $TMPDIR 

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

**All users have access to the $HOME, so please DO NOT USE THE $HOME FOR STORAGE LARGE FILES (e.g. fastq, sam, databases). The $HOME directory is intended to allocate small software executables and SLURM scripts**

### Where can I storage large files? 

There are two dierectories designed to this:
* $SCRATCH
* $PROJECT

As a student of this course, we are using the $SCRATCH partition to keep our raw sequencing files and final results. This partition in contrast to the $HOME and $PROJECT is not backed up. **Remember to make a copy of your important files into another location!!!** All students have a directory in that partition: /mnt/SCRATCH/bio326-21-x ; where x is the student number.

Let's move into that partition:

```
[bio326-21-0@login ~]$ cd /mnt/SCRATCH/bio326-21-0
```

## Running an interactive job to test programs and get used to working in the cluster

The easiest way to test software and to look into huhge files without messing the login node and other users, is by running an **interactive** job in Orion. This means you can book a compute node and type your commands directly in that node. Let's run an interactive job by the following commands:

```
[bio326-21-0@login bio326-21-0]$ srun --cpus-per-task 4 --mem=4G --time=01:00:00 --pty bash -i
srun: job 12314004 queued and waiting for resources
```
*Basic syntaxis the command:
 srun \<slurm-options> \<software-name/path>*
  
It might take a while to SLURM allocate the resources of this job. But as soon as it allocates the job a message like this will be displayed:

```
srun: job 12314004 has been allocated resources

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

NEWS:
  - 2020-10-08: Orion has been re-built. We are still working out many details.
    Please email us if you miss anything, or notice any issues.

For any Orion related enquiry: orion-support@nmbu.no
PS: We are on Teams: https://bit.ly/orion-teams

[bio326-21-0@cn-3 bio326-21-0]$ 
```

You can notice that now the prompt has changed and shows the node we are running on. In this case the node "cn-3". Also if this is not displayed we can take advantage of the many [SLURM_environment_variables](https://slurm.schedmd.com/pdfs/summary.pdf). These are dynamic values that SLURM uses to control the computers. For example, if you would like to know what is the node and number of CPUs requested in this job you can print the values of that SLURM variable by applying the command "echo" follows by the name of the variable:

```
[bio326-21-0@cn-3 bio326-21-0]$ echo $SLURM_NODELIST 
cn-3
[bio326-21-0@cn-3 bio326-21-0]$ echo $SLURM_CPUS_ON_NODE 
4
```

Here we can run short parsing scripts, test software with a small datasets, etc. 

### Temporary working directory, faster and more efficient Jobs

Generaly any software can read (data) and write (results) from any partition of the cluster (i.e. $HOME, $SCRATCH, $PROJECT), however, I/O (reading and writing) from those locations uses a lot of networ resulting in a high inefficenfy for heavy jobs (e.g mapping reads to large genomes or metagenomes). Also if multiple users run in the same way the traffic in the network eve using the infiniband makes the jobs super slow. 
To avoid this we can take advantage of the **$TMPDIR** partition. This is a physical hard-drive allocated in each of the compute nodes. We can migrate the data to here for I/O. Often, quite some efficiency can be gained by doing this.

Let's take a look, first we need to check if our **$USER** exists in that **$TMPDIR**

```
[bio326-21-0@cn-3 bio326-21-0]$ echo $TMPDIR/$USER
/home/work/bio326-21-0
```

This means the user **bio326-21-0** has a directory in the **$TMPDIR** (/home/work). Move to that directory:

```
[bio326-21-0@cn-3 bio326-21-0]$  cd $TMPDIR/$USER
[bio326-21-0@cn-3 bio326-21-0]$ pwd
/home/work/bio326-21-0
```

Now we need to create an other directory **a work directory** to copy data for executing some commands. We can use another SLURM variable, let's say the JOBID to be consistent.


```
[bio326-21-0@cn-3 bio326-21-0]$ mkdir work.dir.of.$SLURM_JOB_ID 
[bio326-21-0@cn-3 bio326-21-0]$ ls
singularity  work.dir.of.12314866
```

By using the $SLURM_JOB_ID we can further identify what job we are running.

Let's enter to that directory and then copy some fasta files from the **$SCRATCH**, that is a good directory to put raw data. In this class we are using the files from **/mnt/SCRATCH/bio326-21/BestPracticesOrion_031221** path.

```
[bio326-21-0@cn-3 bio326-21-0]$ cd work.dir.of.12314866/
[bio326-21-0@cn-3 work.dir.of.12314866]$ pwd
/home/work/bio326-21-0/work.dir.of.12314866
```

First take a look of the **/mnt/SCRATCH/bio326-21/BestPracticesOrion_031221** 

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ ls -l /mnt/SCRATCH/bio326-21/BestPracticesOrion_031221
total 17072
-rw-rw-r-- 1 auve bio326-21      838 Mar 11 16:29 amylase.Bgramini.fasta
-rw-rw-r-- 1 auve bio326-21  2085506 Mar 11 16:29 Bacteroides51.faa
-rw-rw-r-- 1 auve bio326-21 15103261 Mar 11 16:29 Bacteroides51.GCF_010500965.1.gbff
-rw-rw-r-- 1 auve bio326-21   280161 Mar 11 16:29 Bacteroides51.tab
```

*Tip: Having more than one terminal open will help to faster look into multiple directories*

As you can see there are multiple files here, lets copy the two fasta files **.faa and .fasta** into the $TMPDIR/workdirectoryforthejob

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ cp /mnt/SCRATCH/bio326-21/BestPracticesOrion_031221/*.fa* .
[bio326-21-0@cn-3 work.dir.of.12314866]$ ls
amylase.Bgramini.fasta  Bacteroides51.faa
```

*Remember that you can copy multiple files using regular expression (REGEX) in this case* * *.fa* * *means "everything that has .fa on it"*

No we can do some work on this files. Take a look of the **amylase.Bgramini.fasta** file 

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ more amylase.Bgramini.fasta 
>WP_024997086.1 alpha-amylase [Bacteroides graminisolvens]
MKRYKYWFLLLIPFLIVACSGSDDPVIEPPVVLKEGLNYSPTAPDADQELTITFKAGSTSALYNYVGDVY
VHIGVIVDGSWKYVPAEWTENISKCKMTKTADNVWSVKLSPTVRQWFASGETSIQKLGIVIRNADGSKKG
LTDDAFVSVTDSKYKPFTPAAIKYATLPAGVKEGINIVNSSTVTLVLYDKDKSGNHKDYAHVIGDFNSWK
LTNDDKSQMNRDDAAGCWWITLSGLTGTKEYAFQYYVGTAAEGATRLADAYSRKILDPDNDSYISSTTYN
EDKTYPQGAEGIVSVFKTEPDTYTWKNTAFKMKDKDDLVIYEMLLRDFTASGDLNGAKAKLSYLKSLGVN
AIELMPVQEFDGNDSWGYNPCFFFALDKAYGTDKMYKEFIDACHGEGIAVIFDVVYNHATGSHPFAKLYW
NSATNKTSAQNPWFNVDAPHPYSVFHDFNHESPLVRAFVKRNLEFLLKEYKIDGFRFDLTKGFTQKSSTE
STASAYDATRIAILKDYNSTVKTVNPSAMMILEHFCDNAEEKELANDGMYLWRNMNYAYCESAMGLPGNS
DFSGLYDTSMPMGSLVGFMESHDEERMSFKQIAYGNYTFKTSLADRMKQLKVNTAFFLTVPGPKMIWQFG
ELGYDYSIEENGRTGKKPVKWEYYDDASRKALYDTYAKLMTLRNANTELFDTSALFSWQVKGNTNWLNGR
FLTLEGGGKKLVVAGNFTNQAGSYTVTFPHTGTWYNYMTGESVSVSATNQTISIPAHEFKLFVDFQSN
```

This is the sequence of an enzyme (a-amylase) of the bacteria Bacteroides fragilis, I would like to know if an homologue of this sequence is present in the set of sequences of **Bacteroides51.faa** (Bacteroides sp. from cockroaches). The easy way is doing a BLAST search. But is BLAST installed?


```
[bio326-21-0@cn-3 work.dir.of.12314866]$ blast
bash: blast: command not found
```

It seems not to be installed as a default software.

### Modules and singularity

In order to use non default software (e.g BLAST, HMMER, SPADES), we need to load the corresponding module first.The Modules package is a tool that simplifies shell initialization and lets users easily modify their environment during a session using modulefiles. You can read more about this on the [Environment Modules](https://modules.readthedocs.io/en/latest/) website.

The following commands let us manage modules in our workflow:

```
module avail # available modules
module show # show modules info 
module list # list loaded modules
module load # loaded modules
module unload # unload loaded modules
module purge # unload all loaded modules
```

If we want to knwo what modules are already instaled in Orion we can use the following command:

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ module available

--------------------------------------------------------------------------- /usr/share/lmod/lmod/modulefiles/Core ----------------------------------------------------------------------------
   lmod    settarg

------------------------------------------------------------------------------------ /cluster/modules/all ------------------------------------------------------------------------------------
   AUGUSTUS/3.3.3-foss-2019b                                         METIS/5.1.0-GCCcore-8.3.0                           foss/2019a
   Anaconda3/5.3.0                                                   MUSCLE/3.8.31-foss-2018a                            foss/2019b                               (D)
   Autoconf/2.69-GCCcore-6.4.0                                       Mako/1.1.0-GCCcore-8.3.0                            freetype/2.9.1-GCCcore-8.2.0
   Autoconf/2.69-GCCcore-7.3.0                                       MariaDB/10.4.13-gompi-2019b                         freetype/2.10.1-GCCcore-8.3.0            (D)
   Autoconf/2.69-GCCcore-8.2.0                                       Mesa/19.1.7-GCCcore-8.3.0                           gams/30.2.0
   Autoconf/2.69-GCCcore-8.3.0                                       Meson/0.51.2-GCCcore-8.3.0-Python-3.7.4             gettext/0.19.8.1-GCCcore-8.2.0
   Autoconf/2.69-GCCcore-9.3.0                             (D)       Miniconda3/4.7.10                                   gettext/0.19.8.1
   Automake/1.15.1-GCCcore-6.4.0                                     MultiQC/1.9-foss-2019b-Python-3.7.4                 gettext/0.20.1-GCCcore-8.3.0
   Automake/1.16.1-GCCcore-7.3.0                                     NASM/2.14.02-GCCcore-8.3.0                          gettext/0.20.1-GCCcore-9.3.0
   Automake/1.16.1-GCCcore-8.2.0                                     NASM/2.14.02-GCCcore-9.3.0                   (D)    gettext/0.20.1                           (D)
   Automake/1.16.1-GCCcore-8.3.0                                     NLopt/2.6.1-GCCcore-8.3.0                           git/2.23.0-GCCcore-9.3.0-nodocs
   Automake/1.16.1-GCCcore-9.3.0                           (D)       NSPR/4.21-GCCcore-8.3.0                             gnuplot/5.2.8-GCCcore-8.3.0
   Autotools/20170619-GCCcore-6.4.0                                  NSS/3.45-GCCcore-8.3.0                              gompi/2018a
   Autotools/20180311-GCCcore-7.3.0                                  Ninja/1.9.0-GCCcore-8.3.0                           gompi/2018b
   Autotools/20180311-GCCcore-8.2.0                                  OpenBLAS/0.2.20-GCC-6.4.0-2.28                      gompi/2019a
   Autotools/20180311-GCCcore-8.3.0                                  OpenBLAS/0.3.1-GCC-7.3.0-2.30                       gompi/2019b
   Autotools/20180311-GCCcore-9.3.0                        (D)       OpenBLAS/0.3.5-GCC-8.2.0-2.31.1                     gompi/2020a                              (D)
   BCFtools/1.10.2-GCC-8.3.0                                         OpenBLAS/0.3.7-GCC-8.3.0                     (D)    gperf/3.1-GCCcore-8.2.0
   BCFtools/1.10.2-GCC-9.3.0                               (D)       OpenMPI/2.1.2-GCC-6.4.0-2.28                        gperf/3.1-GCCcore-8.3.0                  (D)
   BEDTools/2.27.1-foss-2018b                                        OpenMPI/3.1.1-GCC-7.3.0-2.30                        groff/1.22.4-GCCcore-9.3.0
   BEDTools/2.29.2-GCC-9.3.0                               (D)       OpenMPI/3.1.3-GCC-8.2.0-2.31.1                      help2man/1.47.4-GCCcore-6.4.0
   BLAST+/2.9.0-gompi-2019b                                          OpenMPI/3.1.4-GCC-8.3.0                             help2man/1.47.4-GCCcore-7.3.0
   BLAST+/2.10.1-gompi-2020a                               (D)       OpenMPI/4.0.3-GCC-9.3.0                      (D)    help2man/1.47.4
   BWA/0.7.17-GCC-9.3.0                                              PCRE/8.43-GCCcore-8.3.0                             help2man/1.47.7-GCCcore-8.2.0
```

There are two modules of BLAST 
* BLAST+/2.9.0-gompi-2019b  
* BLAST+/2.10.1-gompi-2020a

Lets **load** the newest **BLAST+/2.10.1-gompi-2020a**

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ module load BLAST+/2.10.1-gompi-2020a
```

And then try the command:

```
[bio326-21-0@cn-3 ~]$ blastp -h
Illegal instruction
```

As we can see in this node the blastp is not working. **Particularly in node cn-3 and cn-2, old nodes, module command shows multiple issues.** In that case we can use the singularity container. Singularity is a container platform. It allows you to create and run containers that package up pieces of software in a way that is portable and reproducible. Singularity can works in all nodes. For more information please read the [Introduction to Singularity](https://sylabs.io/guides/3.7/user-guide/introduction.html) Read the Docs.

Let's take a look into this singularity:

First purge all modules:

```
[bio326-21-0@cn-3 ~]$ module purge
 ```
 
This helps to not use the previous modules load (BLAST).

Then load the singularyti container:

```
[bio326-21-0@cn-3 ~]$ singularity exec /cvmfs/singularity.galaxyproject.org/b/l/blast:2.10.1--pl526he19e7b1_0 blastp -help
WARNING: Skipping mount /var/singularity/mnt/session/etc/resolv.conf [files]: /etc/resolv.conf doesn't exist in container
USAGE
  blastp [-h] [-help] [-import_search_strategy filename]
    [-export_search_strategy filename] [-task task_name] [-db database_name]
    [-dbsize num_letters] [-gilist filename] [-seqidlist filename]
    [-negative_gilist filename] [-negative_seqidlist filename]
    [-taxids taxids] [-negative_taxids taxids] [-taxidlist filename]
    [-negative_taxidlist filename] [-ipglist filename]
    [-negative_ipglist filename] [-entrez_query entrez_query]
    [-db_soft_mask filtering_algorithm] [-db_hard_mask filtering_algorithm]
    [-subject subject_input_file] [-subject_loc range] [-query input_file]
    [-out output_file] [-evalue evalue] [-word_size int_value]
    [-gapopen open_penalty] [-gapextend extend_penalty]
    [-qcov_hsp_perc float_value] [-max_hsps int_value]
    [-xdrop_ungap float_value] [-xdrop_gap float_value]
    [-xdrop_gap_final float_value] [-searchsp int_value] [-seg SEG_options]
    [-soft_masking soft_masking] [-matrix matrix_name]
    [-threshold float_value] [-culling_limit int_value]
    [-best_hit_overhang float_value] [-best_hit_score_edge float_value]
    [-subject_besthit] [-window_size int_value] [-lcase_masking]
    [-query_loc range] [-parse_deflines] [-outfmt format] [-show_gis]
    [-num_descriptions int_value] [-num_alignments int_value]
    [-line_length line_length] [-html] [-sorthits sort_hits]
    [-sorthsps sort_hsps] [-max_target_seqs num_sequences]
    [-num_threads int_value] [-ungapped] [-remote] [-comp_based_stats compo]
    [-use_sw_tback] [-version]

DESCRIPTION
Protein-Protein BLAST 2.10.1+

```

**The basic syntax for singularity is:  singularity [global options...] exec [exec options...] \<container> \<command>**

All the containers are alphatetically sorted.

Now we can run our BLAST search. First create a database using the Bacteroides51.faa file:

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ singularity exec /cvmfs/singularity.galaxyproject.org/b/l/blast:2.10.1--pl526he19e7b1_0 makeblastdb -dbtype prot -in Bacteroides51.faa 
WARNING: Skipping mount /var/singularity/mnt/session/etc/resolv.conf [files]: /etc/resolv.conf doesn't exist in container


Building a new DB, current time: 03/11/2021 20:48:39
New DB name:   /home/work/bio326-21-0/work.dir.of.12314866/Bacteroides51.faa
New DB title:  Bacteroides51.faa
Sequence type: Protein
Keep MBits: T
Maximum file size: 1000000000B
Adding sequences from FASTA; added 4630 sequences in 0.287924 seconds.
```

This create the index for BLAST

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ ls
amylase.Bgramini.fasta  Bacteroides51.faa.pdb  Bacteroides51.faa.pin  Bacteroides51.faa.psq  Bacteroides51.faa.pto
Bacteroides51.faa       Bacteroides51.faa.phr  Bacteroides51.faa.pot  Bacteroides51.faa.ptf
```

And now lets run the BLAST,as we want to search for protein in a protein database the command we need to use is BLASTP:

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ singularity exec /cvmfs/singularity.galaxyproject.org/b/l/blast:2.10.1--pl526he19e7b1_0 blastp -query amylase.Bgramini.fasta -db Bacteroides51.faa -dbsize 1000000000 -max_target_seqs 1 -outfmt 6 -num_threads $SLURM_CPUS_ON_NODE -out amylase.Bgramini.fasta.blastp.out
WARNING: Skipping mount /var/singularity/mnt/session/etc/resolv.conf [files]: /etc/resolv.conf doesn't exist in container
Warning: [blastp] Examining 5 or more matches is recommended
```

Take a look into the results:

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ more amylase.Bgramini.fasta.blastp.out 
WP_024997086.1	D0T87_RS12665	57.772	772	301	13	8	763	28	790	0.0	908
```

It seems the amylase of B. fragilis has a match wiht the D0T87_RS12665 sequence of Bacteroides51. We can corroborate this by looking into the fasta file annotation header by doing something like this:

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ grep D0T87_RS12665 Bacteroides51.faa
>D0T87_RS12665	alpha-amylase	WP_163175496.1
```

We found the amylase.

### Copy results to the $SCRATCH, remove work.directory and exit the job.

Finally we need to move the results back to our $SCRATCH partition. For this we can use the following sintax:

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ cp *fasta.blastp.out /mnt/SCRATCH/bio326-21-0
```

Then let's sure this is copy back

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ ls /mnt/SCRATCH/bio326-21-0
amylase.Bgramini.fasta.blastp.out
```

Finally, as the **$TMPDIR** is used for everyone a best practice is to delete all the temporary directories (i.e work.directory) from this location.

We can achive this by doing this:

* First go back to the main $TMPDI/$USER

```
[bio326-21-0@cn-3 work.dir.of.12314866]$ cd $TMPDIR/$USER
bio326-21-0@cn-3 bio326-21-0]$ ls
singularity  work.dir.of.12314866
```

Now we need to remove the work.dir.of 

```
[bio326-21-0@cn-3 bio326-21-0]$ rm -rf work.dir.of.12314866/
[bio326-21-0@cn-3 bio326-21-0]$ ls
singularity
```

Finally, we can logout of this node:

```
[bio326-21-0@cn-3 bio326-21-0]$ exit
exit
[bio326-21-0@login bio326-21-0]$
```

You can see now we return to the main **login bio326-21-0** node.

## Submit the same BLAST job but using a SLURM script.

Most of the time you do not use the interactive way for submiting jobs into the cluster. To submit jobs, you need to write all the instructions you want the computer execute. This is what an script is.

SLURM uses a [bash](https://www.gnu.org/software/bash/) (computer language) base script to read the instructions. The first lines, are reserved words that SLURM needs to read inorder to launch the program:

```
-p --partition <partition-name>       --pty <software-name/path>
--mem <memory>                        --gres <general-resources>
-n --ntasks <number of tasks>         -t --time <days-hours:minutes>
-N --nodes <number-of-nodes>          -A --account <account>
-c --cpus-per-task <number-of-cpus>   -L --licenses <license>
-w --nodelist <list-of-node-names>    -J --job-name <jobname>
```

We can indicate this options by using the **#SBATCH** word following by any of these flags.


```
#!/bin/bash

## Job name:
#SBATCH --job-name=Blast
#
## Wall time limit:
#SBATCH --time=00:00:00
#
## Other parameters:
#SBATCH --cpus-per-task 12
#SBATCH --mem=60G
#SBATCH --nodes 1
```

Let's use the following SLURM script to run the BLAST as we did in the interactive job.


```
#!/bin/bash

## Job name:
#SBATCH --job-name=MyFirstBlastp
#
## Wall time limit:
#SBATCH --time=00:10:00
#
## Other parameters:
#SBATCH --cpus-per-task 4
#SBATCH --mem=4G
#SBATCH --nodes 1


######Everything below this are the job instructions######

module purge #This remove any module loaded 

##Useful lines to know where and when the job starts

echo "I am running on:"
echo $SLURM_NODELIST   ##The node where the job is executed
echo "I am running with:"
echo $SLURM_CPUS_ON_NODE "cpus"  ###The number of cpus
echo "Today is:"
date

##Enter to the $TMPDIR/$USER

cd $TMPDIR/$USER

##Create a work directory and enter to it

mkdir work.dir.of.$SLURM_JOB_ID 
cd work.dir.of.$SLURM_JOB_ID

##Copy the fasta files form the $SCRATCH dir

echo "Copy data ..." ##Legend to know what the job is doing 

cp /mnt/SCRATCH/bio326-21/BestPracticesOrion_031221/*.fa* .

###Create a protein blast database ##

echo "Making database" ##Legend to know what the job is doing

singularity exec /cvmfs/singularity.galaxyproject.org/b/l/blast:2.10.1--pl526he19e7b1_0 makeblastdb \
-dbtype prot \
-in Bacteroides51.faa 

###Run BLASTp##

echo "Running BLAST" ##Legend to know what the job is doing

singularity exec /cvmfs/singularity.galaxyproject.org/b/l/blast:2.10.1--pl526he19e7b1_0 blastp \
-query amylase.Bgramini.fasta \
-db Bacteroides51.faa -dbsize 1000000000 \
-max_target_seqs 1 \
-outfmt 6 \
-num_threads $SLURM_CPUS_ON_NODE \
-out amylase.Bgramini.fasta.blastp.out

###Copy results to the $SCRATCH##

echo "Copy data to the $SCRATCH ..." ##Legend to know what the job is doing

cp *fasta.blastp.out /mnt/SCRATCH/bio326-21-0  ##Remember to change the name of your user

###Remove the work.directory

cd $TMPDIR/$USER

rm -rf work.dir.of.*

echo "I am done at" ##Legend to know what the job is doing
date
```

**You can copy this script to your $SCRATCH or $HOME directory from /mnt/SCRATCH/bio326-21/BestPracticesOrion_031221/myfisrt.blastp.SLURM.sh**

```
[bio326-21-0@login bio326-21-0]$ cp /mnt/SCRATCH/bio326-21/BestPracticesOrion_031221/myfisrt.blastp.SLURM.sh .
```

### Running the Job by sbatch

The way that SLURM takes the bash script and submit a job is by using the SLURM **sbatch** comand following by the script we want to run:

```
[bio326-21-0@login bio326-21-0]$ sbatch myfisrt.blastp.SLURM.sh 
Submitted batch job 12315560
```
The job now is in the **queue** to run.

## Monitoring the jobs by squeue

A user can monitorate the status of the Job by the command **squeue** 

```
[bio326-21-0@login bio326-21-0]$ squeue 
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
          12163974       gpu jupyterh     wubu CG      13:44      1 gn-0 
          12133418       gpu jupyterh tobibjor CG    8:00:24      1 gn-0 
          12133835       gpu jupyterh     idor CG    8:00:23      1 gn-0 
          12155551       gpu jupyterh  cbrekke CG    8:00:20      1 gn-0 
          12154693       gpu jupyterh  garethg CG    8:00:02      1 gn-0 
          12133882       gpu jupyterh martpali CG    8:00:22      1 gn-0 
          12132654       gpu jupyterh     tikn CG    8:00:22      1 gn-0 
          12315165       gpu jupyterh     wubu  R    1:28:18      1 gn-3 
          12137578       gpu msc_unet  maleneg  R 3-10:28:58      1 gn-0 
          12315185       gpu jupyterh martpali  R    1:25:06      1 gn-3 
          12314963       gpu head_nec ngochuyn  R    2:01:50      1 gn-3 
          12314280       gpu jupyterh domniman  R    4:03:34      1 gn-3 
          11998506       gpu   pepper michelmo  R 8-12:43:53      1 gn-0 
          12234490   hugemem princess mariesai  R 2-01:44:53      1 cn-14 
        12312723_1   hugemem AssAndBi     auve  R    8:33:36      1 cn-14 
          11970643   hugemem fun-trai    torfn  R 17-11:37:59      1 cn-1 
          12157565   hugemem maxbin2_   sivick  R 3-05:46:04      1 cn-14 
          11977182   hugemem  tess15k kristenl  R 14-12:18:10      1 cn-14 
          11977181   hugemem   tess7k kristenl  R 14-12:18:52      1 cn-14 
          11977180   hugemem  tess10k kristenl  R 14-12:20:05      1 cn-14 
          11970277   hugemem 2_alto10 kristenl  R 17-13:43:17      1 cn-1 
          12073389   hugemem Simon_Br kristenl  R 6-11:13:50      1 cn-3 
          12291673   hugemem funTrain     lagr  R 1-11:40:28      1 cn-2 
       12071454_33   hugemem      bwa     tikn  R    2:21:42      1 cn-2 
       12071454_32   hugemem      bwa     tikn  R    7:24:06      1 cn-1 
       12071454_31   hugemem      bwa     tikn  R    7:35:52      1 cn-2 
       12071454_30   hugemem      bwa     tikn  R   13:44:56      1 cn-2 
       12071454_29   hugemem      bwa     tikn  R   17:05:05      1 cn-2 
          11864977   hugemem     tldr volhpaul  R 31-09:08:07      1 cn-1 
          11824306   hugemem    CLUST mariansc  R 17-02:45:30      1 cn-2 
          11824320   hugemem    CLUST mariansc  R 17-02:45:30      1 cn-2 
          12314799   hugemem       du   thommo  R    2:28:30      1 cn-1 
          12312317   hugemem   qlogin kristenl  R    9:52:01      1 cn-14 
          11973160   hugemem   mcclin volhpaul  R 16-04:56:47      1 cn-3 
12071454_[34-200%5 hugemem,o      bwa     tikn PD       0:00      1 (JobArrayTaskLimit) 
          12309426 interacti jupyterh     andu  R   14:10:01      1 gn-1 
          12294220 interacti jupyterh     andu  R 1-11:04:58      1 gn-1 
          12311916 interacti jupyterh    hanso  R   11:08:16      1 gn-1 
          12311821 interacti jupyterh mariansc  R   11:29:35      1 gn-1 
          12311628     orion     DRAM     iaal PD       0:00      1 (Priority) 
          12311629     orion     DRAM     iaal PD       0:00      1 (Priority) 
          12311627     orion     DRAM     iaal PD       0:00      1 (Resources) 
          12311626     orion     DRAM     iaal  R       2:40      1 cn-8 
          12311625     orion     DRAM     iaal  R       4:29      1 cn-9 
          12311624     orion     DRAM     iaal  R       9:56      1 cn-10 
          12311623     orion     DRAM     iaal  R      12:33      1 cn-4 
          12311622     orion     DRAM     iaal  R      31:28      1 cn-7 
          12311621     orion     DRAM     iaal  R      37:31      1 cn-5 
          12311620     orion     DRAM     iaal  R      44:56      1 cn-7 
          12311619     orion     DRAM     iaal  R      54:33      1 cn-8 
          12311618     orion     DRAM     iaal  R      56:04      1 cn-9 
          12311617     orion     DRAM     iaal  R    1:08:39      1 cn-4 
          12311616     orion     DRAM     iaal  R    4:08:18      1 cn-13 
          12311615     orion     DRAM     iaal  R    9:25:33      1 cn-6 
          12311608     orion     DRAM     iaal  R   11:45:01      1 cn-10 
          12311604     orion     DRAM     iaal  R   11:45:05      1 cn-5 
          12311603     orion     DRAM     iaal  R   11:45:10      1 cn-6 
          12309659     orion map_pepp michelmo  R   12:48:29      1 cn-3 
          12315310     orion WGCNA_so mariansc  R    1:04:03      1 cn-3 
          12315313     orion WGCNA_so mariansc  R    1:03:33      1 cn-3 
          12315315     orion WGCNA_so mariansc  R    1:03:33      1 cn-3 
          12315316     orion WGCNA_so mariansc  R    1:03:33      1 cn-3 
          12315421     orion       du   thommo  R      36:03      1 cn-3 
          12315203  smallmem     UMAP martpali PD       0:00      1 (Nodes required for job are DOWN, DRAINED or reserved for jobs in higher priority partitions) 
    12073410_28199  smallmem  Provean    lirud  R       0:07      1 cn-12 
    12073410_28198  smallmem  Provean    lirud  R       0:18      1 cn-12 
    12073410_28197  smallmem  Provean    lirud  R       0:28      1 cn-12 
    12073410_28196  smallmem  Provean    lirud  R       0:41      1 cn-12 
    12073410_28195  smallmem  Provean    lirud  R       0:44      1 cn-12 
    12073410_28194  smallmem  Provean    lirud  R       1:04      1 cn-12 
    12073410_28193  smallmem  Provean    lirud  R       1:13      1 cn-12 
    12073410_28192  smallmem  Provean    lirud  R       1:16      1 cn-12 
    12073410_28191  smallmem  Provean    lirud  R       1:43      1 cn-12 
    12073410_28190  smallmem  Provean    lirud  R       1:45      1 cn-12 
    12073410_28188  smallmem  Provean    lirud  R       2:01      1 cn-12 
    12073410_28187  smallmem  Provean    lirud  R       2:08      1 cn-12 
    12073410_28186  smallmem  Provean    lirud  R       2:56      1 cn-12 
    12073410_28174  smallmem  Provean    lirud  R       4:41      1 cn-12 
    12073410_28173  smallmem  Provean    lirud  R       4:44      1 cn-12 
      12211272_119  smallmem HetDetSo     ehmo  R   21:49:35      1 cn-4 
      12211272_117  smallmem HetDetSo     ehmo  R   22:07:12      1 cn-8 
      12211272_116  smallmem HetDetSo     ehmo  R   22:07:54      1 cn-9 
      12211272_115  smallmem HetDetSo     ehmo  R   22:42:41      1 cn-8 
      12211272_114  smallmem HetDetSo     ehmo  R   23:19:00      1 cn-9 
      12211272_113  smallmem HetDetSo     ehmo  R   23:33:19      1 cn-10 
      12211272_112  smallmem HetDetSo     ehmo  R   23:33:40      1 cn-5 
      12211272_108  smallmem HetDetSo     ehmo  R 1-00:03:16      1 cn-9 
      12211272_107  smallmem HetDetSo     ehmo  R 1-00:14:15      1 cn-5 
      12211272_105  smallmem HetDetSo     ehmo  R 1-00:17:22      1 cn-10 
      12211272_104  smallmem HetDetSo     ehmo  R 1-00:21:25      1 cn-9 
      12211272_103  smallmem HetDetSo     ehmo  R 1-00:31:02      1 cn-4 
      12211272_102  smallmem HetDetSo     ehmo  R 1-00:38:03      1 cn-5 
          12074796  smallmem maxbin2_   sivick  R 6-09:00:04      1 cn-6 
12073410_[28200-34 smallmem,  Provean    lirud PD       0:00      1 (JobArrayTaskLimit) 
12312459_[552-1050 verysmall    FFull     eija PD       0:00      1 (Resources) 
```

This will show all the jobs, quite difficult to read. So instead we can indicate only to show our user jobs by adding the flag **-u** and the **$USER** variable:

```
[bio326-21-0@login bio326-21-0]$ squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
          12315560     orion MyFirstB bio326-2 PD       0:00      1 (Priority)
```

You can see the job is in the queue waiting for resources. PD means Priority resources. As soon as the SLURM finds resources for our job it will start running:

```
[bio326-21-0@login bio326-21-0]$ squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
          12315560     orion MyFirstB bio326-2  R       0:22      1 cn-8 
```

When the job starts it produces an out file **slurm-$JOB_ID.out**:

```[bio326-21-0@login bio326-21-0]$ ls -lrth
total 16K
-rw-rw-r-- 1 bio326-21-0 bio326-21-0   68 Mar 11 21:03 amylase.Bgramini.fasta.blastp.out.mod
-rw-rw-r-- 1 bio326-21-0 bio326-21-0 1.2K Mar 11 21:27 myfisrt.blastp.SLURM.sh
-rw-rw-r-- 1 bio326-21-0 bio326-21-0  611 Mar 11 21:29 slurm-12315560.out
```

We can check into this file:


```
[bio326-21-0@login bio326-21-0]$ more slurm-12315560.out 
I am running on:
cn-8
I am running with:
4 cpus
Today is:
Thu Mar 11 21:40:09 CET 2021
Copy data ...
Making database
WARNING: Skipping mount /var/singularity/mnt/session/etc/resolv.conf [files]: /etc/resolv.conf doesn't exist in container


Building a new DB, current time: 03/11/2021 21:40:10
New DB name:   /home/work/bio326-21-0/work.dir.of.12315623/Bacteroides51.faa
New DB title:  Bacteroides51.faa
Sequence type: Protein
Keep MBits: T
Maximum file size: 1000000000B
Adding sequences from FASTA; added 4630 sequences in 0.199221 seconds.


Running BLAST
WARNING: Skipping mount /var/singularity/mnt/session/etc/resolv.conf [files]: /etc/resolv.conf doesn't exist in container
Warning: [blastp] Examining 5 or more matches is recommended
Copy data to the /mnt/SCRATCH/bio326-21-0 ...
I am done at
Thu Mar 11 21:40:11 CET 2021
```

As you can see it seems the Job runs smoothly and produces the result:

```
[bio326-21-0@login bio326-21-0]$ ls
amylase.Bgramini.fasta.blastp.out
```

## Canceling Jobs 

Some times happens that we start a job but find some bugs in the script or simply we do not want to run for any reason. In this case there is a way to **cancel** jobs.
For this, we can use the **scancel** command following the **JOBID**

For example the following job 12315677:

```
[bio326-21-0@login bio326-21-0]$ squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
          12315677     orion MyFirstB bio326-2 PD       0:00      1 (Priority)
 ```

To cancel just type:

```
[bio326-21-0@login bio326-21-0]$ scancel 12315677
```

And then check for the status:

```
[bio326-21-0@login bio326-21-0]$ squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON) 
```

If no slurm.out file is created and no job is showing by sque, it meand the job has been canceled.

## Bulletpoints

* Do not use the login node to run process (e.g. BLAST, SPADES, HMMER).
* Do not use the $HOME partition for lagre files storage.
* Use interactive jobs for testing and debugging.
* Use the $TMPDIR for faster computation.
* Monitoring your jobs by squeue.
* Delete intermediate results from the $SCRATCH.
* Use sbatch command to submit you "final" jobs scripts.

## Enjoy the Orion Cluster...
