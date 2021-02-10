FROM continuumio/miniconda3:4.9.2
MAINTAINER Alexander Paul <alex.paul@.wustl.edu>

LABEL \
  description="Image for running CADD scoring scripts, https://github.com/kircherlab/CADD-scripts"

RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  libz-dev \
  tabix \
  vim

RUN conda install -c conda-forge -c bioconda \
  snakemake

WORKDIR /git
ENV CADD_VERSION 1.6
RUN wget https://github.com/kircherlab/CADD-scripts/archive/CADD${CADD_VERSION}.tar.gz && \
  tar -zxf CADD${CADD_VERSION}.tar.gz && \
  mv CADD-scripts-CADD1.6 CADD-scripts && \
  rm CADD${CADD_VERSION}.tar.gz 

WORKDIR /git/CADD-scripts
RUN snakemake test/input.tsv.gz \
  --use-conda --conda-create-envs-only \
  --conda-prefix envs \
  --configfile config/config_GRCh38_v1.6.yml \
  --snakefile Snakefile \
  --cores 1

RUN rm -rf /git/CADD-scripts/data && chmod +777 /git/CADD-scripts/.
WORKDIR /
