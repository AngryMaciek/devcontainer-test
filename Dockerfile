##### BASE IMAGE #####
FROM bitnami/minideb:bullseye

##### INSTALL SYSTEM-LEVEL DEPENDENCIES #####
RUN install_packages curl ca-certificates gnupg2 git gosu

##### DEFINE BUILD VARIABLES #####
ARG MAMBADIR="/mambaforge"
ARG CONDABINDIR="/mambaforge/bin"
ARG MAMBAURL="https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh"

##### SET ENVIROMENTAL VARIABLES #####
ENV LANG C.UTF-8

##### INSTALL MAMBAFORGE #####
RUN /bin/bash -c "curl -L ${MAMBAURL} > mambaforge.sh \
    && bash mambaforge.sh -b -p ${MAMBADIR} \
    && ${CONDABINDIR}/conda config --system --set channel_priority strict \
    && source ${CONDABINDIR}/activate \
    && conda init bash \
    && rm -f mambaforge.sh"

##### BUILD CONDA ENV #####
COPY dev/environment.yml .
COPY dev/requirements.txt .
RUN /bin/bash -c "${CONDABINDIR}/mamba env create --file environment.yml \
  && ${CONDABINDIR}/conda clean --all --yes \
  && rm -f environment.yml requirements.txt"

CMD ["/bin/bash"]
