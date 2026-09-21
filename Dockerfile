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
FROM docker.io/icinga/icingaweb2:latest@sha256:3965f1846078783ec5d149a62b17477e119d4f67f3c031e8cc237e44ee35e4e5

COPY --from=downloader /monitoring /usr/share/icingaweb2/modules/monitoring
COPY --from=downloader /grafana /usr/share/icingaweb2/modules/grafana

