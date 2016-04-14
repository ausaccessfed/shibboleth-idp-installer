---
layout: upgrade
---
#LDAP Configuration

Your identity directory is an integral part of your IdP installation. This server holds old of your users credentials plus a large number of their attributes.

It does not matter which type of directory you are running, anything from Microsoft's Active directory to and open source directory server such as OpenLDAP. The main requirement is that is support the LDAP protocols.

Your directory service in general will be connected to your Identity management system. This system is responsible for adding, modifying and removing users from your directory based on your business rules for allowing access to services provided by your organisation.

Your IdP needs to communicate with your directory server for two reasons;


1. Verification of the user's credentials (when they attempt to login)
2. As a store for user's attributes  

Your IdP needs to be configured to query your IdP. How this is achieved will be described below.

###IdP LDAP Configuration

There are two places where your IdP must be configured to access your directory server via LDAP.

**IdP**

The majority of LDAP accesses to your directory will use the configuration information in the ***ldap.proprities*** file. Each configuration element has a comment or two above describing what information is required.

See [here for full details](https://wiki.shibboleth.net/confluence/display/IDP30/LDAPAuthnConfiguration) on each configuration option.

**Apache**

Your Apache server needs to perform a Basic Auth for users who are logging in using ECP. Apache will only be preforming the authentication. The IdP will gather up the attributes after a successful login.

in the Apache configuration the file **idp.conf** will contain configuration for authentication to your directory server.
 
For more detail on each of the configuration options see  the [mod_ldap Apache Module](https://httpd.apache.org/docs/current/mod/mod_ldap.html).                                                                                                