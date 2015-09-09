---
---

# Operation
Following completion of all the previous stages the Shibboleth IdP enters an operational phase.

Administrators should be aware of the following concerns for the ongoing operation of the Shibboleth IdP.

## Common commands
```
./update_idp                # Used to apply any configuration change to the IdP
                            # Call while inside /opt/shibboleth-idp-installer/repository

systemctl restart idp       # Restarts the IdP (jetty)
systemctl restart httpd     # Restarts apache
systemctl restart ntpd      # Restarts ntpd
systemctl restart firewalld # Restarts firewall
```

## Filesystem structure

The stucture of the filesystem after a successful install is as follows:

```
/opt
├── jetty
│   └── jetty-distribution-9.2.10.v20150310     # Jetty installation
├── keypairs                                    # TLS assets used for Apache
│   ├── intermediate.crt
│   ├── server.crt
│   └── server.key
├── shibboleth
│   ├── jetty                                   # Jetty base for Shib IdP
│   ├── shibboleth-idp
│   │   └── shibboleth-idp-3.1.1                # Shibboleth instance
│   └── shibboleth-src                          # Shib Installation files
│       ├── install-3.1.1.exp
│       ├── install-3.1.1.sh
│       └── shibboleth-identity-provider-3.1.1
└── shibboleth-idp-installer
    ├── repository                              # Holds configuration and source code
    └── build                                   # Working directory for installer

/var
└── log
    ├── shibboleth                              # Shibboleth specific logs
    ├── httpd                                   # Apache logs
    └── jetty                                   # Jetty base logs

```

## Backup / Resilience

The IdP installer provides **no** backup or monitoring of the platform.

Deployers SHOULD:

* Undertake regular backups of:
  * The entire VM
  * The local mariadb instance
  * Key directories, including, but not limited to:
      1. `/opt/shibboleth-idp-installer`
      1. `/opt/keypairs`
      1. `/opt/shibboleth`
      1. `/etc/httpd`
* Monitor service availability
* Monitor platform concerns, such as disk space and load averages

## Future Customisations

You can safely return to the [customisation](customisation.html) stage in the future to make additional modifications.
