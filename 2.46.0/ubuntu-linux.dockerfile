# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set the maintainer label
LABEL maintainer="eliyaser3121@gmail.com"

# Install system packages.
RUN set -x \
  && apt update \
  && apt upgrade -y \
  && apt install -y wget vim net-tools gcc make tar git unzip sysstat tree netcat nmap logrotate cron

# Install Supervisor.
RUN set -x \
  && apt install -y supervisor \
  && history -c

# Set the Prometheus version
ENV PROMETHEUS_VERSION=2.46.0

# Create a directory for Prometheus
RUN mkdir -p /etc/prometheus /var/lib/prometheus

# Download and install Prometheus
RUN cd /tmp && \
    wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    tar -xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    cd prometheus-${PROMETHEUS_VERSION}.linux-amd64 && \
    mv prometheus /usr/local/bin/ && \
    mv promtool /usr/local/bin/ && \
    mv prometheus.yml /etc/prometheus/ && \
    mv consoles /etc/prometheus/ && \
    mv console_libraries /etc/prometheus/ && \
    rm -rf /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64

# Expose Prometheus port
EXPOSE 9090

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/prometheus", "--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/var/lib/prometheus"]

# Add a healthcheck
HEALTHCHECK CMD wget --spider http://localhost:9090/ || exit 1
