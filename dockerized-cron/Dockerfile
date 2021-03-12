FROM debian:buster-slim

LABEL version="1.0"
LABEL maintainer="opendicom"

# Instalo software necesario
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        lsb-release \
        mariadb-client \
        mylvmbackup \
        cron \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/*

# Carpetas que serán utilizadas para los respaldos
# scripts -> para almacenar los scripts de respaldo
# backups-dst -> Destino de los respaldos
# backups-src -> Origen de los respaldos

RUN mkdir /scripts /data_dst /data_src
RUN touch /crontab_file

CMD crontab /crontab_file && /usr/sbin/cron -f