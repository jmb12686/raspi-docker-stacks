# gitlab server and runner deployment

## Deploy the Server

1.  Create a file called `root_password.txt` in this directory and put your gitlab `root` password here.  The compose stack will add the file as a secret upon deploy

2.  Deploy the stack:

    ```bash
    $ sudo docker stack deploy -c server-docker-compose.yml gitlab-server
    ```

## Deploy the Runner stack

1.  Find your registration token in GitLab, navigate to: "Your project" > "Settings" > "CI/CD" > "Runners settings" > "Specific Runners" (look for registration token).  Register it as `GITLAB_REGISTRATION_TOKEN`:

    ```bash
    $ printf <YOUR_REGISTRATION_TOKEN> | sudo docker secret create GITLAB_REGISTRATION_TOKEN -
    ```

2.  Find your personal access token in GitLab, navigate to: "Your user account" > "Settings" > "Access Tokens" > "Create personal access token" (for api).  Register it as `GITLAB_PERSONAL_ACCESS_TOKEN`:

    ```bash
    $ printf <YOUR ACCESS TOKEN> | sudo docker secret create GITLAB_PERSONAL_ACCESS_TOKEN -
    ```

3.  Deploy the stack:

    ```bash
    $ sudo docker stack deploy --compose-file runner-docker-compose.yml gitlab-runner
    ```


<!-- ## Register Runner

```bash
$ sudo docker exec -it CONTAINER_ID gitlab-runner register \
--non-interactive \
--url "http://raspi-swarm.home.local:88" \
--executor "docker" \
--docker-image alpine:latest \
--docker-privileged \
--registration-token "sZcx2xcHAwgHZiTQVbHs" \
--description "docker-runner" \
--locked="false" \
--access-level="not_protected"
```

Edit the config to add `session_server` attributes after gitlab runnner is registered.  Then restart the runner: https://gitlab.com/gitlab-org/gitlab-runner/issues/3885 -->