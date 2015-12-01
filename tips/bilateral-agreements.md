---
---

# Bilateral Agreements

To support establishing bilateral agreements with services that exist outside of the federation the installer provides the following directories:

* `assets/<hostname>/idp/bilateral/credentials` - Any unique credentials you require to establish a relationship
* `assets/<hostname>/idp/bilateral/filters` - A set of custom attribute filters for providing user identity to your partners
* `assets/<hostname>/idp/bilateral/metadata` - A set of metadata files representing the partners you're connecting to

The files located in these directories will be correctly merged to the Shibboleth IdP directories of `credentials`, `conf` and `metadata` during an update process.

To complete your bilateral agreement configuration the files in `assets/<hostname>/idp/conf` will be of use.

You can learn more about advanced Shibboleth IdP configuration through the [official Shibboleth documentation](https://wiki.shibboleth.net/confluence/display/IDP30/Configuration).
