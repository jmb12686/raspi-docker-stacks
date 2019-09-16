#!/bin/sh -e

NODE_NAME=$(cat /etc/nodename)
echo "node name = $NODE_NAME"
echo "node_meta{node_id=\"$NODE_ID\", container_label_com_docker_swarm_node_id=\"$NODE_ID\", node_name=\"$NODE_NAME\"} 1" > /etc/node-exporter/node-meta.prom
echo "created node-meta.prom file!"
set -- /bin/node_exporter "$@"

exec "$@"
