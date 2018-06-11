#!/bin/bash
#
#SBATCH --job-name=ring
#SBATCH --output=/chome/cluser/slurm-%J.txt
#SBATCH --ntasks=4

mpirun --allow-run-as-root --mca btl_tcp_if_include eth0 -mca btl tcp,self /usr/local/bin/ring 2>/dev/null
