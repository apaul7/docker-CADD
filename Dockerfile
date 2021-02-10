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
ENV CADD_COMMIT "7502f479d70d611bde31cbff77eb7ea855ea19b3"
RUN git clone https://github.com/kircherlab/CADD-scripts.git && \
  cd CADD-scripts && \
  git checkout $CADD_COMMIT

WORKDIR /git/CADD-scripts
RUN snakemake test/input.tsv.gz \
  --use-conda --conda-create-envs-only \
  --conda-prefix envs \
  --configfile config/config_GRCh38_v1.6.yml \
  --snakefile Snakefile \
  --cores 1

RUN rm -rf /git/CADD-scripts/data && chmod +777 /git/CADD-scripts/.
WORKDIR /
