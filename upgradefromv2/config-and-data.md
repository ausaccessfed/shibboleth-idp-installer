---
layout: upgrade
---

# Upgrade Overview #

When the upgrade is completed you will have two functioning IdPs. Your existing IdP and the new v3 IdP. The approach is to build the new IdP in parallel with the old and use DNS to change from old to new. This approach has the advantage of being able to rollback to old IdP quickly if some unforeseen issue occurs.

The steps in the upgrade will include

1. Create a new server - specifically for the new IdP

2. Install IdP v3 on the new server
 
3. Migrate configuration and data from old IdP to new

4. Test the new IdP while the old IdP continues to serve auth requests

5. Change DNS so the new IdP is serving auth requests

6. Clean up

The IdP v3 Installer will significantly decrease the amount of time required to perform your upgrades, but it will depending upon how much localization you have on your existing IdP. These localization's include

- Additional attributes beyond the AAF Core and recommended attributes

- Locally registered services - bilateral services

- LDAP configuration

- Local Branding

A upgrade checklist is available [here](http://upgradeckecklist.aaf.edu.au/upgradechecklist.pdf "V2 to V3 upgrade check list"). The items on the check list are in order of completion, each item should be check off before moving on. Skipping a item may have flow-on effects later on in the installation process.
  


