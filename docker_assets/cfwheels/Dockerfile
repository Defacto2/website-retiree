# /docker_assets/cfwheels/Dockerfile
# https://hub.docker.com/_/alpine
FROM alpine:latest
RUN apk add --no-cache git

RUN mkdir --parents /opt/cfwheels
WORKDIR /opt/cfwheels
RUN git clone --quiet -c advice.detachedHead=false --branch v2.4.0 https://github.com/cfwheels/cfwheels.git .

# keep alive
# ENTRYPOINT ["tail", "-f", "/dev/null"]