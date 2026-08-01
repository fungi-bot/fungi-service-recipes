# Ubuntu development SSH image

This image extends Microsoft's Ubuntu 24.04 Dev Container base with an OpenSSH
server and common command-line development tools. It is built for the
`ubuntu-dev-ssh` Fungi recipe.

The image renames the base image's UID/GID 1000 `vscode` account to `dev` so
the development user retains the base image's shell and sudo configuration.

## Runtime contract

- SSH listens on TCP port `2222`.
- `SSH_USER` must be `dev`.
- `SSH_PASSWORD` sets the login password and defaults to `fungi`.
- `/data` stores the persistent home directory, authorized keys, and SSH host
  keys.
- `/workspace` is reserved for the Fungi workspace mount.

The entrypoint initializes persistent state and then runs `sshd` in the
foreground.

The image workflow publishes `ghcr.io/<repository-owner>/fungi-ubuntu-dev`.
After the first upstream build, the `enbop/fungi-ubuntu-dev` GHCR package must
be made public so released recipes can pull it without registry credentials.

## Local build

```bash
docker build -t fungi-ubuntu-dev:test images/ubuntu-dev-ssh
```
