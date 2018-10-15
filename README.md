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
    NS: OIO
  pre_tasks:
    - name: Ensures namespace directory exists
      file:
        dest: "/etc/oio/sds.conf.d"
        state: directory
      tags: install

    - name: Copy using the 'content' for inline data
      copy:
        content: |
          [{{ NS }}]
          # endpoints
          conscience=172.17.0.2:6000
          zookeeper=172.17.0.2:6005
          proxy=172.17.0.2:6006
          event-agent=beanstalk://172.17.0.2:6014

          meta1_digits=3
          udp_allowed=yes

          ns.storage_policy=THREECOPIES
          ns.chunk_size=10485760
          ns.service_update_policy=meta2=KEEP|3|1|;rdir=KEEP|3|1|;

        dest: "/etc/oio/sds.conf.d/{{ NS }}"
  roles:
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
        #- proxy.bulk.max.create_many=100
        #- proxy.bulk.max.delete_many=100
        #- proxy.cache.enabled=on
        #- proxy.dir_shuffle=on
        #- proxy.force.master=off
        #- proxy.outgoing.timeout.common=30.000000
        #- proxy.outgoing.timeout.config=10.000000
        #- proxy.outgoing.timeout.conscience=10.000000
        #- proxy.outgoing.timeout.stat=10.000000
        #- proxy.period.cs.downstream=5
        #- proxy.period.cs.upstream=1
        #- proxy.period.refresh.csurl=30
        #- proxy.period.refresh.srvtypes=30
        #- proxy.period.reload.nsinfo=30
        #- proxy.prefer.master_for_read=off
        #- proxy.prefer.master_for_write=on
        #- proxy.prefer.slave_for_read=off
        #- proxy.quirk.local_scores=off
        #- proxy.srv_shuffle=on
        #- proxy.ttl.services.down=5000000
        #- proxy.ttl.services.known=432000000000
        #- proxy.ttl.services.local=30000000
        #- proxy.ttl.services.master=5000000
        #- proxy.url.path.maxlen=2048
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

Apache License, Version 2.0

## Contributors

- [Cedric DELGEHIER](https://github.com/cdelgehier) (maintainer)
