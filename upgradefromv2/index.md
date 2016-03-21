---
layout: upgrade
---
#IdP v2 to v3 upgrade

## Overview [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/_-n06WWEgME)

The AAF have developed this set of documentation together with a set of recorded presentations that will guide you through the process of upgrading from version 2.x to version 3.x of the [Shibboleth](https://shibboleth.net/) IdP. Most sections will have a video guide which can be identified by the YouTube play icon ![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/small-youtube.png). This guides will talk you through the content in the documentation showing how it applies to an actual IdP that is being upgraded.

## Upgrade overview

The AAF recommended testing your upgrade in the test environment first to minimize any production down time. A switch-over to V3 should only take place after thoroughly testing the new system.

The AAF team welcome all feedback and comment from IDP administrators with their experience with their IdPv2 to IdPv3 migration. This all helps improve the software and instructions in the guide making it a more useful tool for the entire community. [Feedback](../about/feedback.html)

## Upgrade Goals

There are two major goals of this upgrade process;

1. To have a new IdP that provides the same functionality as your existing IdP using the latest versions of software available
2. To have an IdP that is simple to upgrade into the future

Using the AAF IdP Installer will allow you achieve both of these goals with minimum effort.  
 
## Outcomes

After the upgrade your new IdP will be secure, running on a fresh operating system and using the latest versions of software.

Your users should not notice any difference when authenticating, unless you update your corporate branding or have used the uApprove feature on your previous IdP.

The new IdP will be much simpler to maintain. The AAF will notify you when a new version of the AAF IdP Installer is available. Upgrade will be as simple as running the update_idp script. This is allow for future enhancements of the IdP to be rolled out across the federation much quicker than currently be done.

## Getting Started

We recommend you start on your test environment to ensure you are comfortable with and understand the upgrade process before proceeding to your production environment. If you don't have a test environment you can clone your production environment, make some minor configuration changes and use that as a test environment. Please contact [AAF Support](mailto:support@aaf.edu.au) if your require assistance cloning your IdP.

This guide provides step by step instructions on upgrading, please complete and test each step before moving on. Again if you are having issues at any point we are here to help.

In some instances your current IdP installation may have some functionality or option that are not covered in this guide. The Shibboleth Wiki [Identity Provider 3](https://wiki.shibboleth.net/confluence/display/IDP30/Home) is a great resource. Please let [AAF Support](mailto:support@aaf.edu.au) know if there are any gaps so we can try and fill them.

Once you’re ready to get started please continue to the [Strategy and Planning](strategy-planning.html) section.