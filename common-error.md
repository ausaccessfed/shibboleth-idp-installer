---
---

# IdP3 Installer – Common Errors

Following are the common errors identified by the users when installing the IdP3 with the AAF installer.

### 1. Missing EPEL Packages and other Redhat libraries

--> Finished Dependency Resolution
Error: Package: ansible-1.9.2-1.el7.noarch (epel)
Requires: python-jinja2
You could try using --skip-broken to work around the problem
You could try running: rpm -Va --nofiles –nodigest

Resolution: If you are using Redhat Satellite for your package management, you need to install the Redhat server-extras and server-optional channels.

You can find the list of installed packages by running the command

```
rhn-channel --list

epel_rhel7_x86_64
rhel-x86_64-server-7
rhel-x86_64-server-optional-7
rhel-x86_64-server-supplementary-7
rhel-x86_64-server-extras-7

```


The AAF installer uses the ansible package. This package is available in the EPEL package library. It has a dependency of python-jinja2, which is in the server-optional package library as shown below.

```
yum list ansible python-jinja2

This system is receiving updates from RHN Classic or Red Hat Satellite.
Installed Packages
ansible.noarch         1.9.4-1.el7       @epel7-x86_64
python-jinja2.noarch   2.7.2-2.el7       @rhel-x86_64-server-optional-7

```
