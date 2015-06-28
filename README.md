Shibboleth IdP Installer
========================

# Overview
Installs Shibboleth IdP on a target machine via ansible.

The following components will be installed:
- Jetty
- Shibboleth IdP
- ... more to come ...

# Requirements
- Ansible 2.0.0
- Centos 7 target
- Internet connectivity from target machine

# Usage
```
ansible-playbook -i <ansible_host_file> site.yml
```

