---
---

# IdP3 Installer – Common Errors

Following are the common errors identified by the users when installing the IdP3 with the AAF installer.

### 1. Missing EPEL Packages and other Redhat libraries

--> Finished Dependency Resolution

***Error:*** Package: ansible-1.9.2-1.el7.noarch (epel)

Requires: python-jinja2

You could try using --skip-broken to work around the problem.

You could try running: rpm -Va --nofiles –nodigest

***Resolution:*** If you are using Redhat satellite for your package management, you need to install the Redhat server-extras and server-optional channels.

You can find the list of installed packages by running the following command.

```
rhn-channel --list

epel_rhel7_x86_64
rhel-x86_64-server-7
rhel-x86_64-server-optional-7
rhel-x86_64-server-supplementary-7
rhel-x86_64-server-extras-7

```


The AAF installer uses the ansible package. This package is available in the EPEL package library.It has a dependency of python-jinja2, which is in the server-optional package library as shown below.

```
yum list ansible python-jinja2

This system is receiving updates from RHN Classic or Redhat Satellite.
Installed Packages
ansible.noarch         1.9.4-1.el7       @epel7-x86_64
python-jinja2.noarch   2.7.2-2.el7       @rhel-x86_64-server-optional-7

```


### 2. Firewalld Error

TASK [Enable firewalld]

************************************************************

fatal: [idp.node1]: FAILED! => {"changed": false, "failed": true, "msg":

***Error when trying to enable firewalld: rc=1 Failed to execute operation: No such file or directory\n”}***

to retry, use: --limit @site.retry

PLAY RECAP

*************************************************************
ok=127  changed=25   unreachable=0    failed=1



The task is trying to enable the firewalld to start at system boot time.

A number of things to check first,

```
###To check the status of the firewalld process

systemcl status firewalld

###If not loaded, try to enable the firewalld manually by running

systemctl enable firewalld

###If the firewalld is not installed, try to install it manually by running

yum install firewalld

systemctl enable firewalld

```




### 3. RPM missing certificate for ansible package

Warning:

********************************************************

/var/cache/yum/x86_64/7Server/epel_rhel7_x86_64/packages/ansible-1.9.4-1.el7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY

***Public key for ansible-1.9.4-1.el7.noarch.rpm is not installed***

To resolve the above error, use the “nogpgcheck” option to your bootstrap file for ansible package and re-run the bootstrap script.

```
yum -y --nogpgcheck install ansible

```


### 4. LDAP authentication module missing (mod_ldap)


***Error:*** No Package matching 'mod_ldap' found available, installed or updated

TASK [Install required packages]

********************************************************

2016-05-25 17:32:21,518 p=29393 u=root |skipping: [login-dev-node1] =>

(item=[u'httpd', u'mod_ssl', u'mod_ldap', u'java-1.8.0-openjdk', u'java-1.8.0-openjdk-devel', u'mariadb-server', u'mariadb-devel', u'mariadb', u'MySQL-python', u'ntp', u'expect'])


NO MORE HOSTS LEFT

************************************************************
to retry, use: --limit @site.retry

PLAY RECAP

*************************************************************

ok=4    changed=2    unreachable=0    failed=1
In the Red hat system, the LDAP authentication modules are available in the Red hat optional channel.The Redhat optional channel “ rhel-x86_64-server-optional-7” is required if you are using the RHN package management system.




### 5. Define the LDAP server with ldap:// in the bootstrap.sh file throw a sed error

***Error:*** sed: -e expression #1, char 72: unknown option to `s’

The error is caused by using the “ldap://” protocol with your LDAP server in the bootstrap file.

You should only use the host name of your LDAP server and the port number. The installer will put the value in the correct place in the IdP configuration.

In the bootstrap file under the optional section, set the LDAP settings as follows.


```

###For LDAP

LDAP_HOST="IP_ADDRESS:389”

###For LDAPS

LDAP_HOST="IP_ADDRESS:636”

```
The second thing to check is that the attribute used for the LDAP user search, the LDAP_USER_FILTER_ATTRIBUTE should only have the name of the attribute.


```
For eg: LDAP_USER_FILTER_ATTRIBUTE="sAMAccountName"

```



### 6. Missing IdP configurations or Installer failed to copy the IdP configuration files to the installer directory.


TASK [Set Shibboleth relying-party.xml]

