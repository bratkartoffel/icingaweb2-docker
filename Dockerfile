# multi-stage, downloader image
FROM alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS downloader

# 2.12.6
ARG MONITORING_COMMIT_ID=b1ceb1bd5cfd79363b4f95aa73f97d3757f6e349

RUN set -ex \
	&& wget -O /tmp/monitoring.tgz https://github.com/Icinga/icingaweb2-module-monitoring/archive/${MONITORING_COMMIT_ID}.tar.gz \
	&& mkdir -v /monitoring \
	&& cd /monitoring \
	&& tar -xz --strip-components=1 -f /tmp/monitoring.tgz

# build image
FROM docker.io/icinga/icingaweb2:latest@sha256:13729b546b8fac4caeacf71bde75cd748d8b9f8efd68682f67aff5673998ab4b

COPY --from=downloader /monitoring /usr/share/icingaweb2/modules/monitoring

