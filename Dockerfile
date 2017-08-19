FROM qnib/uplain-init

RUN apt-get update \
 && apt-get install -y openmpi-bin libopenmpi-dev openssh-client
RUN useradd -u 1000 user
COPY src/hello_mpi.c /usr/local/src/
RUN mkdir -p /usr/local/bin/ \
 && mpicc -o /usr/local/bin/hello_mpi /usr/local/src/hello_mpi.c 
USER user