******************************************************

fatal: [idp-node1]: FAILED! => {"changed": false, "failed": true, "msg": "could not find src=/opt/shibboleth-idp-installer/repository/assets/idp-node1/idp/conf/relying-party.xml"}
to retry, use: --limit @site.retry

PLAY RECAP

**********************************************************
ok=103 changed=16 unreachable=0 failed=1


If the installer failed to copy all the IdP configuration files, run the “update_idp.sh” with  -u switch, which will copy the missing files across.

```
update_idp.sh -u

```
### 7. AAF Attribute Validator returning 500 - Internal Error


The error generally means the auEduPersonSharedToken value has changed since user last logged in.The sharedToken value is generated by the sharedToken Data Connector. The IdP uses a salt value in the creation of this attribute and this value must match the value used by your old IdP.You need to copy the salt value from your old IdP configuration and update the salt value in this file /opt/shibboleth-idp-installer/repository/passwords/YOUR.SERVER.DOMAIN.NAME/aespt_salt. Then re-run the update_idp.sh script to update the current configurations.

When user first logged in it will create an entry in the table tb_st. This value will be used even if you change the salt value. You can either update your value in the database and re test with the attribute validator or remove the value and check that the correct value is being created using the correct salt value.




### 8. Bootstrap script failed with error

***fatal:*** [idp-test.edu.au]: UNREACHABLE! =>

The bootstrap.sh script is designed to run once to setup the installer. It creates a lock file /root/.lock-idp-bootstrap to ensure that it only runs once. If you need to re run the installer, delete the lock file and the contents of /opt/shibboleth-idp-installer first and then run the bootstrap.sh script again.



***Note:*** If you make any changes to the configuration, you need to run the ***update_idp.sh*** script not the bootstrap script.



### 9. MySQL database error after importing the old data from V2 server

***Error:*** [net.shibboleth.idp.saml.nameid.impl.JDBCPersistentIdStoreEx:498] - Stored Id Store: Exception verifying database
java.sql.SQLException: Duplicate insertion succeeded, primary key missing from table at net.shibboleth.idp.saml.nameid.impl.JDBCPersistentIdStoreEx.verifyDatabase(JDBCPersistentIdStoreEx.java:827.
The database was not reachable or was not defined with an appropriate table + primary key


The above error is indicating that you have copied the old database structure from V2 server. The shibpid table structure has changed from V.2.x to V.3.2.1 which requires modification to your current database structure.^M^M
To check the current table structure, run following commands.


```
DESCRIBE shibpid;

SHOW INDEX FROM shibpid;

SELECT COUNT (*) FROM shibpid;

```



If you need to update your database structure to meet with V3 requirement, follow the below instructions.

1.Create a full backup of the current database.

2.Shutdown all IdP instances.

3. Login to MySQL console.

4.Run the following commands to rename the current table, create a valid new table and migrate existing data.



```
RENAME TABLE shibpid TO shibpid_old;

CREATE TABLE shibpid (localEntity VARCHAR(255) NOT NULL,peerEntity VARCHAR(255) NOT NULL,persistentId VARCHAR(50) NOT NULL,principalName VARCHAR(50) NOT NULL,localId VARCHAR(50) NOT NULL,peerProvidedId VARCHAR(50) NULL,creationDate TIMESTAMP NOT NULL,deactivationDate TIMESTAMP NULL,PRIMARY KEY (localEntity, peerEntity, persistentId)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

*** Run the following command to dump your original shibpid table.

mysqldump -u idp -p -h mysql-server idp --max_allowed_packet=512M --complete-insert > new_dump.sql

```

Once you successfully import the data , restart the IdP  and verify the logs for any errors.

### 10. Can’t get Shared Token generation working against Active Directory, getting a ResolutionException error regarding sAMAccountName.

If the SharedToken DataConnector defines the SOURCE_ATTRIBUTE_ID=sAMAccountName but does not define an AttributeDefinition for the sAMAccountName then it will fail complaining that it could not resolve a value for the sAMAccountName.

The workaround is adding an AttributeDefinition for the sAMAccountName in the attribute-reslover.xml.

```

<resolver:AttributeDefinition xsi:type="ad:Simple" id="sAMAccountName" sourceAttributeID="sAMAccountName">
    <resolver:Dependency ref="ldap" />
</resolver:AttributeDefinition>

```
