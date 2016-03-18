---
layout: upgrade
---

#Upgrading and Maintenance [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

###Joining the mailing list
The email group ***idp-installer@aaf.edu.au*** has been created which we encourage you to join. 

The following Announcements will be sent from the AAF

- Software Upgrades
- Security patches and bug fixes
- New features

Your can also send your ideas, feedback and questions to this list.

To Join ***[CLICK HERE](https://groups.google.com/a/aaf.edu.au/d/forum/idp-installer)***.

Now that you are at version 3 of the Shibboleth IdP maintaining it should be much simpler.

You have run the ***upgrade_idp.sh*** script numerous time through the migration. This has run Ansible over the same configuration base with the changes you have made to the assets area. The script can also be run in upgrade mode. In this mode it updates the configuration base. This will be all of the changes we have made such as upgrading the IdP or Jetty versions, add new features, etc. It will continue to apply your changes.

We will notify you via the idp-installer@aaf.edu.au email group of these changes.

###The next upgrade
When you receive a notification about an upgrade you should read the change logs and release note carefully - They may contain actions that you need to perform in preparation of the upgrade.

Upgrade your Test Environment first to ensure there will not be any issues for you production environment.

To run the upgrade use the ***-u*** switch on the ***update_idp.sh*** command.

    update_idp.sh -u

When ready upgrade production.

###Feedback and comments
All feedback is most welcome, in particular

- Bugs with the installer
- Error in the documentation or video guides
- Omissions and gaps
- Enhancements and improvements
- Ease of use
- Areas that were difficult to understand or unclear
- Any other comments you may have

Your feedback will help to improve this service for all.

You can send your feedback to [support@aaf.edu.au](mailto:support@aaf.edu.au) or to [idp-installer@aaf.edu.au](mailto://idp-installer@aaf.edu.au) if you wish to discuss with the community.
