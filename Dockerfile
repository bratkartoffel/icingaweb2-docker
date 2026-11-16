# multi-stage, downloader image
FROM alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS downloader

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
FROM docker.io/icinga/icingaweb2:latest@sha256:8a17859a99ad1c085ece7c43b734ca4ff5a53912ca229a34048b46a60a212254

COPY --from=downloader /monitoring /usr/share/icingaweb2/modules/monitoring
COPY --from=downloader /grafana /usr/share/icingaweb2/modules/grafana

