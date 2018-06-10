#!/bin/bash
#
#SBATCH --job-name=ring-test
#SBATCH --ntasks=4


mpirun --mca btl_tcp_if_include eth0 -mca btl tcp,self /usr/local/bin/hello
