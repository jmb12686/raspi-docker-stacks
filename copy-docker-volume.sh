#!/bin/bash

sudo docker run --rm -v gitlab_gitlab-data:/from alpine ash -c "cd /from ; tar -cf - . " | ssh ubuntu@raspberrypi-delta-2 'sudo docker run --rm -i -v gitlab_gitlab-data:/to alpine ash -c "cd /to ; tar -xpvf - " '