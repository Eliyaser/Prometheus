# How Prometheus Monitoring works | Prometheus Architecture explained

URL:https://youtu.be/h4Sl21AKiDg?si=GjAxyuELKLsP1A_s

# Prometheus Docker Setup

This repository contains a Dockerfile to create a Docker image for Prometheus using an Ubuntu base image.

## Dockerfile Explanation

The provided Dockerfile performs the following steps:

1. **Base Image**: Uses the official Ubuntu base image.
2. **Maintainer**: Sets a maintainer label.
3. **Update and Install Packages**: Updates the package list and installs necessary packages (wget, tar, gzip).
4. **Prometheus Version**: Sets the Prometheus version to be installed.
5. **Create Directories**: Creates directories for Prometheus configuration and data.
6. **Download and Install Prometheus**: Downloads Prometheus, extracts it, and moves the binaries and configuration files to the appropriate locations.
7. **Expose Port**: Exposes port 9090, which is used by Prometheus.
8. **Entrypoint**: Sets the entrypoint to run Prometheus with the specified configuration file and storage path.
9. **Healthcheck**: Adds a healthcheck to ensure Prometheus is running.

## Building the Docker Image

To build the Docker image, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/Eliyaser/prometheus-docker-setup.git
    sudo chown -R $USER:$USER /opt/kickstart-docker
    cd /opt
    ```

2. Build the Docker image:
    ```sh
    docker build -t my-prometheus-image .
    sudo docker image build -t my-prometheus-image:v2.46.0 -f prometheus-docker-setup/2.46.0/ubuntu-linux.dockerfile prometheus-docker-setup/2.46.0/context
    ```

## Running the Docker Container

To run a container from the built image:

1. Run the container:
    ```sh
    docker run -d -p 9090:9090 --name my-prometheus-container my-prometheus-image
    ```

2. Verify that Prometheus is running by opening your browser and navigating to:
    ```
    http://localhost:9090
    ```

## Dockerfile

Here is the Dockerfile used in this repository:

```Dockerfile
# Use the official Ubuntu base image
FROM ubuntu:latest

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y wget tar gzip && \
    apt-get clean

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
