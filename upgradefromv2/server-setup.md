---
layout: upgrade
---

# Server Setup [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/y5hRz3DAhB4)
The server on which you will be installing your new IdP v3 and migrating your v2 configuration to MUST meet the requirements set out in the [Install Guide - Requirement Checklist](http://ausaccessfed.github.io/shibboleth-idp-installer/requirements-checklist.html "Requirements Checklist").

## Additional Requirements ##
1. Add a temporary entry to /etc/hosts with the IP address of the new server and the hostname of the old server.

     `nnn.nnn.nnn.nnn   oldidp.example.edu`
 
2. Ensure your new server can access your LDAP or Active Directory server.

## Install Base IdPv3

Use the IdP v3 Installer to install a base IdP in preparation for modification to replace your old IdP.

When editing the bootstrap.sh script use the values for the following variables:

| Variable | Value |
| -------- | ----- |
| HOST_NAME | The DNS Name of your old IdP server |
| ORANISATION_NAME | The same name that has been assigned to the 'o' attributes in your old IdP. This will generally be defined within the Static Connector in *attribute-resolver.xml* |
| ORGANISATION_BASE_DOMAIN | The same value that has been used for the scope of your scoped attributes in the *attribute-resolver.xml* files
| HOME_ORG_TYPE | Same value used in your old IdP. This will generally be defined within the Static Connector in *attribute-resolver.xml* |
| SOURCE_ATTRIBUTE_ID | Same value used for *sourceAttributeID* in your StoredID Data connector in *attribute-resolver.xml* |
| LDAP_HOST | The Host name from the *ldapURL* in *login.conf*. Ensure you remove the "*ldap://*" and append a port number. If the port is not shown in the ldapURL it will generally be 389 |
| LDAP_BASE_DN | Same value as *baseDN* in *login.conf* |
| LDAP_BIND_DN | Same value as *serviceUser* in "login.conf |
| LDAP_BIND_DN_PASSWORD | Same value as *serviceCredential* in *login.conf* |
| LDAP_USER_FILTER_ATTRIBUTE | The name of the attribute that is in *userFilter* in *login.conf* |


Execute the bootstrap.sh script. The script should announce that it is finished "**Bootstrap finished!**" and inform you of steps required to complete the install. Do **NOT** follow these steps.

Your server now has a functioning Shibboleth IdP v3 running. It's now time to move onto [configuration and data](config-and-data.html) migration.
 