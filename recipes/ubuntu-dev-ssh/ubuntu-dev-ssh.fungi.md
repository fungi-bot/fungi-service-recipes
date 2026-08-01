---
fungi: service/v1
id: ubuntu-dev-ssh

run:
  provider: docker
  source:
    image: ghcr.io/enbop/fungi-ubuntu-dev:24.04-0.1.0
  env:
    SSH_USER: dev
    SSH_PASSWORD: fungi
  mounts:
    - from: $fungi.service.data
      to: /data
    - from: $fungi.workspace
      to: /workspace

publish:
  ssh:
    tcp:
      port: 2222
    client:
      kind: ssh
---

# Ubuntu development environment

Runs an Ubuntu 24.04 development container with OpenSSH, Git, Python 3, common
shell tools, and a native build toolchain.

The Fungi workspace is available at `/workspace`. The development user's home
directory, authorized keys, and SSH host keys are persisted in private service
data.

## Login

- Username: `dev`
- Password: `fungi`

After the first password login, users may install their normal public key with
`ssh-copy-id` or by appending it to `~/.ssh/authorized_keys`.

## Safety

This recipe intentionally uses a fixed, simple password and grants `dev`
passwordless sudo inside the isolated container. Apply it only where the
service is reachable exclusively by trusted Fungi devices. The container can
read and write the full Fungi workspace mounted at `/workspace`.

## Source

- Image source: <https://github.com/enbop/fungi-service-recipes/tree/main/images/ubuntu-dev-ssh>
- Base image: <https://github.com/devcontainers/images/tree/main/src/base-ubuntu>
