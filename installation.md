---
---

# Requirements

The installer *requires* an enviromnent which is exclusivley for the purpose of running the Shibboleth IdP. Installations that fail to adhere to this requirement are unsupported. The installer provides full management of the machine and its components. Typically this environment would be managed as a virtual machine.

Currently the installer supports an unconfigured, out of the box CentOS 7 installation only.

Recommended machine specifications are:
* 2 CPU
* 4GB RAM
* 10GB+ partition for OS

This machine must be configured with:
* Public IP address, with inbound access on ports 80, 443 and 8443
* DNS entry for this host. Typically you’d set this as `idp.yourhost.edu`
* Internet access (the installation process automatically fetches dependencies over HTTP / HTTPS)
* root access via SSH

The installer will set up the following:
* Jetty 9.2
* Shibboleth 3.1.1
* MariaDB (latest version, 5.5.44 at the time of writing this document)
* Apache (latest version, 2.4.6 at the time of writing this document)
* NTP (latest version, 4.2 at the time of writing this document)

# Running the installer

1. The installer has been designed get you up and running with an IdP as rapidly as possible. To get started, run the following commands from your target machine (as root):
```
curl https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/master/bootstrap.sh > bootstrap.sh
chmod u+x bootstrap.sh
```
2. Open bootstrap
```
vi bootstrap.sh
```
   - You *must* review, configure and uncomment each field listed in the `MANDATORY SECTION`
   - Optionally you may configure the `OPTIONAL SECTION` for LDAP support. Currently only non TLS LDAP connections are supported. Please note that you can still configure LDAP at a later stage.
3. Run bootstrap.sh:
```
./bootstrap.sh
```

The bootstrap process will:
* Perform a `yum -y update` (system wide package upgrade)
* Install ansible, git
* Authorize the machine so it can SSH to itself (required for ansible)
* Create self signed keys for apache to get started. Replacing these keys is documented [here](## Setting your apache certificates).
* Install Shibboleth IdP
* Open firewall ports 80, 443 and 8443

The bootstrap makes assumptions have been made to start you off however typically you’d need to configure a few more things before your IdP is functional. The next section outlines this configuration.

---

# Configuring your IdP

## IdP configuration

## Apache certificates

## Branding

## ECP

If you require ECP, set the back-channel certificates:
- $IDP_HOME/credentials/idp-backchannel.crt as an additional certificate for signing
- $IDP_HOME/credentials/idp-encryption.crt as an encryption certificate.

LDAP connection strings/values are required in /etc/httpd/conf.d/idp.conf (<Location /idp/profile/SAML2/SOAP/ECP> section)


---

# Backup / resilience

The IdP installer provides no backup or monitoring of the platform. It is **strongly suggested** that deployers configure:
* Regular backups (VM, Database etc)
* Monitoring of service availability
* Monitoring of platform concerns, such as disk space and load average

**N.B.** Shibboleth IdP installer requires private key and cookie encryption passwords. These are generated automatically during the playbook run. **We strongly recommend making a copy of the generated `passwords` directory after running the playbook**.

# Common commands
`systemctl restart idp`.

