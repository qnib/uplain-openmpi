FROM qnib/uplain-slurm:2018-06-10_08-59

ARG OMPI_VER=3.1
ARG OMPI_PATCH_VER=0
ARG OMPI_URL=https://www.open-mpi.org/software/ompi

RUN apt-get update \
&& apt-get install -y libhwloc-dev libhwloc-common
RUN mkdir -p /usr/local/src/openmpi \
 && wget -qO - ${OMPI_URL}/v${OMPI_VER}/downloads/openmpi-${OMPI_VER}.${OMPI_PATCH_VER}.tar.bz2|tar xfj - --strip-components=1 -C /usr/local/src/openmpi
RUN cd /usr/local/src/openmpi \
 && ./configure --prefix=/usr/ --with-pmi --with-slurm --with-hwloc \
 && make -j4 \
 && make install

## Group stuff
RUN groupadd -g 1002 cluser \
 && useradd -d /chome/cluser -M --uid 1002 --gid 1002 cluser
COPY src/hello_mpi.c src/ring.c /usr/local/src/mpi/
RUN mpicc -o /usr/local/bin/hello /usr/local/src/mpi/hello_mpi.c
RUN mpicc -o /usr/local/bin/ring /usr/local/src/mpi/ring.c
COPY slurm/job-ring.sh slurm/job-hello.sh /opt/qnib/slurm/
VOLUME ["/chome"]
RUN useradd --create-home -d /chome/cluser --password $(openssl passwd cluser) cluser \
 && mkdir -p /chome/cluser/.ssh \
 && chown -R cluser: /chome/cluser \
 && chmod 700 /chome/cluser/.ssh \
 &&  ssh-keygen -f /chome/cluser/.ssh/id_rsa -N '' \
 && cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
