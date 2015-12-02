---
layout: upgrade
---

# Server Setup #
The server on which you will be installing your new IdP v3 and migrating your v2 configuration to MUST meet the requirements set out in the [Install Guide - Requirement Checklist](http://ausaccessfed.github.io/shibboleth-idp-installer/requirements-checklist.html "Requirements Checklist").

## Additional Requirements ##
1. Add a temporary entry to /etc/hosts with the IP address of the new server and the hostname of the old server.

     `nnn.nnn.nnn.nnn   oldidp.example.edu`
 
2. Ensure your new server can access your LDAP or Active Directory server.

