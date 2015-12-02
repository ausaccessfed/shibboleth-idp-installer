---
layout: about
---

# Installer version numbering

The version number scheme for the AAF IdP Installer is based on the [Semantic Version 2.0.0](http://semver.org/) guide concatenated with the version of the Shibboleth IdP being installed.

Given a version number **MAJOR.MINOR.PATCH***+idp-MAJOR.MINOR.PATCH*, the first three values will be incremented as follows:

1. **MAJOR** version when the install should be performed on a fresh machine with migration or existing configuration and data.
2. **MINOR** version when the installer used to upgrade an IdP and manual intervention is required to complete the install. For example when a database schema change is required.
3. **PATCH** version when the installer used to upgrade an IdP will run without without any manual intervention.

Additional labels for per-release (alpha and beta) are also used to indicate that the version may be unstable and might not satisfy the intended installation requirements.
 
The version of the Shibboleth IdP is appended to each version for convenience.

**Example**: AAF Idp Installer version number: ***1.1.0+idp-3.2.0***