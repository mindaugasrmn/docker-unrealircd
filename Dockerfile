FROM debian:latest
MAINTAINER Mindaugas Ramanauskas mindaugas.r@me.com

ARG TAR_PATH_URI=https://www.unrealircd.org/downloads
ARG UIRCD_VERSION=4.0.7
ARG IRCD_USERNAME=ircd
ARG IRCD_GROUP=ircd


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential libssl-dev wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /home/${IRCD_USERNAME}
RUN groupadd -r ${IRCD_GROUP} \
    && useradd -s /bin/bash -d /home/${IRCD_USERNAME} -g ${IRCD_GROUP} ${IRCD_USERNAME} \
&& chown ${IRCD_USERNAME}:${IRCD_GROUP} /home/${IRCD_USERNAME}


USER ${IRCD_USERNAME}
WORKDIR /home/${IRCD_USERNAME}/

RUN wget --no-check-certificate --trust-server-names ${TAR_PATH_URI}/unrealircd-${UIRCD_VERSION}.tar.gz \
    && tar -xzf unrealircd-${UIRCD_VERSION}.tar.gz \
    && rm -rf unrealircd-${UIRCD_VERSION}.tar.gz
RUN chown -R ${IRCD_USERNAME}:${IRCD_GROUP} unrealircd-${UIRCD_VERSION}

WORKDIR /home/${IRCD_USERNAME}/unrealircd-${UIRCD_VERSION}

RUN ./configure --with-showlistmodes --enable-ssl --with-bindir=/home/ircd/unrealircd/bin --with-datadir=/home/ircd/unrealircd/data --with-pidfile=/home/ircd/unrealircd/data/unrealircd.pid --with-confdir=/home/ircd/unrealircd/conf --with-modulesdir=/home/ircd/unrealircd/modules --with-logdir=/home/ircd/unrealircd/logs --with-cachedir=/home/ircd/unrealircd/cache --with-docdir=/home/ircd/unrealircd/doc --with-tmpdir=/home/ircd/unrealircd/tmp --with-scriptdir=/home/ircd/unrealircd --with-nick-history=1000000 --with-sendq=3000000 --with-permissions=0600 --with-fd-setsize=1024 --enable-dynamic-linking
RUN make
RUN make install


