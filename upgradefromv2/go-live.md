---
layout: upgrade
---

# Go Live [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

###READY to go live
Your ready to go live…

- The new server has been built, configured and tested
- Your change board has approved the change request
- The change has be scheduled in your maintenance window
- Notifications have gone out to stakeholders 
- The DNS team are ready to change the entry for your IdP
- The Time-to-Live (TTL) set a small number of minutes
- …

Whatever processes your organisation has for the approval of changes to your software infrastructure need to be followed! 

###Changing the DNS ENTRY
The only change that occurs for go-live is a DNS entry change. Your SERVER.DOMAIN.NAME entry will get a new IP address, the IP address of your new server.

The TTL for the domain name will determine the speed at which the change is noticed across the Internet. It should be small, 5 or less minutes.

As the change propagates users will being using the new IdP.

Users logged in prior to the change may have to login again after.

###Testing the Live IdP
After you flip the DNS entry you should re-test

Check you attributes at the Attribute Validator

Use [SSL-Labs](https://www.ssllabs.com/ssltest/) to check the configuration of your Server. You should get an ***A*** or better.

###Final Testing - ECP
The ECP Authentication could not be fully test when your old IdP was active because a third server is required. The third server is an AAF SP configured for test IdP ECP authentication and attribute release. Until you change DNS it will be trying to test your old IdP.

Instructions for test ECP can be found in the “End to End testing” section of the [Enabling ECP support](http://wiki.aaf.edu.au/tech-info/identity-provider/enabling-ecp-support) document in the AAF technical wiki.

###ROLLING Back
To rollback just change the DNS for the IdP server entry back to its original value.

The TTL on the DNS entry will determine how quickly the rollback will occur.

###CLEANING UP
The IdP is active there are some clean up activities thet need to be attended to.

- Additional SAML end points – ECP

    If your old IdP did not have ECP configured you need to add an ECP end point to the federation registry.  Once done SPs will be able to begin using it.

- Remove Old Certificates

    The certificates of your old IdP should be removed.  They no longer serve any purpose and may cause issues down the track.

- Additional Attributes

    The new IdP could have enabled some new attributes that are not being released, for example Surname and Given Name. You the federation registry to enable these attributes and make them available to the federation.


###Decommissioning the old IdP
Just in case keep your old IdP around for a few weeks after the new IdP goes live.

If there are no issues after this time it should be safe to decommission the old server.

You may want to 

- Take a copy of the IdP logs
- Backup the old configuration
- Backup the old database
- Take a snapshot of the old server
- ...

##What's next
Software never sits still. There are always patches, enhancements and bug releases to manage.  Go to the next section on [upgrading and maintaining your IdP](upgrading-maintenance).