FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y tor python3 netcat && \
    rm -rf /var/lib/apt/lists/*
ADD _ /
EXPOSE 9050
CMD ["/init.sh"]

