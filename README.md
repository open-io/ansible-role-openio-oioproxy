[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-oioproxy.svg?branch=master)](https://travis-ci.org/open-io/ansible-role-openio-oioproxy)
# Ansible role `oioproxy`

An Ansible role for oioproxy. Specifically, the responsibilities of this role are to:

- Install and configure an oio-proxy

## Requirements

- Ansible 2.4+

## Role Variables


| Variable   | Default | Comments (type)  |
| :---       | :---    | :---             |
| `openio_oioproxy_bind_address` | `hostvars[inventory_hostname]['ansible_' + openio_oioproxy_bind_interface]['ipv4']['address']` | IP address to use |
| `openio_oioproxy_bind_interface` | `ansible_default_ipv4.alias` | NIC name to use |
| `openio_oioproxy_bind_port` | `6006` | Port number to open |
| `openio_oioproxy_gridinit_dir` | `/etc/gridinit.d/{{ openio_oioproxy_namespace }}` | Path to copy the gridinit conf |
| `openio_oioproxy_gridinit_file_prefix` | `""` | Maybe set it to {{ openio_oioproxy_namespace }}- for old gridinit's style |
| `openio_oioproxy_gridinit_start_at_boot` | `true` | Start at system boot |
| `openio_oioproxy_gridinit_on_die` | `respawn` | Start at system boot |
| `openio_oioproxy_namespace` | `"OPENIO"` | Namespace OPENIO |
| `openio_oioproxy_provision_only` | `false` | Provision only, without restarting the services |
| `openio_oioproxy_options` | `[]` | List of options |
| `openio_oioproxy_serviceid` | `"0"` | ID in gridinit |
| `openio_oioproxy_version` | `latest` | Install a specific version |

## Dependencies
```
---
- src: https://github.com/open-io/ansible-role-openio-repository.git
  version: master
  name: repository

- src: https://github.com/open-io/ansible-role-openio-gridinit.git
  version: master
  name: gridinit

- src: https://github.com/open-io/ansible-role-openio-namespace.git
  version: master
  name: namespace

- src: https://github.com/open-io/ansible-role-openio-users.git
  version: master
  name: users

- src: https://github.com/open-io/ansible-role-openio-conscience.git
  version: master
  name: conscience
...
```

## Example Playbook

```yaml
# Test playbook
- hosts: all
  become: true
  vars:
    NS: OPENIO
  roles:
    - role: users
    - role: namespace
      openio_namespace_name: "{{ NS }}"
    - role: repository
    - role: gridinit
      openio_gridinit_namespace: "{{ NS }}"
    - role: conscience
      openio_conscience_namespace: "{{ NS }}"
    - role: role_under_test
      openio_oioproxy_namespace: "{{ NS }}"
      openio_oioproxy_options:
        - proxy.cache.enabled=off
        - proxy.period.cs.downstream=7
...
```

```ini
[all]
node1 ansible_host=192.168.1.173
```

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome.
The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork.
Github can then easily create a PR based on that branch.

## License

GNU AFFERO GENERAL PUBLIC LICENSE, Version 3

## Contributors

- [Cedric DELGEHIER](https://github.com/cdelgehier) (maintainer)
