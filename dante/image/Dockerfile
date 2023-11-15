FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y dante-server && \
    rm -rf /var/lib/apt/lists/*
ADD _ /
CMD ["/init.sh"]

