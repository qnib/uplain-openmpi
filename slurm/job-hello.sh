#!/bin/bash
#
#SBATCH --job-name=hello
#SBATCH --output=/chome/slurm-%J.txt
#SBATCH --ntasks=4

mpirun --allow-run-as-root --mca btl_tcp_if_include eth0 -mca btl tcp,self /usr/local/bin/hello 2>/dev/null
