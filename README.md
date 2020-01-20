# RaspberryPi Docker Swarm Stacks
A collection of Docker Stacks that I run on my home Raspberry Pi Docker Swarm cluster. 

* **Prometheus** - Full metrics and monitoring pipeline.  Includes Docker, container, and node based metric collection, alerting, and visualization w/ **Grafana**
* **pihole** - Network wide adblocker implementing DNS over HTTPS (DoH) via **cloudflared** proxy.
* **portainer** - Docker Swarm cluster management UI.
* **GitLab** - GitLab Omnibus deployment with GitLab CI/CD Runner.
* **Elastic (ELK) Stack** - Logging aggregation, analysis, search, and visualization stack.  Comprised of Elasticsearch, Kibana, and Filebeats.



## Setup and Install
Clone the repo, `cd` into each directory and run:
```bash
sudo docker stack deploy --compose-file=$FILE_NAME $STACK_NAME
```

**Note** - Read thru README in each dir for setup and configuration details of each stack.
