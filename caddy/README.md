## Setup

Create a file at `conf/google-client.conf` and include the following line (substitute your google client id and secret):

```
google client_id=CLIENT_ID,client_secret=SECRET
```

This config file is created as a `Docker Secret` during stack deploy to secure the oauth secret

## Deploy

On a Docker Swarm Manager node, run the following
```bash
export CONFIG_VERSION=X
sudo -E bash -c 'docker stack deploy --compose-file=docker-compose.yml caddy'
```