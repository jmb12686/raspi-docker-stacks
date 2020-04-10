## Usage

On a Docker Swarm Manager node, run the following
```bash
export CONFIG_VERSION=X
sudo -E bash -c 'docker stack deploy --compose-file=docker-compose.yml elk'
```