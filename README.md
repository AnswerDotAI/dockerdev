# linux

A lightweight local Linux dev environment using Docker -- a simple alternative to WSL for macOS (or any Docker host).

Gives you a full Ubuntu box with dev tools, Python, uv, Rust, C/C++ toolchain, and common CLI utilities, with your host UID/GID mapped so file permissions just work.

## Quick start

Build the image and start the container:

```bash
sh build.sh
```

This builds the Docker image, starts the container in the background, and drops you into a shell. Your host's git identity and SSH agent are forwarded automatically. Set these if you want git details pre-configured:

```bash
export GIT_USER_NAME='Jeremy Howard'
export GIT_USER_EMAIL='info@fast.ai'
```

## Daily use

```bash
# Open a shell (starts the container if stopped)
alias linux='docker start linux 2>/dev/null; docker exec -it linux bash -li'

# Run a one-off command
alias linrun='docker start linux 2>/dev/null; docker exec -it linux'
```

Add these to your `~/.bashrc` or `~/.zshrc`. Then:

```bash
linux              # get a shell
linrun python3 -c "print('hello')"   # run a command
```

ctrl-d exits the shell without stopping the container.

## What's included

- **Languages:** Python 3, Rust, C/C++ (gcc, g++, clang), cmake, make
- **Python tooling:** uv, pip, venv
- **Dev tools:** git, git-lfs, gh, gdb, vim, nano, tmux, pandoc
- **Search/nav:** ripgrep, fd-find, bat, fzf, tree
- **System:** htop, strace, lsof, procps, ncdu
- **Network:** curl, wget, openssh-client, net-tools, iputils-ping, dnsutils
- **Data:** jq, sqlite3
- **Build deps:** libssl-dev, libffi-dev, zlib1g-dev, libreadline-dev, libsqlite3-dev, libopenblas-dev, libhdf5-dev

## Shared workspace

The `/ws` directory is a Docker named volume that persists across container rebuilds. Use it for anything you want to keep.

## Networking

The container now runs with Docker host networking enabled. Services listening inside the container are reachable on the same `localhost` port on the host, and services on the host are reachable from the container via `localhost`.

This requires Docker Desktop host networking to be enabled. With `--network=host`, Docker ignores `-p` port mappings.

## SSH agent

Your host's SSH agent is forwarded into the container, so `git push` and `ssh` work with your existing keys -- no need to copy them in.

## Docker socket

The host's Docker socket is mounted, so you can run Docker commands from inside the container after installing the CLI:

```bash
sudo apt-get update && sudo apt-get install -y docker.io
```

## Privileges

The container is started with `--privileged` plus host PID, IPC, UTS, cgroup, and network namespaces. On Docker Desktop for macOS this means the container is highly privileged relative to the Docker Desktop Linux VM, not native macOS.

## Timezone

Defaults to UTC. Override at runtime by setting `TZ` before running `build.sh`:

```bash
TZ=America/New_York sh build.sh
```

## Rebuilding

To rebuild from scratch:

```bash
docker rm -f linux
sh build.sh
```
