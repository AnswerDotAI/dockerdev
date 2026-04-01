docker build \
  --build-arg HOST_UID=$(id -u) \
  --build-arg HOST_GID=$(id -g) \
  --build-arg GIT_USER_NAME="$(git config user.name)" \
  --build-arg GIT_USER_EMAIL="$(git config user.email)" \
  -t linux .

docker run -d --name linux \
  -e HOME=/home/ubuntu \
  -e TZ="${TZ:-UTC}" \
  -v "ws:/ws" \
  -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
  -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 55001:5001 -p 58000:8000 -p 58080:8080 \
  linux
docker exec -it linux bash -li

