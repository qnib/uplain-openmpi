FROM qnib/uplain-init:17.04

RUN apt-get update \
 && apt-get install -y gcc wget make bzip2 g++

## pmix
ARG PMI_VER=v2.1

RUN apt-get install -y git autoconf libtool
RUN git clone https://github.com/pmix/pmix.git /usr/local/src/pmix/pmix \
 && cd /usr/local/src/pmix/pmix \
 && git checkout ${PMI_VER}
RUN apt-get install -y libevent-dev flex \
 && cd /usr/local/src/pmix/pmix \
 && ./autogen.sh \
 && ./configure --prefix=/usr/ \
 && make -j4 \
 && make install

## SLURM
RUN apt-get install -y libgtk2.0-dev libmunge-dev \
 && useradd -s /bin/false slurm \
 && wget -qO - https://download.schedmd.com/slurm/slurm-17.11.0-0rc3.tar.bz2 |tar xfj - -C /usr/local/src/ \
 && cd /usr/local/src/slurm-17.11.0-0rc3 \
 && ./autogen.sh \
 && ./configure --prefix=/usr/ \
 && make -j4 \
 && make install


ARG OMPI_VER=3.0
ARG OMPI_PATCH_VER=0
ARG OMPI_URL=https://www.open-mpi.org/software/ompi
RUN mkdir -p /usr/local/src/ \
 && wget -qO - ${OMPI_URL}/v${OMPI_VER}/downloads/openmpi-${OMPI_VER}.${OMPI_PATCH_VER}.tar.bz2|tar xfj - -C /usr/local/src/ \
 && echo
RUN echo \
 && cd /usr/local/src/openmpi-${OMPI_VER}.${OMPI_PATCH_VER} \
 && ./configure --prefix=/usr/ --with-pmi --with-slurm \
 && make -j4 \
 && make install

## Group stuff
RUN groupadd -g 1002 cluser \
 && useradd -d /chome/cluser -M --uid 1002 --gid 1002 cluser
