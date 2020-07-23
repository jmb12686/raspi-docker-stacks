# RaspberryPi Docker Swarm Stacks

![Custom badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fhealthchecks.io%2Fbadge%2F60ea1ee3-cc42-4799-9a68-e08d81%2FlrujVX8j.shields)

A collection of Docker Stacks that I run on my home Raspberry Pi Docker Swarm cluster.

* **Prometheus** - Full metrics and monitoring pipeline.  Includes Docker, container, and node based metric collection, alerting, and visualization w/ **Grafana**
* **pihole** - Network wide adblocker implementing DNS over HTTPS (DoH) via **cloudflared** proxy.
* **portainer** - Docker Swarm cluster management UI.
* **GitLab** - GitLab Omnibus deployment with GitLab CI/CD Runner.
* **Elastic (ELK) Stack** - Logging aggregation, analysis, search, and visualization stack.  Comprised of **Elasticsearch**, **Kibana**, and **Filebeat**.
* **Unifi Controller** -  Wireless network management software solution from Ubiquiti Networks for administration of Unifi network gear.
  


## Setup and Install
Clone the repo, `cd` into each directory and run:
```bash
sudo docker stack deploy --compose-file=$FILE_NAME $STACK_NAME
```

**Note** - Read thru README in each dir for setup and configuration details of each stack.

## Multiarch Docker Images

Many of the open source products used here do not have vendor supported ARM compatible Docker images or are published under different Docker Hub repositories / tags.  Some vendor supported images do have ARM support, but are not fully compatible with Docker Swarm clustering.  To overcome these limitations, the following projects were created and use [Docker buildx](https://docs.docker.com/buildx/working-with-buildx/) to publish native multi-architecture images (tutorial [here](https://www.docker.com/blog/multi-arch-images/)).  Check out these repositories for further information:

* [jmb12686/docker-cadvisor](https://github.com/jmb12686/docker-cadvisor)
* [jmb12686/node-exporter](https://github.com/jmb12686/node-exporter)
* [jmb12686/docker-swarm-alertmanager](https://github.com/jmb12686/docker-swarm-alertmanager)
* [jmb12686/docker-socat](https://github.com/jmb12686/docker-socat)
* [jmb12686/docker-elasticsearch](https://github.com/jmb12686/docker-elasticsearch)
* [jmb12686/docker-kibana](https://github.com/jmb12686/docker-kibana)
* [jmb12686/docker-filebeat](https://github.com/jmb12686/docker-filebeat)

Special shout out to these open source ARM compatible projects used:

* [crazy-max/docker-cloudflared](https://github.com/crazy-max/docker-cloudflared)
* [pi-hole/docker-pi-hole](https://github.com/pi-hole/docker-pi-hole)
* [ulm0/gitlab](https://github.com/ulm0/gitlab)
* [klud/gitlab-runner](https://hub.docker.com/r/klud/gitlab-runner/)

