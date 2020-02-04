FROM alpine AS builder
RUN mkdir /scripts
RUN apk add --no-cache curl && curl -sSL https://git.io/get-mo -o /scripts/mo && chmod +x /scripts/mo

FROM alpine
LABEL AUTHOR="MajorcaDevs"

RUN apk add --no-cache icecast bash

ENV IC_ADMIN="icemaster@localhost" \
IC_ADMIN_PASSWORD="hackme" \
IC_ADMIN_USER="admin" \
IC_CLIENT_TIMEOUT="30" \
IC_HEADER_TIMEOUT="15" \
IC_HOSTNAME="localhost" \
IC_LISTEN_BIND_ADDRESS="0.0.0.0" \
IC_LISTEN_MOUNT="stream" \
IC_LISTEN_PORT="8000" \
IC_LOCATION="Earth" \
IC_MAX_CLIENTS="100" \
IC_MAX_SOURCES="4" \
IC_SOURCE_PASSWORD="hackme" \
IC_SOURCE_TIMEOUT="10" \
RADIO_MOUNT_NAME="stream" \
RADIO_NAME="Dockerized Icecast" \
RADIO_WEBSITE="https://www.github.com/majorcadevs/docker-icecast" \
GENRE="various" \
GENERATE_TEMPLATE="False" \
IC_QUEUE_SIZE="524288" \
IC_BURST_SIZE="65535" \
IC_MASTER_RELAY_PASSWORD="hackme" \
ENABLE_RELAY="False" \
IC_RELAY_MASTER_SERVER="changeme" \
IC_RELAY_MASTER_PORT="8000" \
IC_RELAY_MASTER_UPDATE_INTERVAL="120" \
IC_RELAY_MASTER_PASSWORD="hackme" \
IC_DEBUG_LOGLEVEL="3" \
IC_LOGSIZE="10000"

COPY icecast/mime.types /etc/mime.types
COPY --from=builder /scripts/mo /usr/bin/mo
COPY icecast/custom-template.xml /etc/custom.xml
COPY content/init.sh /init.sh

EXPOSE 8000

ENTRYPOINT [ "/init.sh" ]
CMD ["run-icecast"]