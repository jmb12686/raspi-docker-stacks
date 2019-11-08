external_url 'http://raspi-swarm.home.local:88/'
gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab_root_password')