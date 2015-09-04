---
---

# Requirements
- Centos 7 target machine with internet connectivity

---

# Installed components
The installer will set up the following:
* Jetty 9.2
* Shibboleth 3.1.1
* MariaDB (latest version, 5.5.44 at the time of writing this document)
* Apache (latest version, 2.4.6 at the time of writing this document)
* NTP (latest version, 4.2 at the time of writing this document)

---

# Running the installer

Running bootstrap
Set Properties
etc
LDAP Properties
etc

---

# Configuring your instance

## Setting your IdP configuration

## Setting your apache certificates

## Branding your IdP

---

# Backup / resilience

The IdP installer provides no backup or monitoring of the platform. It is **strongly suggested** that deployers configure:
* Regular backups (VM, Database etc)
* Monitoring of service availability
* Monitoring of platform concerns, such as disk space and load average

**N.B.** Shibboleth IdP installer requires private key and cookie encryption passwords. These are generated automatically during the playbook run. **We strongly recommend making a copy of the generated `passwords` directory after running the playbook**.

# Common commands
`systemctl restart idp`.

# ECP Support
Adding the backchannel certificate in FR. Taken from https://tuakiri.ac.nz/confluence/display/Tuakiri/Installing+a+Shibboleth+3.x+IdP:

Afterwards, update the registration and add the back-channel certificate $IDP_HOME/credentials/idp-backchannel.crt as an additional certificate for signing and $IDP_HOME/credentials/idp-encryption.crt as an encryption certificate.

LDAP connection strings/values are required in /etc/httpd/conf.d/idp.conf (<Location /idp/profile/SAML2/SOAP/ECP> section)

