# Copyright (c) 2022, Bull SAS.
# All rights reserved.
# Load jarvice_mpi image as JARVICE_MPI
FROM us-docker.pkg.dev/jarvice/images/jarvice_mpi:4.1 as JARVICE_MPI

FROM ubuntu:jammy
LABEL maintainer="Bull SAS" \
      license="GNU GPL2"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20200205.1000}
ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_BRANCH
ENV GIT_BRANCH ${GIT_BRANCH:-master}

# Grab jarvice_mpi from JARVICE_MPI
COPY --from=JARVICE_MPI /opt/JARVICE /opt/JARVICE

WORKDIR /tmp

# Install image-common tools and desktop
RUN if [ $(( $(date "+%s") -  $(date -r /var/cache/apt "+%s"))) -gt 28800 ]; then apt-get -y update; else echo "apt-get useless"; fi && \
    apt-get -y install wget curl software-properties-common && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/$GIT_BRANCH/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop --image-common-branch $GIT_BRANCH
		
COPY scripts_install /root/scripts_install
COPY TAR/*.tar.gz /LOCAL/code_saturne/TAR/ 
WORKDIR /root/scripts_install
RUN bash /root/scripts_install/install_saturne.sh

COPY scripts /usr/local/scripts

COPY NAE/AppDef.json /etc/NAE/AppDef.json
COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/code_saturne-logo-135x135.png /etc/NAE/code_saturne-logo-135x135.png

RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22
# for standalone use
EXPOSE 5901
EXPOSE 443


