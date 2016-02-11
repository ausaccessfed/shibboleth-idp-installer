---
layout: upgrade
---

# Make entityIDs Match

- Change the entityID in /opt/shibboleth-idp-installer/repository/host_vars/home.name
- Remove everything under /opt/shibboleth
  - Will fix entityId in local metadata entry
  - Will fix entityId in idp.properties
  - Should fix entityIds in the IDPs certificates (but does not currently)
- Run the update_idp.sh script

