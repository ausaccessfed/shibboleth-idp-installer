---
layout: upgrade
---

# Upgrading from Shibboleth IdP v2 [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/XZmSsUtLDwo)

Upgrading your Shibboleth IdP v2 to version 3 is not a trivial task and will require planning to ensure your users are not adversly affected. The AAF has been working to reduce the risk and effort involved in installing the new  Shibboleth version 3 as well as developing and testing an upgrade path to assist in the smooth transition from your current version. 

# Why Upgrade? #

Software is continually evolving, providing new functionallity, fixing bugs and security issues and eventually becoming obsolete. Over its life the Shibboleth IdP v2 software that is used be all organisations provideing identities the federation has progresses through these software life cycle phases and is not moving towards obsolesences being repleaced with version 3. To ensure you and your users are not using obsolete potentially insecure software is is essential that you are regularly upgrading.

Shibboleth v2 is scheduled for [End of Life on July 31, 2016](http://http://shibboleth.net/pipermail/announce/2015-May/000112.html "Shibboleth IdP V2 End-of-Llife dates"). All IdPs should plan to upgrade before this date.

# Before you begin #

It is ESSENTIAL that your fully read and understand this upgrade documentation and the installer documentation before you being your upgrade.

# The Strategy

## Simple overview

- Build and test your new IdP in parallel with your existing IdP.
- When ready change DNS 
- Users are directed to your new IdP

## In more detail

**Build your new IdP**

On a new server that meets the requirements of the IdP installer, use the IdP installer to create a new IdP. The new IdP needs to be built using the hostname of your old IdP.

Some modifications are needed on the new IdP so it can be a replacement for your old IdP. These include;

- Changing the entityID
- Replacing salts with those used by your old IdP
- Coping user data from your old IdP's database
- Applying your corporate branding
- Adding the new IdP certificates to the federation's metadata

**Testing your new IdP**

Your old IdP is still operational and in use by your users. To test the new IdP a workstation or laptop need to have an entry added to its ***etc/hosts*** file that the name of the old IdP resolve to the IP address of the new IdP. 

A user on this workstation will be directed to the new IdP when they attempt to log in to a service in the federation. Most aspects of the IdP can be tested using workstations that have been modified.

**Making the change**

When you are satisfied your new IdP is functioning correctly a simple change to your DNS server is all that is required to activate your new IdP.

If there are any issues idenfitied after the change it is a simple matter to rollback by changing the DNS entry back to its original value.

**Users begin using the new IdP**

As the DNS change propagates around the Internet your users will begin to be migrate to the new IdP. Setting a fairly low TTL (time to live) on the DNS entry will ensure this does not take long. 

Users who where logged in before the change may need to re-authenticate. 

It is recommended that the change occurs during your normal service change window to minimize the possible impact on users.

Users will also be asked to re-confirm their consent for attribute release to services.

# Planning and communications

Planning and communications is essential for any software upgrade particularly where end users may be affected.

Things to consider when planning your upgrades:

- Do I have a test environment and if so what state is it in.
- How long will it take to get new servers provisioned
- How long does it take for firewall rules to be approved
- Changes to DNS, who is responsible, what is the process
- How do I rollback if something fails
- What other activities are occurring that may affect the upgrade

In addition there are stakeholders and users that may need to be informed about the upgrade:

- Changes board
- Support desk
- Possibly users if the change will adversely affect them
- The AAF - We can put an upgrade notice on the AAF status page
 
The main goal of planning is to map out what you are going to do before you begin doing it. It is recommended that you read and understand all of the steps of installing and upgrading your IdP as part of your planning. This will let you know what to expect as you work through the upgrade.

When you are ready you can begin [preparing your new IdP server](server-setup.html).
  