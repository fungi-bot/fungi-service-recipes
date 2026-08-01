---
fungi: service/v1
id: ubuntu-desktop-web

run:
  provider: docker
  source:
    image: lscr.io/linuxserver/webtop:ubuntu-xfce@sha256:6a62904004f685b3a3eaeecfe022939c9349628c728f698f792ed4670009f8c6
  env:
    PUID: "1000"
    PGID: "1000"
    TZ: Etc/UTC
    START_DOCKER: "false"
  mounts:
    - from: $fungi.service.data
      to: /config
    - from: $fungi.workspace
      to: /workspace

publish:
  desktop:
    tcp:
      port: 3000
    client:
      kind: web
      path: /
---

# Ubuntu desktop environment

Runs the LinuxServer Webtop Ubuntu XFCE desktop through a browser. The desktop
home directory is persisted in private service data at `/config`, and the
Fungi workspace is available at `/workspace`.

Webtop application authentication is intentionally disabled. Access is
delegated to the trusted Fungi network, following the same model as the
`code-server` recipe.

## Shared memory

LinuxServer recommends 1 GiB of shared memory for desktop workloads. The
current Fungi Docker service schema does not expose Docker's `--shm-size`
setting, so this recipe inherits the Docker daemon default, which is commonly
64 MiB. This recipe remains experimental until common browser and desktop
workloads have been verified under that limit.

## Safety

The browser desktop includes a terminal with passwordless sudo inside the
isolated container. The container can read and write the full Fungi workspace
mounted at `/workspace`. Fungi does not grant privileged mode, host Docker
socket access, or host device access to this recipe.

## Source

- Upstream project: <https://github.com/linuxserver/docker-webtop>
- Container image: `lscr.io/linuxserver/webtop:ubuntu-xfce@sha256:6a62904004f685b3a3eaeecfe022939c9349628c728f698f792ed4670009f8c6`
