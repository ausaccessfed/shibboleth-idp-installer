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

# Configuration

1. Create a local [ansible_hosts](ansible_hosts.dist) file containing the the
   hosts you want to target.
2. Configure a [host_var config](host_vars/shib-idp-installer-1.aaf.dev.edu.au.dist)
   for *each host* defined in the previous step. Define your IdP properties in
   this file.
3. Create a local `assets` directory.
4. Add your SSL key, certificate and intermediate CA following this exact
   structure:

```
assets/<HOSTNAME>/apache/server.crt
assets/<HOSTNAME>/apache/server.key
assets/<HOSTNAME>/apache/intermediate.crt
```
See example [here](assets/shib-idp-installer-1.aaf.dev.edu.au.dist).

# Usage
```
ansible-playbook -i <ansible_host_file> site.yml
```

N.B. Shibboleth's IdP installer requires private key and cookie encryption
passwords. These are generated automatically during the playbook run. **We
strongly recommend making a copy of the generated `passwords` directory after
running the playbook**.

