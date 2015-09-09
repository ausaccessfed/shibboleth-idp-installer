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

If you make configuration changes directly within `/opt/shibboleth/shibboleth-idp`, `/etc/httpd` or elsewhere outside of the below structure your installation will become unsupported and you may have difficulties when upgrading.

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

## Customising your Shibboleth IdP

From this directory you can make changes to customise the following areas as appropriate for your environment:

- Apache certificates and config
- IdP configuration (xml / properties)
- IdP branding (velocity templates, css and images).

## Applying customisations to the Shibboleth IdP

After any changes are made you must run the command:

```
/opt/shibboleth-idp-installer/repository/update_idp.sh
```

This will merge the changes you've made as required and reload the Shibboleth IdP to apply them.

## Next Step

Once you've finalised customisations please continue to the [operation](operation.html) stage.
