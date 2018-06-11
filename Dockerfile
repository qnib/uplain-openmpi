ARG FROM_IMG_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME="uplain-slurm"
ARG FROM_IMG_TAG="latest"
ARG FROM_IMG_HASH=""
FROM ${FROM_IMG_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

ARG OMPI_VER=3.1
ARG OMPI_PATCH_VER=0
ARG OMPI_URL=https://www.open-mpi.org/software/ompi

RUN apt-get update \
&& apt-get install -y libhwloc-dev libhwloc-common
RUN mkdir -p /usr/local/src/openmpi \
 && wget -qO - ${OMPI_URL}/v${OMPI_VER}/downloads/openmpi-${OMPI_VER}.${OMPI_PATCH_VER}.tar.bz2|tar xfj - --strip-components=1 -C /usr/local/src/openmpi \
 && cd /usr/local/src/openmpi \
 && ./configure --prefix=/usr/ --with-pmi --with-slurm --with-hwloc \
 && make -j4 \
 && make install \
 && rm -rf /usr/local/src/openmpi

## Group stuff
RUN mkdir -p /chome  \
 && groupadd -g 1002 cluser \
 && useradd -d /chome/cluser -M --uid 1002 --gid 1002 cluser
COPY src/hello_mpi.c src/ring.c /usr/local/src/mpi/
RUN mpicc -o /usr/local/bin/hello /usr/local/src/mpi/hello_mpi.c
RUN mpicc -o /usr/local/bin/ring /usr/local/src/mpi/ring.c
COPY slurm/job-ring.sh slurm/job-hello.sh /opt/qnib/slurm/
