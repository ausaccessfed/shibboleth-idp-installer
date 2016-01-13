# Change Log

## [1.0.0-beta.1+idp-3.2.0](https://github.com/ausaccessfed/shibboleth-idp-installer/tree/1.0.0-beta.1+idp-3.2.0)

[Full Changelog](https://github.com/ausaccessfed/shibboleth-idp-installer/compare/1.0.1-alpha.2+idp-3.1.2...1.0.0-beta.1+idp-3.2.0)

**Merged pull requests:**

- Feature/idp3.2.0 [\#82](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/82) ([trsau](https://github.com/trsau))

## [1.0.1-alpha.2+idp-3.1.2](https://github.com/ausaccessfed/shibboleth-idp-installer/tree/1.0.1-alpha.2+idp-3.1.2) (2015-10-08)
[Full Changelog](https://github.com/ausaccessfed/shibboleth-idp-installer/compare/1.0.0-alpha.2+idp-3.1.2...1.0.1-alpha.2+idp-3.1.2)

**Fixed bugs:**

- Protection and Ownership not set correctly on first run [\#76](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/76)
- Bootstrap execution prevention needs to be 2 methods [\#70](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/70)

**Merged pull requests:**

- Ensure IdP credential permissions set correctly [\#77](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/77) ([rianniello](https://github.com/rianniello))

## [1.0.0-alpha.2+idp-3.1.2](https://github.com/ausaccessfed/shibboleth-idp-installer/tree/1.0.0-alpha.2+idp-3.1.2) (2015-09-30)
[Full Changelog](https://github.com/ausaccessfed/shibboleth-idp-installer/compare/1.0.0-alpha.1...1.0.0-alpha.2+idp-3.1.2)

**Implemented enhancements:**

- Have ansible-playbook run locally [\#67](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/67)
- Document additonal certs for FR 2.5 creation process once released [\#55](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/55)
- logback.xml changes in assets not changed in IdP config after update [\#54](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/54)
- Change how the Shibboleth install.sh is called [\#53](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/53)
- Refresh ansible config from git flag [\#52](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/52)
- REDHAT compatibility [\#50](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/50)
- Option to define a re-direct URL for the server [\#45](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/45)
- No information is provided about registering the ECP endpoint in FR. [\#44](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/44)
- Not the latest version of Shibboleth IdP [\#43](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/43)
- Is it safe to re-run the bootstrap.sh script a second or subsequent time? [\#42](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/42)
- WARNING headers in files [\#38](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/38)
- README or WARNING files [\#37](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/37)
- How to integrate local services - missing doco [\#36](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/36)
- Additional Customisation doco [\#35](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/35)
- Confirm update [\#34](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/34)
- Too many messages [\#33](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/33)
- Investigate providing mirrors for files [\#10](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/10)

**Fixed bugs:**

- Distribution logback.xml file is broken [\#69](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/69)
- Skipping optional LDAP configuration causes the installer to fail [\#62](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/62)
- logback.xml changes in assets not changed in IdP config after update [\#54](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/54)
- Certificates in Assets not overwriting IdP certs in Credentials [\#51](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/51)
- Turn off TRACE method on httpd server [\#48](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/48)
- Turn off Jetty version reporting [\#47](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/47)
- Missing attributes in list of supported attributes in Step 6. [\#41](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/41)
- Attribute Resolver – confusing sourceAttributeID [\#40](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/40)
- Ensure update\_idp.sh always executes in the correct base directory [\#32](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/32)

**Closed issues:**

- Update README.md to point to new documentation [\#31](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/31)
- Set readme.md in develop/master as a landing page [\#29](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/29)
- Ensure bootstrap.sh uses master branch at 1.0 release [\#21](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/21)
- Remove `yum -y update` [\#17](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/17)
- Port 80 is not listening [\#6](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/6)
- Documentation [\#5](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/5)

**Merged pull requests:**

- bootstrap execution protection should be split [\#75](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/75) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Utilise shibboleth ant opts dump expect [\#74](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/74) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Update to Shibboleth IdP 3.1.2 [\#73](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/73) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Default to local ansible run [\#72](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/72) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Remove errant 'i' from logback.xml [\#71](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/71) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Restore previous idp credentials [\#68](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/68) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Apache fails without optional LDAP config [\#66](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/66) ([bradleybeddoes](https://github.com/bradleybeddoes))
- bootstrap from master [\#65](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/65) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Pre alpha2 merge to master [\#64](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/64) ([bradleybeddoes](https://github.com/bradleybeddoes))
- Update FR reg certificiate location instructions [\#63](https://github.com/ausaccessfed/shibboleth-idp-installer/pull/63) ([bradleybeddoes](https://github.com/bradleybeddoes))

## [1.0.0-alpha.1](https://github.com/ausaccessfed/shibboleth-idp-installer/tree/1.0.0-alpha.1) (2015-09-09)
**Implemented enhancements:**

- Stop using FR generated attribute filters [\#12](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/12)

**Fixed bugs:**

- Ensure Ansible does not force overwrite any shibboleth IdP files [\#18](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/18)
- Incorrect example scope [\#9](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/9)

**Closed issues:**

- update-idp.sh should restart idp and apache services after run [\#25](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/25)
- Allow users to run the installer on the VM itself [\#11](https://github.com/ausaccessfed/shibboleth-idp-installer/issues/11)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
