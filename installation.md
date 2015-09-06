---
---

# Requirements

The installer requires an unconfigured CentOS 7 target machine. Typically the adminstrator would manage this environment as a virtual machine. This environment must be exclusivley for the purpose of running the Shibboleth IdP instance. Installations that fail to adhere to this requirement are unsupported. The installer provides full management of the machine the and its components.

Recommended machine specifications are:

* 2 CPU
* 4GB RAM
* 10GB+ partition for OS

This machine must be configured with:

* A public IP address, with inbound access on ports `80`, `443` and `8443`
* DNS entry for this host. Typically you’d set this as `idp.yourhost.edu`
* Internet access (the installation process automatically fetches dependencies over HTTP / HTTPS)
* root access via SSH

# Running the installer

1.  The installer has been designed get you up and running with an IdP as rapidly as possible.
    To get started, run this command from your target machine (as root):

    ```
    curl https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/\
    master/bootstrap.sh > bootstrap.sh && chmod u+x bootstrap.sh
    ```

2.  Edit `bootstrap.sh`:

    ```
    vi bootstrap.sh
    ```
    - You *must* review, configure and uncomment each field listed in the "`MANDATORY SECTION`"
    - Optionally you may configure the "`OPTIONAL SECTION`" for LDAP support.
      Currently only non TLS LDAP connections are supported in the bootstrap process. Please note that you can still configure all types of LDAP after bootstrap has completed.

3.  Run `bootstrap.sh`

    ```
    ./bootstrap.sh
    ```

    The bootstrap process will:
    - Perform a `yum -y update` (system wide package upgrade). Please note that the installer uses `yum` for the installation of all system components (except Jetty and Shibboleth IdP).
    - Install all required dependencies via `yum` (`git`, `ansible` etc). With the previous step in mind, bootstrap will always use the latest versions of these packages.
    - Create self signed keys for apache. These are just for the initial testing of your IdP and must be replaced. Replacing these keys is documented [here](#configuring-your-idp).
    - Install Apache.
    - Install Jetty with Shibboleth IdP. Jetty runs on port `8080` and creates the Shibboleth IdP web app context `/idp`. Apache is configured to serve this address as `443` through a reverse proxy. Jetty also allows direct access to port `8443` for ECP.
    - Install a MariaDB instance. A database is created (name: `idp_db`, user: `idp_admin`) with [these schemas](https://github.com/ausaccessfed/shibboleth-idp-installer/tree/master/templates/db) populated.
    - Install NTP for time syncronisation.
    - Open firewall ports `80`, `443` and `8443`.

    **IMPORTANT**: After bootstrap finishes you will be given instructions to register your IdP in Federation Registry. You must follow these steps to make your IdP functional in the federation. Also note that bootstrap automatically generates passwords (for MariaDB, Shibboleth IdP etc). These are stored in:

    ```
    /opt/shibboleth-idp-installer/repository/passwords/<HOST_NAME>
    ```

Bootstrap makes assumptions to start you off however typically you’d need to configure a few more things before your IdP is functional. The next section outlines this configuration.

---

# Configuring your IdP

**IMPORTANT: Your IdP only has a single source of configuration**. It exists in the directory:

```
/opt/shibboleth-idp-installer/repository/assets/<HOST_NAME>
```

The structure of this directory will look like the following:

```
.
├── apache
│   ├── idp.conf
│   ├── intermediate.crt
│   ├── server.crt
│   └── server.key
└── idp
    ├── branding
    │   ├── css
    │   │   ├── consent.css
    │   │   └── main.css
    │   ├── error-messages.properties
    │   ├── images
    │   │   ├── logo-mobile.png
    │   │   └── logo.png
    │   └── views
    │       ├── attribute-release.vm
    │       ├── error.vm
    │       ├── expiring-password.vm
    │       ├── login-error.vm
    │       ├── login.vm
    │       ├── logout-response.vm
    │       ├── logout.vm
    │       └── resolvertest.vm
    ├── conf
    │   ├── attribute-filter.xml
    │   ├── attribute-resolver.xml
    │   ├── global.xml
    │   ├── idp.properties
    │   ├── ldap.properties
    │   ├── metadata-based-attribute-filter.xml
    │   ├── metadata-providers.xml
    │   └── services.xml
    ├── logging
    │   └── logback.xml
    └── sys
        └── jetty-profile

```
As the directory structure suggests, you may customise your IdP here. You may customise:

- Apache certificates and config
- IdP configuration (xml / properties)
- IdP branding (velocity templates, css and and images).

As a *bare* minimum, you will need to configure `/opt/shibboleth-idp-installer/repository/assets/<HOST_NAME>/idp/conf/attribute-resolver.xml` to get your IdP functional.

After any changes are made you must run the command:

```
cd /opt/shibboleth-idp-installer/repository
./update_idp.sh
```

This will apply all changes and restart Shibboleth IdP and Apache.

# Common commands
```
./update_idp                # Used to apply any configuration change to the IdP
                            # Call while inside /opt/shibboleth-idp-installer/repository

systemctl restart idp       # Restarts the IdP (jetty)
systemctl restart httpd     # Restarts apache
systemctl restart ntpd      # Restarts ntpd
systemctl restart firewalld # Restarts firewall
```

# Filesystem structure

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

# Backup / resilience

The IdP installer provides no backup or monitoring of the platform. It is **strongly suggested** that deployers configure:

* Regular backups (VM, database etc)
* Monitoring of service availability
* Monitoring of platform concerns, such as disk space and load average

The Shibboleth IdP installer also sets various configuration files. To backup your Shibboleth IdP installer configuration (not the IdP itself) please backup the following:

```
/opt/shibboleth-idp-installer/repository/passwords/<HOST_NAME>
/opt/shibboleth-idp-installer/repository/host_vars/<HOST_NAME>
/opt/shibboleth-idp-installer/repository/assets/<HOST_NAME>
```

# ECP

If you require ECP, add the back-channel certificates in Federation Registry (View IdP -> SAML -> Certificates):

1. Paste the contents of `/opt/shibboleth/shibboleth-idp/current/credentials/idp-backchannel.crt` as an additional certificate for signing.
2. Paste the contents of `/opt/shibboleth/shibboleth-idp/current/credentials/idp-encryption.crt` as an encryption certificate.

Also ensure the LDAP connection is specified in 

```
/opt/shibboleth-idp-installer/repository/assets/<HOST_NAME>/apache/idp.conf
```

