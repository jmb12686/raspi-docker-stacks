#!/bin/bash
set -eux
exec 1> >(logger -s -t $(basename $0)) 2>&1

for host in `sudo docker node ls --filter "role=manager" --format="{{.Hostname}}"`
do
    echo "Draining node: $host"
    CMD_OUTPUT=`sudo docker node update --availability drain $host`
    echo "CMD_OUTPUT=$CMD_OUTPUT"
done

echo "Drained Manager Nodes...waiting 30 seconds to stabilize...."
sleep 30


for host in `sudo docker node ls --filter "role=worker" --format="{{.Hostname}}"`
do
    echo "Draining node: $host"
    CMD_OUTPUT=`sudo docker node update --availability drain $host`
    echo "CMD_OUTPUT=$CMD_OUTPUT"
done

echo "Drained Worker Nodes...waiting 30 seconds to stabilize...."
sleep 30

echo "remove stateful docker stacks [mon & elk] to allow graceful cluster rejoin upon reboot"
CMD_OUTPUT=`sudo docker stack rm elk`
echo "Removed elk stack, CMD_OUTPUT=$CMD_OUTPUT"
CMD_OUTPUT=`sudo docker stack rm mon`
echo "Removed mon stack, CMD_OUTPUT=$CMD_OUTPUT"


## TODO: Need consistent user login name (ubuntu vs pi)
# echo "Shutting down worker nodes"
# for host in `sudo docker node ls --filter "role=worker" --format="{{.Hostname}}"`
# do
#     echo "shutting down node: $node"
#     CMD_OUTPUT=`sudo shut`
#     echo "CMD_OUTPUT=$CMD_OUTPUT"
# done

#TODO These need to be IPs, DNS is dead at this point
echo "Shutting down worker nodes"
ssh pi@raspberrypi-beta sudo shutdown now
ssh pi@raspberrypi-delta-3 sudo shutdown now
ssh ubuntu@raspberrypi-delta-5 sudo shutdown now
ssh pi@raspberrypicharlie sudo shutdown now

echo "Shutting down manager nodes"
ssh ubuntu@raspberrypi-delta-2 sudo shutdown now
ssh ubuntu@raspberrypi-delta-4 sudo shutdown now


