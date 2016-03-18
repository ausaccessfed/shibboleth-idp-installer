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
| Affiliation* | AAF Core | Directory (eduPersonAffiliation) and script the helps ensure the correct values are sent | 
| Scoped Affiliation | AAF Core | Affiliation attribute with the IdPs scope appended |
| UID | Optional | Directory (uid) |
| eduPersonPrincipalName | Oprional | Directory (uid) with the IdPs scope appended | 
| Given Name | Optional | Directory (givenName) |
| Surname | Optional | Directory (sn) |
| Home Organisation Type | Optional | Statically defined - Same value for all users |
| Home Organisation | Optional | Statically defined - Same value for all users |

\* The Affiliation can be created in many different way, follow the links to see example scripts

- [Group membership](affiliation-group)
- [Distinguishing attribute values](affiliation-attribute)
- [LDAP Hierarchy](affiliation-hierarchy)

There may be other attributes the need to be added to your attribute resolver.

For attributes taken directly from your directory you should be able to copy the *AttributeDefinition* for the attribute from your old IdP.

For scripted attributes there have been changes to the scripting language. Most attribute scripts should be able to migrated with only minor changes to the script. Please refer to the Shibboleth [Scripted Attribute Definition](https://wiki.shibboleth.net/confluence/display/IDP30/ScriptedAttributeDefinition) documentation when migrating and modifying your scripts.

When modifying the *attribute-resolver.xml* edit the one in the directory */opt/shibboleth-idp-installer/repository/assets/idpme.trsau.gq/idp/*. Rerun the *update_idp.sh* script to deploy.**

## Attribute Filters [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](https://youtu.be/SKjWsnpWH-8)

The method of attribute filtering is changing as has been aligned with migration to version 3 of the IdP. Attribute release rules are now being published in the AAF Federation metadata. A generic attribute filter is provided by the AAF IdP installer.

## Bi-Lateral Services [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

###What are Bi-Lateral Services?
Bi-lateral services are any services that are not provided by the AAF, this includes

- Services manually added to the IdP
  - Local organisation only services
- Software or Platform as a service 
  - Google Apps
  - Office 365
- Part of another federation
  - This is slightly different. Your IdP appears in multiple federations.

###Additional files
You may need to add some additional files to your IdP’s  configuration.

- Metadata files - The metadata of non federation services.
- Verification certificates - Used to verify the metadata of the service or other federations
- Attribute filters - Attribute release files for your non federation service.


In the directory shown below you will find three sub-directories that will hold each of the file types listed above

    /opt/shibboleth-idp-installer/repository/assets/[YOUR.SERVER.DOMAIN]/idp/bilateral

When you re-run the *update_idp.sh* script it will copy these files to the running IdPs configuration.

### Metadata Configuration
Adding Metadata to your IdP, use the file:

    /opt/shibboleth-idp-installer/repository/assets/YOUR.SERVER.DOMAIN.NAME/idp/conf/metadata-providers.xml

For each new Metadata source add a new section. For example to load metadata from a local file.

    <MetadataProvider id="MyMetadata"
    xsi:type="xsi:type="FilesystemMetadataProvider" 
    metadataFile="%{idp.home}/metadata/myMetatdata.xml"/>

Other options are available from the [Shibboleth Wiki](https://wiki.shibboleth.net/confluence/display/IDP30/MetadataConfiguration).

###Verification certificates 

You may need a Certificate to validate the authenticity of the Metadata file. For example – Loading Metadata from a third party site: The following is added to your MetadataProvider. 

    <MetadataFilter xsi:type="SignatureValidation"
        certificateFile="{{ shib_idp.home }}/credentials/your-metadata-cert.pem" 
        requireSignedRoot="true">
    </MetadataFilter>

Reference the signing certificate that you previously added to the bilateral/credentials area, *your-metadata-cert.pem*.

###Attribute filters
To release attribute to bilateral services you will require additional attribute filters for each service. These files need to be added to the IdPs configuration.  Add a reference to to the file:

    /opt/shibboleth-idp-installer/repository/assets/YOUR.SERVER.DOMAIN.NAME/idp/conf/services.xml

Example:

    <util:list id ="shibboleth.AttributeFilterResources">
       <value>%{idp.home}/conf/metadata-based-attribute-filter.xml</value>
       <value>%{idp.home}/conf/attribute-filter.xml</value>
       <value>%{idp.home}/conf/your-attribute-filter.xml</value>
    </util:list>

Reference the attribute-filter that you previously added to the bilateral/filters area, *your-attribute-filter.xml*

###Informing your bilateral SPs
Your new IdP will have new certificates and possibly other modifications to its Metadata.

To ensure these services will continue to function you must send the a new version of your Metadata.

- Before the transition – with both set of certificates (New and Old)
- After the transition – with only the new certificates

When every the SP loads the new Metadata you should verify the service still work correctly, otherwise you users will complain.

You can obtain a copy of your current Metadata from the AAF Federation Registry.


## Branding [![](https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/gh-pages/images/youtube.png)](#)

###What the user sees
Your IdP is just a Web application. What the user sees will be influenced by
The style

- Logos and images
- Links
- Content

The content is fairly simple, it’s just a form that asks for the Username and Password.
The rest of the page it there to make the user feel comfortable providing this information.

This presentation is a check list of common elements that we recommend appear on your IdP to help your users feel confident that they are giving their username and password to their organisations federation login page.

###The Out-of-the-box Login page
The installer provides functioning login page out-of-the-box (shown right)

- Velocity Template
  - Simple HTML
  - Access to configuration
  - Access to internal information
- Page split into sections
  - **\<div class=“…”\>**

To edit:

    /opt/shibboleth-idp-installer/repository/assets/YOUR.SERVER.DOMAIN.NAME/idp/branding/views/login.vm


###The Login page
The title applied to your IdP can be found in the file ***error-messages.properties*** and defaults to
***{{ organisation_name }} Login Service***

To change the title modify the ***idp.title*** text. This will change the page title changes for all IdP pages.

\* *To apply this and other branding changes run the update_idp.sh script*

###Sections
The login page is divided into a number of sections allowing individual styling to be applied. The sections are;

| -------------- | ---- |
|wrapper | The entire page |
|container | An area in which all of the page content is held |
|header | The page header - holds your organizations logo | 
|content | The main content of the page. The is then divided into two columns |
|column one | Form for the user to input their username and password | 
|column two | support links |
|footer | The page footer | 


###The Organisation logo
The ***error-messages.properties*** file defines the location of the main logo image file.

- Change the location
= Or replace the file ***images/logo.png***

The IdP main logo changes for all pages.


###The service provider
The login page can display the name and icon of the service provider if they are available.

- Data provided via Metadata
- IdP already configured

If available the logo and description will appear under the Login-in button in the “column one” section.

###Text and Links
The ***auth-messages.properties*** file contains the labels for the links in the “column two” section.
The link references can be found in the ***login.vm*** file.

These links should be to user support pages within your organisation.

- Forgot your password?
- Need Help?

Others can easily be added

###Style – Colours and Fonts
There are two .css style sheets provided with the IdP.

- ***main.css*** – applies to most pages
- ***consent.css*** – only applies to the Consent page

Applies colours, fonts and spacing to the pages. Modify to match your organisations style.

You may need the assistance of your web team!

###Page options
The ***auth-messages.properties*** file contains the labels for the check boxes in the “column one” section.

Don't Remember Login

- Tells the browser not to cache the users input.

Clear prior granting of permission for release of your information to this service.

- removes previous consent decisions


###The Consent page
Lists the user’s attributes that are to be released to the SP the user is attempting to login to.

Options provided on how to deal with page in future. User select from…

- Ask every time
- Ask only if something changes
- Never ask again

If the user Rejects they will be blocked from Accessing the service.

File:   ***views/attribute-release.vm***

###Changing attribute names
The name of each attribute can changed. To do so you need to edit the ***attribue-resolver.xml*** file which can be found in the ***idp/conf*** area.

For each Attribute add a ***DisplayName*** element. It must be added after the ***resolver:Dependency***

    <resolver:AttributeDefinition xsi:type="ad:Simple" id="givenName" sourceAttributeID="givenName">
    <resolver:Dependency ref="ldap" />
    <resolver:DisplayName xml:lang="en">First Names</resolver:DisplayName>
    <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:dir:attribute-def:givenName" encodeType="false" />
    <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:2.5.4.42" friendlyName="givenName" encodeType="false" />
    </resolver:AttributeDefinition>
    
This example we change givenName to First Names for the purpose of displaying on the consent page.

###Consent page wording
Most of the wording on the consent page can be modified in the ***branding/consent-messages.properties*** file.


###The Reject message
The message shown to the user if they select “Reject” can be found in the file ***branding/error-messages.properties***


###Error pages - Shibboleth
The Text for the IdP errors can be found in the file ***branding/error-messages.properties***

The layout of the error page can be found in the file ***views/error.vm***

You should consider adding local information to this page, for instance, contact information to your support desk.

###Addition files
If you have additional file, for example

- Images
- Style sheets
- Font files

They can be added to the ***branding/css*** or ***branding/images*** directories and will be copied over to the running IdP when you run the ***upgrade-idp.sh*** script.


##Next step

Your new IdP is fully configured and branded, almost ready to go. It's now time to thoroughly [test your IdP](testing). 






