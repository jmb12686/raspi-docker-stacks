# prometheus

Docker Swarm monitoring with [Prometheus](https://prometheus.io/),
[Grafana](http://grafana.org/),
[cAdvisor](https://github.com/google/cadvisor),
[Node Exporter](https://github.com/prometheus/node_exporter),
[Alert Manager](https://github.com/prometheus/alertmanager)

Dereived from [stefanprodan/swarmprom](https://github.com/stefanprodan/swarmprom) with added support for multi architecture Docker images (amd64, arm64, and arm/v7).  This implementation also eliminates the need to custom build Prometheus, Grafana, and AlertManager images.

## Install

Clone this repository and run the monitoring stack:

```bash
$ git clone https://github.com/jmb12686/raspi-docker-stacks.git
$ cd prometheus

docker stack deploy -c docker-compose.yml mon
```

Prerequisites:

* Docker CE 17.09.0-ce or Docker EE 17.06.2-ee-3
* Swarm cluster with one manager and a worker node
* Docker engine experimental enabled and metrics address set to `0.0.0.0:9323`

Services:

* prometheus (metrics database) `http://<swarm-ip>:9090`
* grafana (visualize metrics) `http://<swarm-ip>:3000`
* node-exporter (host metrics collector)
* cadvisor (containers metrics collector)
* dockerd-exporter (Docker daemon metrics collector, requires Docker experimental metrics-addr to be enabled)
* alertmanager (alerts dispatcher) `http://<swarm-ip>:9093`

### custom multiarch node-exporter

When a node-exporter container starts `node-meta.prom` is generated with the following content:

```bash
"node_meta{node_id=\"$NODE_ID\", node_name=\"$NODE_NAME\"} 1"
```

The node ID value is supplied via `{{.Node.ID}}` and the node name is extracted from the `/etc/hostname`
file that is mounted inside the node-exporter container.

```yaml
  node-exporter:
    image: jmb12686/swarmprom-node-exporter
    environment:
      - NODE_ID={{.Node.ID}}
    volumes:
      - /etc/hostname:/etc/nodename
    command:
      - '-collector.textfile.directory=/etc/node-exporter/'
```

Using the textfile command, you can instruct node-exporter to collect the `node_meta` metric.
Now that you have a metric containing the Docker Swarm node ID and name, you can use it in promql queries.

Let's say you want to find the available memory on each node, normally you would write something like this:

```
sum(node_memory_MemAvailable) by (instance)

{instance="10.0.0.5:9100"} 889450496
{instance="10.0.0.13:9100"} 1404162048
{instance="10.0.0.15:9100"} 1406574592
```

The above result is not very helpful since you can't tell what Swarm node is behind the instance IP.
So let's write that query taking into account the node_meta metric:

```sql
sum(node_memory_MemAvailable * on(instance) group_left(node_id, node_name) node_meta) by (node_id, node_name)

{node_id="wrdvtftteo0uaekmdq4dxrn14",node_name="swarm-manager-1"} 889450496
{node_id="moggm3uaq8tax9ptr1if89pi7",node_name="swarm-worker-1"} 1404162048
{node_id="vkdfx99mm5u4xl2drqhnwtnsv",node_name="swarm-worker-2"} 1406574592
```

This is much better. Instead of overlay IPs, now I can see the actual Docker Swarm nodes ID and hostname. Knowing the hostname of your nodes is useful for alerting as well.

You can define an alert when available memory reaches 10%. You also will receive the hostname in the alert message
and not some overlay IP that you can't correlate to a infrastructure item.

Maybe you are wondering why you need the node ID if you have the hostname. The node ID will help you match
node-exporter instances to cAdvisor instances. All metrics exported by cAdvisor have a label named `container_label_com_docker_swarm_node_id`,
and this label can be used to filter containers metrics by Swarm nodes.

Let's write a query to find out how many containers are running on a Swarm node.
Knowing from the `node_meta` metric all the nodes IDs you can define a filter with them in Grafana.
Assuming the filter is `$node_id` the container count query should look like this:

```
count(rate(container_last_seen{container_label_com_docker_swarm_node_id=~"$node_id"}[5m]))
```

## Updating Configs in already deployed Stack
This Prometheus stack utilizes many Docker Configs which are immutable.  To support hot deployment and updating of the stack with updates to config files, a versioning mechanism has been added to the Compose file:
```yml
configs:
  prometheus:
    name: prometheus-${CONFIG_VERSION:-0}
    file: ./prometheus/conf/prometheus.yml  
```

Without the `CONFIG_VERSION` env variable set, compose defaults the config file "version" to 0.

Deploying the stack with `CONFIG_VERSION=1`:
```bash
$ export CONFIG_VERSION=1 
$ sudo -E bash -c 'docker stack deploy -c docker-compose.yml mon'
Creating config prometheus-1
Creating config alert_manager-1
Updating service mon_prometheus (id: 2mdy9h720iofyaqort1qx1qu2)
Updating service mon_alertmanager (id: 68sxctatkw7kwg1ywt4zcik4v)
```

Removing the Docker stack will dispose of all configs created, but there is currently no `prune` for Docker Configs, so maintenance / cleanup to remove unused configs should be periodically performed.
