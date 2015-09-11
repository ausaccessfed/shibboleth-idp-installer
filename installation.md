---
---

# Installation

You MUST have completed the [requirements checklist](requirements-checklist.html) before continuing installation. Environmental preperation is critical to a successful outcome.

## Actions undertaken during installation

The installation process will:

* Perform a `yum -y update` (system wide package upgrade). Please note that the installer uses `yum` for the installation of all system components (except Jetty and Shibboleth IdP).

* Install all required dependencies via `yum` (`git`, `ansible`, `mariadb`, `apache` etc). With the previous step in mind, bootstrap will always use the latest versions of these packages.

* Create self signed keys for Apache. These are just for the initial testing of your IdP and will be replaced when we later customise the Shibboleth IdP.

* Install Apache.

* Install Jetty with Shibboleth IdP. Jetty runs on port `8080` and creates the Shibboleth IdP web app context `/idp`. Apache is configured to serve this address as `443` through a reverse proxy. Jetty also allows direct access to port `8443` for ECP.

* Install a MariaDB instance. A database is created (name: `idp_db`, user: `idp_admin`) with [these schemas](https://github.com/ausaccessfed/shibboleth-idp-installer/tree/master/templates/db) populated.

* Install NTP for time syncronisation.

* Opens local firewall ports `80`, `443` and `8443`.

## Running the installer

To run the installer please undertake the following steps in order.

The following commands MUST be executed as the **root** user. Start the process from `/root`.

1.  Run the command:

    ```
    curl https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/\
    master/bootstrap.sh > bootstrap.sh && chmod u+x bootstrap.sh
    ```

2.  Edit the bootstrap file:

    ```
    vi bootstrap.sh
    ```
    - You MUST review, configure and uncomment each field listed in the "`MANDATORY SECTION`"
    - If you have LDAP details you SHOULD also configure the "`OPTIONAL SECTION`".

        You MAY further configure LDAP connection details, including TLS if required, after bootstrap has completed.

3.  Run the command:

    ```
    ./bootstrap.sh
    ```

    The bootstrap process will now configure your server to operate as a Shibboleth IdP.

## Errors during installation
Generally the installer **SHOULD only be executed once**.

After the initial execution you'll recieve an error if you try to run `bootstrap.sh` again.

You MUST NOT re-run `bootstrap.sh` if the installation process completed successfully but you made a simple mistake. e.g.

* Mistyped config in the *MANDATORY SECTION*
* Mistyped config in the *OPTIONAL SECTION*

If you force `bootstrap.sh` to run again once initial installation has completed the action MAY be *destructive*.

In this scenario you should continue with federation registration as documented below and then make any configuration
changes necessary as documented within the **configuration stage** following completion of the installation stage.

### Reasons to re-run the installer
The only time `bootstrap.sh` should be re-run is if:

* The script indicates you did not provide all required configuration options before your initial execution
* The underpinning Ansible based installation process fails during installation

If the latter scenario occurs you MUST correct the root cause of the error before attempting to continue.

### Allowing the installer to run again
If you're certain all conditions have been met to run the installer again undertake the following commands:

```
rm /root/.lock-idp-bootstrap && ./bootstrap.sh
```

The bootstrap process will now start over and attempt to configure your server to operate as a Shibboleth IdP.

## Registration with the federation

Once completed the bootstrap process will output information specific to your installation which you will use to register your Shibboleth IdP with the federation. Please follow the onscreen guide in order to complete the registration process.

After completing the registration process, you will receive an email from the federation indicating your Shibboleth IdP is pending approval by the AAF. The approval process can take **upto 24 hours**. For further assistance please contact [support@aaf.edu.au](mailto:support@aaf.edu.au)

## Installation finalisation steps

### 1. Configure LDAP connectivity

If you provided LDAP details to the bootstrap process and you're NOT using TLS connections you MAY skip this section.

1. **Locate local configuration files**

    You MUST make any changes you require below within:

    `/opt/shibboleth-idp-installer/repository/assets/<HOST_NAME>/idp/conf`

    and NOT

    `/opt/shibboleth-idp/conf`

    which is the default path documented in external resources. All specific config files however, e.g. `ldap.properties`, remain the same.

2. **Configure LDAP options**

    Please see the [Shibboleth IdP LDAP](https://wiki.shibboleth.net/confluence/display/IDP30/LDAPAuthnConfiguration) documentation for a description of all available LDAP options.

3. **Apply Changes**

    After any changes are made for your LDAP configuration you MUST run the command:

    ```
    /opt/shibboleth-idp-installer/repository/update_idp.sh
    ```

    This will merge the changes as required and reload the Shibboleth IdP to apply them.

### 2. Recieve Shibboleth IdP Approval

Following approval by the AAF you'll **receive a second email**.

Please wait for at least 4 hours after recieving this email, so backend processes and data sync is definetly completed, before undertaking the instructions it contains to gain administrative rights over your Shibboleth IdP within AAF management tools.

### 3. Add Backchannel certificates

The final installation step simply involves providing your backchannel certificates to the AAF management tool, Federation Registry.

Access your Shibboleth IdP record within Federation Registry, you did this in step 2 above or it is available as a link on your Federation Registry dashboard page, and navigate to *SAML -> Certificates*

1. Paste the contents of `/opt/shibboleth/shibboleth-idp/current/credentials/idp-backchannel.crt` as an additional certificate for signing.
2. Paste the contents of `/opt/shibboleth/shibboleth-idp/current/credentials/idp-encryption.crt` as an encryption certificate.

## Next Step

Once you've finalised installation please continue to the [customisation](customisation.html) stage where we'll test your installation and show you how to tune things as necessary for your environment.
