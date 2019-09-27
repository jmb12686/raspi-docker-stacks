## Usage

On a Docker Swarm Manager node, run the following (preferably after picking a better shared secret):
```bash
$ export PORTAINER_AGENT_SECRET=changeme
$ sudo -E bash -c 'docker stack deploy --compose-file=portainer-agent-stack.yml portainer'
```