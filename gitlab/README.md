# gitlab server and runner - full stack deployment

Create a file called `root_password.txt` in this directory and put your gitlab `root` password here.  The compose stack will add the file as a secret upon deploy:
```bash
$ sudo docker stack deploy -c docker-compose.yml gitlab
```

## Register Runner

```bash
$ sudo docker exec -it CONTAINER_ID gitlab-runner register \
--non-interactive \
--url "http://raspi-swarm.home.local:88" \
--executor "docker" \
--docker-image alpine:latest \
--docker-privileged \
--registration-token "REPLACE_ME!" \
--description "docker-runner" \
--locked="false" \
--access-level="not_protected"
```