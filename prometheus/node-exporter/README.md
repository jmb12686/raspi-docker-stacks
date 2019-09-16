# swarmprom-node-exporter
Containerized, multiarch version of swarmprom-node-exporter, used for [Prometheus](https://prometheus.io/) monitoring.  Designed to be usable within either x86-64 and ARM based Docker Swarm clusters for correct reporting of the underlying node hostname

## Build and Deploy multiarch image

Setup local environment to support Docker experimental feature for building multi architecture images, [buildx](https://docs.docker.com/buildx/working-with-buildx/).  Follow instructions [here](https://engineering.docker.com/2019/04/multi-arch-images/)

Clone repo:
```bash
$ git clone https://github.com/jmb12686/swarmprom-node-exporter
$ cd swarmprom-node-exporter 
```

Build multiarch image:
```bash
$ docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t jmb12686/swarmprom-node-exporter:latest --push .
```

If building from Windows host:

* run `dos2unix *.sh` in cygwin / WSL on all shell scripts in conf/ directory

## Usage

Use in docker-compose swarm stack similar to base image for `prom/node-exporter`, but added:
* `NODE_ID` as environment variable
* mount `/etc/hostname` of underlying host to `/etc/nodename` in the container.  
* Entrypoint script within container will use `/etc/nodename` and `NODE_ID` to create custom data attributes and put config in `/etc/node-exporter`.
* `node-name` and `node-id` attributes are exposed in node-exporter


```yaml
services:
  .....
  node-exporter:
    image: jmb12686/swarmprom-node-exporter:latest 
    networks:
      - net
    environment:
      - NODE_ID={{.Node.ID}}
    ports:
      - 9100:9100
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
      - /etc/hostname:/etc/nodename:ro
    command:
      - '--path.sysfs=/host/sys'
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--collector.textfile.directory=/etc/node-exporter/'
      - '--collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($$|/)'
      - '--no-collector.ipvs'
    deploy:
      mode: global
      resources:
        limits:
          memory: 128M
        reservations:
          memory: 64M
```



