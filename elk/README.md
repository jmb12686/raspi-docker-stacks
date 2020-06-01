## Usage

On a Docker Swarm Manager node, run the following
```bash
export CONFIG_VERSION=X
sudo -E bash -c 'docker stack deploy --compose-file=docker-compose.yml elk'
```

## Setup Snapshot and Restore

NOTE: This is temporarily nonfunctional due to this regression.  Should be fixed in next patch release (7.7.1): https://github.com/elastic/kibana/pull/67308

In the Kibana UI, under `Management -> Elasticsearch -> Snapshot and Restore`, add the following Repository:
* `gluster-backups` -> path: `/mnt/elasticsearch-snapshot`

