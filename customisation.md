---
---

# Customisation

## Ensuring your Shibboleth IdP is functioning

Before undertaking any customisation of your Shibboleth IdP and after each change you make to customise your Shibboleth IdP we recommend testing to ensure everything is functioning correctly.

To facilitate this the AAF provides a useful tool, called AAF Attribute Validator. This tool will ensure that your IdP is working correctly with backend security processes and that it is capable of providing the attributes your users may be asked to present when accessing federated services.

A 'private' browser session as the best tool for working with AAF Attribute Validator. Different browsers will have different names for 'private' mode, e.g. Incognito Mode.

To access AAF Attribute Validator:

* Test: [https://manager.test.aaf.edu.au/attributevalidator/](https://manager.test.aaf.edu.au/attributevalidator/)
* Production: [https://manager.aaf.edu.au/attributevalidator/](https://manager.aaf.edu.au/attributevalidator/)

Follow the flow to login, ensuring you choose your new Shibboleth IdP when promoted at the Discovery Service.

## How the Shibboleth IdP installer manages your configuration

**IMPORTANT:** All modifiable configuration is housed in the directory:

```
/opt/shibboleth-idp-installer/repository/assets/<HOST_NAME>
```

The structure of your configuration directory will look like the following:

```
.
├── apache
│   ├── idp.conf
│   ├── intermediate.crt
│   ├── server.crt
│   └── server.key
└── idp
    ├── branding
    │   ├── css
    │   │   ├── consent.css
    │   │   └── main.css
    │   ├── error-messages.properties
    │   ├── images
    │   │   ├── logo-mobile.png
    │   │   └── logo.png
    │   └── views
    │       ├── attribute-release.vm
    │       ├── error.vm
    │       ├── expiring-password.vm
    │       ├── login-error.vm
    │       ├── login.vm
    │       ├── logout-response.vm
    │       ├── logout.vm
    │       └── resolvertest.vm
    ├── conf
    │   ├── attribute-filter.xml
    │   ├── attribute-resolver.xml
    │   ├── global.xml
    │   ├── idp.properties
    │   ├── ldap.properties
    │   ├── metadata-based-attribute-filter.xml
    │   ├── metadata-providers.xml
    │   └── services.xml
    ├── logging
    │   └── logback.xml
    └── sys
        └── jetty-profile

```

If you make configuration changes directly within `/opt/shibboleth/shibboleth-idp`, `/etc/httpd` or elsewhere your installation will become unsupported and you may have difficulties when upgrading.

## Customising your Shibboleth IdP

From the configuration directory you can make changes to customise the following areas as appropriate for your environment:

- Apache certificates and config
- IdP configuration (xml / properties)
- IdP branding (velocity templates, css and images).

### Customisations recommended by the AAF for operating a production Shibboleth IdP
Here are some of the areas you should customise when preparing a Shibboleth IdP for a production environment:

* The Shibboleth IdP MUST use valid certificates, verified by a well known public CA for your Apache webserver

    The use of EV certificates are RECOMMENDED.

* Ensure all attributes on the AAF Attribute Validator are shown with green ticks to indicate successful release
* Branding should be consistent with your organisations corporate branding, images, logos, colour schems, etc
* Corporate links, eg Accessibility, Copyright, Disclaimers, Privacy, etc should be consistent with the corporate site
* The name known by your users for their username / password should be consistently used on the IdP login page
* Links to a corporate terms of use or similar page
* Link provided to recover lost password, manage passwords or other credentials, etc
* Display of the AAF logo and links to the AAF information such as the service catalogue
* Guidance for users about effectively logging out, particularly when using publicly accessible computers
* Minimise and preferably eliminate the use of technical jargon
* Showing the name of the service the user is logging into, possibly the logo as well if it is available

## Applying customisations to the Shibboleth IdP

### Actions undertaken during an update

The update process will merge the changes you've made as required.

This includes running an update of all OS packages and **restarting** all dependant processes.

You MUST have a tested rollback plan in place before running an update to ensure any unanticipated changes can be reversed.

### Executing the update
To update your Shibboleth IdP run the command:

```
/opt/shibboleth-idp-installer/repository/update_idp.sh
```

## Next Step

Once you've finalised customisations please continue to the [operation](operation.html) stage.
