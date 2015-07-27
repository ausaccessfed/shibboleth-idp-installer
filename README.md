Shibboleth IdP Installer
========================

# Overview
Installs Shibboleth IdP on a target machine via ansible. This IdP will be preconfigured to use the [AAF Core Attributes](http://aaf.edu.au/technical/aaf-core-attributes/) and may be modified to fit your requirements.

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

# Backup / resilience

The IdP installer provides no backup or monitoring of the platform. It is **strongly suggested** that deployers configure:
- Regular backups (VM, Database etc)
- Monitoring of service availability
- Monitoring of platform concerns, such as disk space and load average

# Usage

This section outlines the process of registering a new IdP and running the installer.

1. Create a local [ansible_hosts](ansible_hosts.dist) file containing the the hosts you want to target.
2. Create a local host_var config. Follow the structure in the [AAF Test](host_vars/idp.example.edu.dist.test) or [AAF Production](host_vars/idp.example.edu.dist.production) example. Ensure the file name matches your host. At this stage you will not be able to define `attribute_filter_url`. **Leave this blank for now** — you will address this in a later step.
3. Create a local `assets` directory. Add your Apache SSL key, certificate and intermediate CA following the structure given in [this example](assets/idp.example.edu.dist).
4. Run the playbook with the command: `ansible-playbook -i <ansible_host_file> site.yml`
5. Register your IdP in Federation Registry in [Test](https://manager.test.aaf.edu.au/federationregistry/registration/idp) or [Production](https://manager.aaf.edu.au/federationregistry/registration/idp). For 'Public Key', paste the value from `{idp.home}/credentials/idp-signing.crt`. For 'Supported Attributes' select the following:
    * auEduPersonSharedToken
    * commonName
    * displayName
    * eduPersonAffiliation
    * eduPersonAssurance
    * eduPersonScopedAffiliation
    * eduPersonTargetedID
    * email
    * organizationName
    * surname
6. You will receive an email from the federation indicating your IdP is pending. After your IdP has been **approved** you will be able to fill `attribute_filter_url` (See Step 2).
7. Re-run the playbook using the same command issued previously (Step 4).

**IMPORTANT — After running the playbook you must still configure your IdP!** Typically this would be the configuration of `{idp.home}/conf/attribute-resolver.xml` and `{idp.home}/conf/ldap.properties`.

To activate your configuration these you may need to restart the IdP service with the command: `systemctl restart idp`.

**N.B.** Shibboleth's IdP installer requires private key and cookie encryption passwords. These are generated automatically during the playbook run. **We strongly recommend making a copy of the generated `passwords` directory after running the playbook**.

# File system structure after playbook install
```
/opt
├── jetty
│   └── jetty-distribution-9.2.10.v20150310     # Jetty installation
├── keypairs                                    # TLS assets used for Apache
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

/var
└── log
    ├── shibboleth                              # Shibboleth specific logs
    ├── httpd                                   # Apache logs
    └── jetty                                   # Jetty base logs
```

