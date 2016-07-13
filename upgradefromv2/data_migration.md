---
layout: upgrade
---

# Data Migration

Migrating user's identity information from your old IdP to your new IdP will involve the exporting of the old data from what data store it is in, possibly converting the data format, then importing the data into the IdPv3 database.

Two user identity attributes need to be migrated, 1. the Targeted Ids and 2 the shared token.

## Migrating Targeted IDs ##

The Targeted Id is a identity attribute value that is created by the IdP for users. The value is composed of three parts separated by the bang '!' character. 

- The entityID of the IdP
- The entityID of the SP 
- A unique value for the User

    https://vho.aaf.edu.au/idp/shibboleth!https://manager.aaf.edu.au/shibboleth!c67f444a-44fb-40dd-ad68-b60315ca3c50

A unique value is created to each service a user visits. A user may therefor have many targetedId values.  

Version 2 of the IdP can be configured to either create, store and retrieve the Targeted IDs in a database or generate on the fly whenever required. If they are generated on the fly there will be no source data.

### No Source data

If the value are being generated on the fly there is no way to migrate the values. In the situation you must configure your new IdP generate the same values for your users. You MUST ensure the following configuration information matches between on your new and old IdP.

- EntitiyID of the IdP
- The salt value 
- The user attribute used  (generally uid or sAMAccountName)

If any of these values are different then the new values users will be different and users may experience issues when logging into services.

   
### Exporting from a database

There have been some minor but significant changes to the database schema that require and export and import of the database. In particular a new primary key has been defined.

Most IdPs are using MySQL and can use the mysqldump command to export the data from their old IdP.

#### Searching for and removing duplicates

Before you begin you should check for and remove any duplicate records that have been created by your IdPv2. These duplicates will cause your import to fail because of the new primary key. In your old database search for duplicates.

    select localEntity, peerEntity, persistentId, count(*) from shibpid group by localEntity, peerEntity, persistentId having count(*)>1;

You may get a few records.

| localEntity| peerEntity | persistentId | count(*) |
|------------|------------|--------------|----------|
| https://idp.example.edu.au/idp/shibboleth | https://service.example.com/shibboleth | n0918433 | 2 |
| https://idp.example.edu.au/idp/shibboleth | https://service.example.com/shibboleth | n0123930 | 2 |
| https://idp.example.edu.au/idp/shibboleth | https://service.example.com/shibboleth | n0097683 | 2 |
| https://idp.example.edu.au/idp/shibboleth | https://other.example.com/ | jones | 2 |

To remove duplicate records from your MySQL database you can use the LIMIT parameter on the delete statement as follows, assuming the count is 2 for the user.

    delete from shibpid where localEntity = 'https://idp.example.edu.au/idp/shibboleth'
           and peerEntity = 'https://service.example.com/shibboleth'
           and persistentId = 'n0918433'
           LIMIT 1;

You will need to perform this for all duplicates.

#### Dump the table data

Use the mysqldump command to export the table data. The mysqldump utility is basic in its utility but is sufficient to perform the task as long as precautions are taken, that is the correct options are selected.

To dump the database assuming the database schema name is 'IDP', the table name is 'shibpid' and the database user is 'idp_user' use the following command to create and import file.

    mysqldump -u idp_user -p -h localhost --no-create-info --complete-insert IDP shibpid > shibpid.sql

The file shibpid.sql will be created and used to import the data into the new schema / table.

- --no-create-info ensures that the new table will not be deleted and replaced with the old table definition.
- --complete-insert ensures the data will be imported into the correct columns even if the ordering of the columns in the new shibpid table is different.

#### Importing the data

To import the data into your new schema and table use the following command.

    mysql idp_db < shibpid.sql

This will import all the records into the shibpid table in the ipd_db schema.

You should check that the expected number of records where added and the data was inserted into the correct columns.

To check the number of rows in the table.

     select count(*) from shibpid;

Ensure that the data has loaded into the correct columns 

     select * from shibpid limit 10;

| Column Name | Description | Examples values |
|-------------|-------------|-----------------|
| localEntity | The entityID of your IdP |https://idp.example.edu.au/idp/shibboleth |
| peerEntity | The entityID of services the user has visited | https://example.org.au/shibboleth |
| persistentID | The unique value created by the IdP for each Service / User pair | FZDnWTXTNSUlSQ5h17NEKc6YiKM= |
| principalName | The UID or username of the user | jones |
| localId | The UID or username of the user | jones |
| peerProvidedId | An Id provided by the service, generally NULL | NULL |
| creationDate | The date the record was created | 2011-12-18 23:54:40 |
| deactivationDate | The date the record was deactivated, generally NULL | NULL |

In some situations the persistentID, prinicalName and localId can be mixed up.

# Migrating auEduPersonSharedTokens
