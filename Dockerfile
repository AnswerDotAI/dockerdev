FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ARG PANDOC_VERSION=3.7.0.2
ARG TARGETARCH
ARG HOST_UID=1000
ARG HOST_GID=1000
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

RUN apt-get update && apt-get install -y wget unminimize && yes | unminimize

RUN --mount=type=bind,src=install-aptfast.sh,dst=install-aptfast.sh sh install-aptfast.sh

RUN apt-fast install -y sudo pkg-config libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev libopenblas-dev libhdf5-dev \
  rustc cargo vim-nox less graphviz ffmpeg procps htop file git-lfs clang \
  curl git nano tmux  build-essential cmake make gcc g++ gdb  python3 python3-pip python3-venv python3-dev \
  ripgrep fd-find bat fzf sqlite3 ncdu  strace lsof net-tools  tree jq unzip zip rsync  openssh-client iputils-ping dnsutils  man-db manpages-dev \
  locales ca-certificates \
  && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

ADD https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${TARGETARCH}.deb /tmp/pandoc.deb
RUN dpkg -i /tmp/pandoc.deb && rm /tmp/pandoc.deb

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 TZ=UTC
RUN rm -f /etc/legal

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN usermod -u ${HOST_UID} ubuntu \
    && { getent group ${HOST_GID} || groupmod -g ${HOST_GID} ubuntu; } \
    && usermod -g ${HOST_GID} ubuntu \
    && chown -R ${HOST_UID}:${HOST_GID} /home/ubuntu

RUN if [ -n "$GIT_USER_NAME" ]; then git config --system user.name "$GIT_USER_NAME"; fi \
    && if [ -n "$GIT_USER_EMAIL" ]; then git config --system user.email "$GIT_USER_EMAIL"; fi

USER ubuntu
WORKDIR /home/ubuntu

COPY inst-uv.sh .
RUN sh ./inst-uv.sh && rm ./inst-uv.sh

CMD ["sleep", "infinity"]
