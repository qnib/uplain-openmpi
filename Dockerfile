FROM qnib/uplain-init:v2018-01-02@sha256:032bf9b9b8756e25b0f03bf089fa86ed4f021ca72fe9fe1bd2e8f3686b2938a8

RUN apt-get update
RUN apt-get install -y gcc wget make bzip2 g++ openmpi-bin openmpi-common libopenmpi-dev unzip vim

## Group stuff
RUN groupadd -g 1002 cluser \
 && useradd -d /chome/cluser --uid 1002 --gid 1002 cluser
RUN echo "# go-wharfie: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo go-wharfie --regex '.*_x86' --limit 1)" \
 && wget -qO /usr/local/bin/go-wharfie "$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo go-wharfie --regex '.*_x86' --limit 1)" \
 && chmod +x /usr/local/bin/go-wharfie
CMD ["tail","-f","/dev/null"]
RUN mkdir -p ~cluser/ \
 && echo 'mpirun -np 2 -mca plm_rsh_agent /usr/local/bin/go-wharfie --host node0,node1 /usr/local/bin/hello' >> ~cluser/.bash_history \
 && chown cluser: ~cluser/.bash_history
 ## install docker-ce
 RUN apt-get install -y \
       apt-transport-https \
       ca-certificates \
       curl \
       software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && apt-get update \
  && apt-get install -y docker-ce
COPY src/hello_mpi.c src/ring.c /usr/local/src/mpi/
RUN mpicc -o /usr/local/bin/hello /usr/local/src/mpi/hello_mpi.c \
  && mpicc -o /usr/local/bin/ring /usr/local/src/mpi/ring.c
