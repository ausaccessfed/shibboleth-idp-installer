---
layout: upgrade
---

# Data Migration the auEduPersonSharedToken

## Migrating the Shared Token

Your version 2 IdP could have been configured in a number of ways for creating an presenting the auEduPersonSharedToken. The options are generally from one of the following;

| Option | Description |
|--------|-------------|
| Provisioned externally | The Shared token value is created for all users and provisioned into the LDAP directory completely independent of the operation of the IdP. The IdP just retrieves the value from the directory and passes it on|
| Created on the fly | The IdP generates the shared token value every time the user logs on. The value is never stored anywhere. |
| Created and stored in a Database | The IdP generates the shared token the very first time a users logs in. It stores the value in a database for  retrieval on subsequent logins.  |
| Created and stored in the LDAP directory | The IdP generates the shared token the very first time a user logs in. It stores the value in the LDAP directory for retrieval on subsequent logins. |

The new version of the auEduPersonSharedToken plugin for shibboleth v3 now only supports storage in a database. Storage into an LDAP directory has been deprecated. 

Migration of the uses shared tokens for each of the options listed above is described in the following sections.

### Provisioned Externally

There is no need to do any data migration, the shared tokens can continue to be provisioned externally. There are however some changes required to the IdP configuration to retrieve the values from your LDAP rather than using the plugin. All of these changes occur in the attribute-resolver.xml file.

**Disable the SharedToken data connector**

Find the SharedToken data connector and comment it out or remove it from the configuration as it is not require.

    <!--
	    <resolver:DataConnector xsi:type="SharedToken" xmlns="urn:mace:aaf.edu.au:shibboleth:2.0:resolver:dc"
        id="sharedToken"
        sourceAttributeId="uid"
        salt="{{ shib_idp.aepst_salt }}"
        dataSource="jdbc/shib_idp">
        <resolver:Dependency ref="ldap" />
      </resolver:DataConnector>
    -->

**Modify the SharedToken Attribute definition**

Change the attribute definition to source the shared token value from your LDAP server rather than the SharedToken data connector.

    <!-- Original defnition -->
    <resolver:AttributeDefinition id="auEduPersonSharedToken" xsi:type="ad:Simple" sourceAttributeID="auEduPersonSharedToken">
       <resolver:Dependency ref="sharedToken" />
       <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:federation.org.au:attribute:auEduPersonSharedToken" />
       <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:1.3.6.1.4.1.27856.1.2.5" friendlyName="auEduPersonSharedToken" />
    </resolver:AttributeDefinition>

Change the resolver:Dependency. This assumes the name of the attribute for the sharedToken in your LDAP is auEduPersonSharedToken. If this is not the case change the sourceAttributeID value to be the name of the attribute that hold the value.

    <!-- New defnition -->
    <resolver:AttributeDefinition id="auEduPersonSharedToken" xsi:type="ad:Simple" sourceAttributeID="auEduPersonSharedToken">
       <resolver:Dependency ref="ldap" />
       <resolver:AttributeEncoder xsi:type="enc:SAML1String" name="urn:mace:federation.org.au:attribute:auEduPersonSharedToken" />
       <resolver:AttributeEncoder xsi:type="enc:SAML2String" name="urn:oid:1.3.6.1.4.1.27856.1.2.5" friendlyName="auEduPersonSharedToken" />
    </resolver:AttributeDefinition>

### Created on the fly

This option is NOT recommended. You should persist the users sharedToken as its value will change if the value of users attribute used to generate the value changes, for example their UID.

There is no data to migrate as non has ever been generated. 

To ensure the same values are created for users you must ensure that the following configuration values for your v3 IdP are exactly the same as they were for v2.

- The salt value used by the SharedToken data connector
- The id of the user attribute used the SharedToken data connector, generall either UID or sAMAccountName.
- The entityID of your IdP.

Use the AAF Attribute Validator to verify that the same sharedToken values are being generated for users.

### Created and stored in a Database

SharedTokens that are stored in a database are the simplest to migrate. The table structure has not changed between versions.

To export the data

    mysqldump -u idp_user -p -h localhost --no-create-info --complete-insert IDP tb_st > tb_st.sql

To import the data, transfer the file to the new IdP, then

    mysql idp_db < tb_st.sql

Check the data imported correctly. There are two columns in this table.

| Column Name | Description | Example data |
|-------------|-------------|--------------|
| uid | The users username | fred |
| sharedtoken | The users shared token value | EgFefK5xD77Fn6OXPQU8oyKL5HE |

### Created and stored in the LDAP directory

This is probably the most difficult option for migration because extracting the values from the LDAP directory can be difficult for the following reasons.

- The directory server limits the number of user records returned
- The directory server limits the time available to perform a search

Together these issues can make it difficult to ensure you have recovered all user's shared token values.

The recommended approach is the ensure the old and new IdPs are generating the same shared token values for your users. As users log in the new IdP will populate their shared token values into the database.