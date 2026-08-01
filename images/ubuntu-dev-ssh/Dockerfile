# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:ubuntu24.04@sha256:cfd5dd36c0d0d88de015aad5aa4f4b94e76d9f658a1e3055b27fd7d0fd1d84a6

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        less \
        nano \
        openssh-client \
        openssh-server \
        python3 \
        python3-pip \
        python3-venv \
        rsync \
        sudo \
        tmux \
        unzip \
        vim \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/ssh/ssh_host_*

RUN install -d /usr/local/share/fungi/home-template \
    && cp -a /home/vscode/. /usr/local/share/fungi/home-template/ \
    && groupmod --new-name dev vscode \
    && usermod --login dev --home /data/home/dev --shell /bin/bash vscode \
    && rm -f /etc/sudoers.d/vscode \
    && printf '%s\n' 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && install -d /workspace

COPY entrypoint.sh /usr/local/bin/fungi-ubuntu-dev-entrypoint
COPY sshd_config /etc/ssh/sshd_config

RUN chmod 0755 /usr/local/bin/fungi-ubuntu-dev-entrypoint

ENV SSH_USER=dev \
    SSH_PASSWORD=fungi

WORKDIR /workspace

EXPOSE 2222

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/fungi-ubuntu-dev-entrypoint"]
