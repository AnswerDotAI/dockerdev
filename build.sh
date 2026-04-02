HOST_USER=$(whoami)
SECRETS_MOUNT=""
[ -f "$HOME/.secrets" ] && SECRETS_MOUNT="-v $HOME/.secrets:/home/$HOST_USER/.secrets"
[ -f "$HOME/.aliases" ] && ALIASES_MOUNT="-v $HOME/.aliases:/home/$HOST_USER/.aliases"

docker build \
  --build-arg HOST_UID=$(id -u) --build-arg HOST_GID=$(id -g) --build-arg HOST_USER="$HOST_USER" \
  --build-arg GIT_USER_NAME="$(git config user.name)" --build-arg GIT_USER_EMAIL="$(git config user.email)" \
  -t linux .

docker run -d --name linux \
  --privileged --pid=host --ipc=host --uts=host --cgroupns=host --network=host \
  -e HOME=/home/$HOST_USER -e TZ="${TZ:-UTC}" -v "ws:/ws" \
  -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
  -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $SECRETS_MOUNT $ALIASES_MOUNT \
  linux

docker exec -it linux bash -li
