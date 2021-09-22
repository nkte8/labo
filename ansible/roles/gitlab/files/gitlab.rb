external_url "http://gitlab.__ZONE_NAME"
registry_external_url 'http://registry.__ZONE_NAME:5005'
gitlab_rails['registry_enabled'] = true
gitlab_rails['registry_host'] = "registry.__ZONE_NAME"
gitlab_rails['registry_port'] = "5005"
gitlab_rails['initial_shared_runners_registration_token'] = 'gitlabtoken'
gitlab_rails['initial_root_password'] = 'gitlabroot'
grafana['enable'] = false
prometheus['enable'] = false
gitlab_rails['backup_path'] = '/bak/backup/gitlab'
