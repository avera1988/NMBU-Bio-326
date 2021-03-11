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

cp *fasta.blastp.out /mnt/SCRATCH/bio326-21-0

###Remove the work.directory

cd $TMPDIR/$USER

rm -rf work.dir.of.*

echo "I am done at" ##Legend to know what the job is doing
date
