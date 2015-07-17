Shibboleth IdP Installer
========================

# Overview
Installs Shibboleth IdP on a target machine via ansible. This IdP will be
preconfigured to use the
[AAF Core Attributes](http://aaf.edu.au/technical/aaf-core-attributes/) and may
be modified to fit your requirements.

The following components will be installed:
- Jetty 9.2
- Shibboleth IdP 3.1.1
- MariaDB
- Apache
- NTP

# Requirements
- Ansible 1.9.2 or newer
- Centos 7 target
- Internet connectivity from target machine

# Configuration

1. Register your IdP in Federation Registry in
   [Test](https://manager.test.aaf.edu.au/federationregistry/registration/idp)
   or
   [Production](https://manager.aaf.edu.au/federationregistry/registration/idp).
   Ensure the following attributes are selected:
    * auEduPersonSharedToken
    * commonName
    * displayName
    * eduPersonAffiliation
    * eduPersonAssurance
    * eduPersonScopedAffiliation
    * eduPersonTargetedID
    * email
    * organizationName
    * auEduPersonAffiliation
    * surname
    * uid
2. You will receive an email from the federation indicating your IdP is pending.
   After your IdP has been **approved** you will receive your unique attribute
   filter policy URL. Please note this value for later.
3. Create a local [ansible_hosts](ansible_hosts.dist) file containing the the
   hosts you want to target.
4. Configure a
   [host_var config](host_vars/shib-idp-installer-1.aaf.dev.edu.au.dist)
   for each host defined in the previous step. Define your IdP properties in
   this file.
5. Create a local `assets` directory.
6. Add your SSL key, certificate and intermediate CA following this exact
   structure:
```
assets/<HOSTNAME>/apache/server.crt
assets/<HOSTNAME>/apache/server.key
assets/<HOSTNAME>/apache/intermediate.crt
```
See example [here](assets/shib-idp-installer-1.aaf.dev.edu.au.dist).

**IMPORTANT — After running the playbook you must still configure your IdP!**
Typically this would be the configuration of
`{idp.home}/conf/attribute-resolver.xml` and `{idp.home}/conf/ldap.properties`.

To activate your configuration these changes you may need to restart the
service with the command: `systemctl restart idp`

# Usage
```
ansible-playbook -i <ansible_host_file> site.yml
```

**N.B.** Shibboleth's IdP installer requires private key and cookie encryption
passwords. These are generated automatically during the playbook run. **We
strongly recommend making a copy of the generated `passwords` directory after
running the playbook**.

# Logs

Log files can be viewed at `/var/log/shibboleth` and `/var/log/jetty`
respectively.

# Structure after playbook install
```
/opt/
├── jetty
│   └── jetty-distribution-9.2.10.v20150310     # Jetty installation
├── keypairs                                    # Keys used for Apache
│   ├── intermediate.crt
│   ├── server.crt
│   └── server.key
├── shibboleth
│   ├── jetty                                   # Jetty base for Shib IdP
│   ├── shibboleth-idp
│   │   └── shibboleth-idp-3.1.1                # Shibboleth instance
│   └── shibboleth-src                          # Shib Installation files
│       ├── install-3.1.1.exp
│       ├── install-3.1.1.sh
│       └── shibboleth-identity-provider-3.1.1
└── shibboleth-idp-installer                    # Working directory
```


