FROM openjdk:8-jre
MAINTAINER Javier

ARG UID=1000
ARG GID=1000
ARG NIFI_VERSION=1.6.0
ARG MIRROR=https://archive.apache.org/dist

ENV NIFI_BASE_DIR /opt/nifi 
ENV NIFI_HOME=${NIFI_BASE_DIR}/nifi-${NIFI_VERSION} \
    NIFI_BINARY_URL=/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz

ADD sh/ /opt/nifi/scripts/


RUN groupadd -g ${GID} nifi || groupmod -n nifi `getent group ${GID} | cut -d: -f1` \
    && useradd --shell /bin/bash -u ${UID} -g ${GID} -m nifi \
    && mkdir -p ${NIFI_HOME}/conf/templates \
    && chown -R nifi:nifi ${NIFI_BASE_DIR} \
    && apt-get update \
    && apt-get install -y jq xmlstarlet

USER nifi


RUN curl -fSL ${MIRROR}/${NIFI_BINARY_URL} -o ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz \
    && echo "$(curl https://archive.apache.org/dist/${NIFI_BINARY_URL}.sha256) *${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz" | sha256sum -c - \
    && tar -xvzf ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_BASE_DIR} \
    && rm ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz \
    && chown -R nifi:nifi ${NIFI_HOME} \
    && mkdir ${NIFI_HOME}/facturas

ADD flow.xml.gz ${NIFI_HOME}/conf

ADD nifi-maki-nar-1.0-SNAPSHOT.nar ${NIFI_HOME}/lib


EXPOSE 8080 8443 10000 7070

WORKDIR ${NIFI_HOME}


CMD ${NIFI_BASE_DIR}/scripts/start.sh