---
layout: about
---

## About the AAF IdP Installer

The AAF IdP installer, a tool developed by the AAF is aimed at easing the 
effort required to install and maintain a Shibboleth IdP, a key component enabling 
users within your organisation to access the services within the federation.

All software will requires maintenance over its life time. Continuous maintenance
of your IdP will allow you to;

- reduce the risk of security incidents, 
- enable new features when they become available,
- and ensure technical compliance

For existing subscribers in the AAF the installer can significantly reduce the effort required to migrate from version 2 of the IdP. After upgrading from version 2 the installer will help to ensure your are always running the current version of the IdP and supporting software components.

For new subscribers bring identities to the federation the installer will allow you to technically connect your users to services with minimal effort. Again the installer will ensure you are running the latest version of the IdP.

### Technical details

The installer uses software call [Ansible](http://www.ansible.com/) a goal-oriented configuration management tool that is secure and agentless. An AAF  Github repository holds the configuration information. This is used by Ansible to reliably and repeatably configure the IdP avoiding the potential failures from scripting, script-based systems or manually management. All that is needed is your local information. The installer passes this to Ansible which then installs or upgrades your IdP.



### Updates

As new versions of the Shibboleth IdP or any of the underpinning software become  available the AAF creates a new branch in the Github repository and apply changes. All changes go through a though testing and review process before being committed to the repository. On completion of testing a new version of the installer is released.

When a new installer is released notifications will be announced via various channels. 

On receipt of such a notification its time to plan for your local IdP upgrades. First in your test environment to be sure there are no issues and local configuration options continue to work. Next, with approval of your change board upgrade your production IdP.

### General

The IdP Installer is a tool to assist you maintain your IdP. If the tool is not meeting your requirements or you would like to see some improvements we welcome your [feedback](http://ausaccessfed.github.io/shibboleth-idp-installer/about/feedback.html).

If there are any issues experienced when running the tool the [AAF Support team](mailto://support@aaf.edu.au) will be happy to assist.
 