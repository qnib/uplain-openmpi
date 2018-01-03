FROM qnib/uplain-init:v2018-01-02@sha256:032bf9b9b8756e25b0f03bf089fa86ed4f021ca72fe9fe1bd2e8f3686b2938a8

RUN apt-get update
RUN apt-get install -y gcc wget make bzip2 g++ openmpi-bin openmpi-common libopenmpi-dev

## Group stuff
RUN groupadd -g 1002 cluser \
 && useradd -d /chome/cluser -M --uid 1002 --gid 1002 cluser
COPY src/hello_mpi.c /usr/local/src/mpi/
RUN mpicc -o /usr/local/bin/hello /usr/local/src/mpi/hello_mpi.c
RUN echo "# go-wharfie: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo go-wharfie --regex '.*_x86' --limit 1)" \
 && wget -qO /usr/local/bin/go-wharfie "$(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo go-wharfie --regex '.*_x86' --limit 1)" \
 && chmod +x /usr/local/bin/go-wharfie
CMD ["tail","-f","/dev/null"]
