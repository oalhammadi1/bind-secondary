FROM docker.io/library/ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y --no-install-recommends bind9 bind9-utils dnsutils \
 && rm -rf /var/lib/apt/lists/*
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
RUN mkdir -p /var/cache/bind /var/log/named \
 && chown -R bind:bind /var/cache/bind /var/log/named
EXPOSE 53/tcp 53/udp
CMD ["/usr/sbin/named", "-g", "-u", "bind"]
