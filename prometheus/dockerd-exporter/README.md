# dockerd-exporter (multi-architecture socat Docker image)
Inspired by [stefanprodan/dockerd-exporter](https://github.com/stefanprodan/dockerd-exporte) with added support for ARM / ARM64 multiarchitecture images.  Runs the `socat` program in a base alpine image.  Can be used to relay arbitrary socket data or specifically export experimental Docker daemon metrics to Prometheus.

## Install and Usage

### Setup Docker Engine
[Enable experimental metrics for docker engine](https://docs.docker.com/config/thirdparty/prometheus/#configure-docker) for address `0.0.0.0:9323`.  

Check if the docker_gwbridge ip address is 172.18.0.1:

 `docker run --rm --net host alpine ip -o addr show docker_gwbridge`

### Docker Swarm 

Create an overlay network:

```sh
docker network create \
  --driver overlay \
  netmon
```

Create dockerd-exporter global service (replace 172.18.0.1 with your docker_gwbridge address):

```sh
docker service create -d \
  --mode global \
  --name dockerd-exporter \
  --network netmon \
  -e IN="172.18.0.1:9323" \
  -e OUT="9323" \
  jmb12686/socat:latest \
  -d -d TCP-L:9323,fork TCP:172.18.0.1:9323
```

Configure Prometheus to scrape the dockerd-exporter instances:

```
scrape_configs:
- job_name: 'dockerd-exporter'
  dns_sd_configs:
  - names:
    - 'tasks.dockerd-exporter'
    type: 'A'
    port: 9323
```

Run Prometheus on the same overlay network as dockerd-exporter.

## Build and Publish Socat Image
This image is design to support multiarchitecture images for usage on both ARM and amd64 hosts.  Setup local environment to support Docker experimental feature for building multi architecture images, [buildx](https://docs.docker.com/buildx/working-with-buildx/).  Follow instructions [here](https://engineering.docker.com/2019/04/multi-arch-images/)

Clone repo:
```bash
$ git clone https://github.com/jmb12686/raspi-docker-stacks
$ cd raspi-docker-stacks/prometheus/dockerd-exporter
```

Build multiarch image:
```bash
$ docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t jmb12686/socat:latest --push .
```