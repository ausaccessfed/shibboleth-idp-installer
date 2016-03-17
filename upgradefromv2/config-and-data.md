---
layout: upgrade
---

# Configuration Migration [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/_PGu0hlcQ-k)

This section details which configuration setting need to be migrated from your old IdP to your new IdP to ensure the new IdP will continue to respond and perform as the old IdP did.

The following content will be covered


- The Entity ID
- Salt values
- Certificates
- Migrating user data
- Attribute Resolution
- Attribute Filters
- Bi-Lateral Services
- Branding

## The entityID [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/api6i6h07ac)

The *entityID* is a string that uniquely identifies your IdP within the federation. It is a [Uniform Resource Identifier (URI)](https://www.ietf.org/rfc/rfc3986.txt). Most IdPs will have an entityID that looks like a web URL something like: 

***https://idp.example.edu.au/idp/shibboleth***

older IdPs will have *entityIDs* that are URNs which are just another form of URI. They will look something like:

***urn:mace:federation.org.au:testfed:example.edu.au***

Whatever your IdP's *entityID* looks like, the new IdP **MUST** have exactly the same entityID.
  
**Finding the entityID**

The *entityID* for your old IdP can be found in the file ***relying-party.xml*** file in the ***conf*** directory. Search for "*provider=*". The following string is the entityID. It should be listed in both the *AnonymousRelyingParty* and *DefaultRelyingParty* config sections.

**Comparing entityIDs**

The entityID for your new IdP can be found in the file 
***/opt/shibboleth-idp-installer/repository/host_vars/****host.name* 
with the identifier of **idp_entity_id:**

***idp_entity_id: "https://idp.example.edu.au/idp/shibboleth"***

If the entityIds do not match proceed to [make entityIds match](make_entityids_match.html) before continuing.

## Copy Salt values [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/dEMo-HTanrE)

Two SALT values are used in your old IdP to generate unique identifier attributes for your users. The attributes are:

- [**eduPersonTargetedId**](http://wiki.aaf.edu.au/tech-info/attributes/edupersontargetedid)
- [**auEduPersonSharedToken**](http://wiki.aaf.edu.au/tech-info/attributes/auedupersonsharedtoken)

The salt values used to generate these values will be found in the *attribute-resolver.xml* file that is in the *conf* directory.

**eduPersonTargetedId**

The *salt* value will be in either the ComputedId data connector or the StoredId data connector.

Replace the value in the file ***passwords/your.server.edu.au/targeted_id_salt*** with the value from your old IdP.

**auEduPersonSharedToken**

The *salt* value will be in  the sharedToken data connector.

Replace the value in the file ***passwords/your.server.edu.au/aespt_salt*** with the value from your old IdP.

## Certificates [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/XzZI7gGgxLE)

Shibboleth IdPs use a number of certificates. With IdP v3 the number of certificates has increased with each now have its own individual role. See [Shibboleth IdP Security and Networking](https://wiki.shibboleth.net/confluence/display/IDP30/SecurityAndNetworking) for more details. 

This section describes the changes to certificate for your IdP that need to occur for the migration to be successful.

**Browser-facing TLS Server Key (unrelated to Shibboleth)**

The certificate that user's browsers will interact with. These are registered with the web server (Apache). There are generally three files that are used;

- key (*SSLCertificateKeyFile*)
- Certificate (*SSLCACertificateFile*)
- Intermediate Certificates (*SSLCertificateChainFile*)

If you wish to use the existing web server certificate for your new IdP you will need to copy across to your new IdP.

Your existing IdP Apache configuration will reference these three files generally in the ssl.conf or idp.conf file.

Alternatively you can obtain a new certificate from your certificate vendor. This is generally going to require a commercially-issued certificate rooted in a CA all browsers will trust.

***The AAF Recommends the use of Extended Validation certificates for the client facing side of your IdP.***

Place the key, certificate and intermediate certificate in the directory and files:

/opt/shibboleth-idp-installer/repository/assets/youd.idp.edu.au/apache

- server.key
- server.crt
- intermediate.crt

Run the update_idp.sh script to deploy the certificates.

**Signing, Back-channel and Encryption keys**

New keys have been created for your new IdP as part of the initial installation. These certificates can safely and should be registered in the federation registry prior to your migration. This will allow the new certificates to propagate out to the federation in preparation for migration.

*There is NO need to copy old Signing, Back-channel and Encryption keys to your new IdP.*

To added these key to the Federation Registry

**Cookie Encryption Key**

This is new to IdPv3. No action is required.

## Migrating User Data [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/kIm6xAsL2xU)

To ensure users do not obtain new identities with service providers in the federation when logging using the new IdP it is essential to migrate identity information created by the old IdP. This will generally be held in the database connected to the IdP. Data from the following tables should be exported from the old and imported into the new.

- shibpid (User's targeted Id values) 
- tb_st (User's Shared Tokens)

You will find the Database connection information in the conf/attribute-resolver.xml file on your old IdP.

The password for the MySQL database on the new IdP can be found in the file */opt/shibboleth-idp-installer/repository/passwords/your.idp.edu.au/mariadb* and the username is *idp_db*

## Attribute Resolution [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

The following table describes the location of where or how attributes are resolved in the IdP created using the default installer. You will need to check to see if you need to make modifications and determine if there are any attributes missing.

| Attribute Name | Type | Resolved from |
| -------------- | ---- | ------------- |
| E-mail | AAF Core | Directory (mail) |
| Display Name | AAF Core | Directory (displayName) |
| Common Name | AAF Core | Script Joins GivenName and Surname |
| Targeted ID | AAF Core | Generated by the IdP and stored in the local database |
| Shared Token | AAF Core | Generated by the IdP by the Shared Token plugin and stored in the local database | 
| Organisation Name | AAF Core | Statically defined - Same value for all users |
| Entitlements | AAF Core | Directory (eduPersonEntitlement) | 
| Assurance | AAF Core | Directory (eduPersonAssurance) |
| Affiliation | AAF Core | Directory (eduPersonAffiliation) | 
| Scoped Affiliation | AAF Core | Affiliation attribute |
| UID | Optional | Directory (uid) |
| Given Name | Optional | Directory (givenName) |
| Surname | Optional | Directory (sn) |
| Home Organisation Type | Optional | Statically defined - Same value for all users |
| Home Organisation | Optional | Statically defined - Same value for all users |

There may be other attributes the need to be added to your attribute resolver.

For attributes taken directly from your directory you should be able to copy the *AttributeDefinition* for the attribute from your old IdP.

For scripted attributes there have been changes to the scripting language. Most attribute scripts should be able to migrated with only minor changes to the script. Please refer to the Shibboleth [Scripted Attribute Definition](https://wiki.shibboleth.net/confluence/display/IDP30/ScriptedAttributeDefinition) documentation when migrating and modifying your scripts.

When modifying the *attribute-resolver.xml* edit the one in the directory */opt/shibboleth-idp-installer/repository/assets/idpme.trsau.gq/idp/*. Rerun the *update_idp.sh* script to deploy.**

## Attribute Filters [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/SKjWsnpWH-8)

The method of attribute filtering is changing as has been aligned with migration to version 3 of the IdP. Attribute release rules are now being published in the AAF Federation metadata. A generic attribute filter is provided by the AAF IdP installer.

## Bi-Lateral Services [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

Stuff here...

## Branding [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

###What the user sees

###The Out-of-the-box Login page

###The Login page

###Sections

###The Organisation logo

###The service provider

###Text and Links

###Style – Colours and Fonts

###Page options

###The Consent page

###Changing attribute names

###Consent page wording

###The Reject message

###Error pages - Shibboleth










