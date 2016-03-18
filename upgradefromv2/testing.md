---
layout: upgrade
---

# Testing Your IdP [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)
Thoroughly testing your IdP is essential before you release it to your users. Any errors found after the release will be mush more difficult to resolve.

###Testing from your desktop
From a desktop where the local hosts file has an entry for the new server with the old name.

- Windows: ***C:\Windows\System32\drivers\etc\hosts***
- Linux: ***/etc/hosts***

Continuous testing as you progress

- don’t assume it will all work the first time through
- test after every ***upgrade_idp.sh*** script run
- using multiple accounts if possible

###Attribute Validator
Use the [Attribute Validator](https://manager.[test.]aaf.edu.au/attributevalidator/), it's a testing tool provided by the AAF just for this purpose.

- Verify the attributes values match those you recorded at the start of your upgrade.

- Have several people do this test, both before and after the upgrade

*If you get an Error 500 from the Attribute Validator it generally means the SharedToken value has changed for the user.*

###Other Federation Services
Verify against as many services that you have previously visited

Some examples may include:

- [AARNet’s Cloudstor](https://www.aarnet.edu.au/network-and-services/cloud-services-applications/cloudstor)
- [NeCTAR’s research cloud](https://dashboard.rc.nectar.org.au/auth/login/?next=/)
- [AAF’s Federation Registry](https://manager.aaf.edu.au/federationregistry/) 

If you have visited them before you should be recognized at the service, ie the dashboards should contain the same information as if you logged in using your IdPv2

Test ALL of your bi-lateral services.

###INSIDE And OUTSIDE your firewall

Ensure you test your IdP from multiple locations

- On campus
- Off campus - with no VPN
- Off campus - via your VPN

This will ensure all corporate firewalls and IPS systems are configured correctly.

###ECP Testing

Your new IdP will have ECP enabled. You can do some initial testing now, but you will need to do some advanced test after you go live.

For now you can exercise the ECP end point:

https://YOUR.SERVER.DOMAIM.NAME/idp/profile/SAML2/SOAP/ECP

If working correctly you will receive a Dialogue Login Box. If you now enter a valid username you will receive some xml with “An error occurred.” imbedded.

##Next Step
Your new IdP is now fully tested, it's time to [go live](go-live). 