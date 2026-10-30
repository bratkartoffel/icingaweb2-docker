# multi-stage, downloader image
FROM alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS downloader

# 2.12.6
ARG MONITORING_COMMIT_ID=b1ceb1bd5cfd79363b4f95aa73f97d3757f6e349
ARG GRAFANA_VERSION=v3.1.3

RUN set -ex \
	&& wget -O /tmp/monitoring.tgz https://github.com/Icinga/icingaweb2-module-monitoring/archive/${MONITORING_COMMIT_ID}.tar.gz \
	&& mkdir -v /monitoring \
	&& cd /monitoring \
	&& tar -xz --strip-components=1 -f /tmp/monitoring.tgz

RUN set -ex \
	&& wget -O /tmp/grafana.tgz https://github.com/NETWAYS/icingaweb2-module-grafana/archive/refs/tags/${GRAFANA_VERSION}.tar.gz \
	&& mkdir -v /grafana \
	&& cd /grafana \
	&& tar -xz --strip-components=1 -f /tmp/grafana.tgz

# build image
FROM docker.io/icinga/icingaweb2:latest@sha256:b7f5b0e81177de9de77c7e4ec5e93235f45c9b819bd83535cf620e313741b3fd

COPY --from=downloader /monitoring /usr/share/icingaweb2/modules/monitoring
COPY --from=downloader /grafana /usr/share/icingaweb2/modules/grafana

