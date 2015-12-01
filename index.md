---
---

# Shibboleth IdP Installer

The Shibboleth IdP Installer automates the install of version 3 for the Shibboleth IdP on a **dedicated** Redhat or CentOS 7 server.

The installer adheres to each step outlined in the offical [Installation Guide](https://wiki.shibboleth.net/confluence/display/IDP30/Installation).

> The key words "MUST", "MUST NOT", "REQUIRED", "SHALL",
> "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL"
> in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

Once you’re ready to get started please continue to the [requirements checklist](requirements-checklist.html).

# Versions

Release: 1.0.1-alpha.2+idp-3.1.2

This release installs the following software

| Software | Version |
| -------- | ------- |
| Shibboleth IdP | 3.1.2 |
| Jetty | 9.210.v20150310 |
| MySQL Connector | 5.1.35 |
| AAF Shared Token Extension | 1.0.0 |

The following components are installed via yum. Versions may vary independent of this installer.

| Software | Version |
|--------- | ------- |
| Apache Web server | 2.4.6 |
| MariaDB database engine | 5.5.44 |
| OpenJDK | 1.8.0_65 |
