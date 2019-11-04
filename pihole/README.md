## Usage
1. Check if the docker_gwbridge ip address is 172.18.0.1:
    ```bash
    ip -o addr show docker_gwbridge
    ```

    If different, replace 172.18.0.1 with your local docker_gwbridge address in the pihole `DNS1:` docker environment variable.  This will set the `cloudflared` DoH container as the primary upstream DNS provider.

    ```yaml
    environment:
      DNS1: "172.18.0.1#5053"    
    ```

2. On a Docker Swarm Manager node, run:
    ```bash
    $ export PIHOLE_WEBPASSWORD=admin
    $ sudo -E bash -c 'docker stack deploy --compose-file=docker-compose-stack.yml pihole'
    ```

3. To change temperature to fahrenheit, run the following against each pihole container.  This setting is persisted in the docker volume:
    ```sh
    docker exec PIHOLE_CONTAINER_NAME pihole -a fahrenheit
    ```
4. You may want to add hostrecords to dnsmasq, run the following against each pihole container / node:
    ```sh
    docker exec PIHOLE_CONTAINER_NAME pihole -a hostrecord my.custom.dns.entry 192.168.X.X
    ```
    These records are persisted in the dnsmasq docker volume.