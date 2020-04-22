#!/bin/bash
set -eux
exec 1> >(logger -s -t $(basename $0)) 2>&1

##TODO: make sure all manager nodes are UP first!!

echo "Updating worker node status to active.."
for host in `sudo docker node ls --filter "role=worker" --format="{{.Hostname}}"`
do
    echo "Activating node: $host"
    CMD_OUTPUT=`sudo docker node update --availability active $host`
    echo "CMD_OUTPUT=$CMD_OUTPUT"
done


echo "Activated Worker Nodes...waiting 60 seconds to stabilize...."
sleep 30


for host in `sudo docker node ls --filter "role=manager" --format="{{.Hostname}}"`
do
    echo "Activating node: $host"
    CMD_OUTPUT=`sudo docker node update --availability active $host`
    echo "CMD_OUTPUT=$CMD_OUTPUT"
done



##TODO Manually test first!
echo "Recreate mon stack..."
CMD_OUTPUT=`sudo docker stack deploy -c ./prometheus/docker-compose.yml mon`
echo "Deployed mon stack, CMD_OUTPUT=$CMD_OUTPUT"
echo "Sleeping 30 seconds"
echo "Recreating elk stack..."
CMD_OUTPUT=`sudo docker stack deploy --compose-file=./elk/docker-compose.yml elk`
echo "Deployed elk stack, CMD_OUTPUT=$CMD_OUTPUT"
echo "DONE!"
