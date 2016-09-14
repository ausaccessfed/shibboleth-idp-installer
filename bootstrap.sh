#!/bin/bash
set -e

############################ BOOTSTRAP CONFIGURATION ###########################
#
#             MANDATORY SECTION - YOU MUST REVIEW AND SET EACH VALUE
#             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  Specify the externally facing address for this IdP. Typically you would have
#  a DNS entry for this. Do *NOT* use 'localhost' or any other local address.
#HOST_NAME=idp.example.edu

#  The federation environment
#  Allowable values: {test, production} (case-sensitive)
#ENVIRONMENT=test

#  Your Organisation's name
#ORGANISATION_NAME="The University of Example"

#  The base domain for your organisation
#ORGANISATION_BASE_DOMAIN=example.edu

#  Your schacHomeOrganizationType.
#  See http://www.terena.org/activities/tf-emc2/schacreleases.html
#  Relevant values are:
#   urn:mace:terena.org:schac:homeOrganizationType:au:university
#   urn:mace:terena.org:schac:homeOrganizationType:au:research-institution
#   urn:mace:terena.org:schac:homeOrganizationType:au:other
#HOME_ORG_TYPE=urn:mace:terena.org:schac:homeOrganizationType:au:university

#  The attribute used for AuEduPersonSharedToken and EduPersonTargetedId
#  generation.
#  See http://wiki.aaf.edu.au/tech-info/attributes/auedupersonsharedtoken
#      http://wiki.aaf.edu.au/tech-info/attributes/edupersontargetedid
#  IMPORTANT: The generation of AuEduPersonSharedToken and EduPersonTargetedId
#  require the value from the specified source attribute. If the value changes,
#  it will change the AuEduPersonSharedToken and EduPersonTargetedId. This will
#  cause the user to lose access in the federation. It is *critical* that you
#  specify an attribute that will never change.
#SOURCE_ATTRIBUTE_ID=uid


#                             OPTIONAL SECTION
#                             ~~~~~~~~~~~~~~~~

#  LDAP address Shibboleth IdP will connect to
#LDAP_HOST="IP_ADDRESS:PORT"

#  Point from where LDAP will search for users
#LDAP_BASE_DN="ou=Users,dc=example,dc=edu"

#  The administrator's bind dn
#LDAP_BIND_DN="cn=Manager,dc=example,dc=edu"

#  The adminstrator's password
#LDAP_BIND_DN_PASSWORD="p@ssw0rd"

#  Specify the attribute for user queries
#LDAP_USER_FILTER_ATTRIBUTE="uid"

#                            ADVANCED SECTION
#                            ~~~~~~~~~~~~~~~~

# The base path for Shibboleth and the IdP Installer configuration.
# Changing the base path MUST only occur here, do not attempt to change
# the base after the initial install. 
INSTALL_BASE=/opt

# ------------------------ END BOOTRAP CONFIGURATION ---------------------------

LOCAL_REPO=$INSTALL_BASE/shibboleth-idp-installer/repository
SHIBBOLETH_IDP_INSTANCE=$INSTALL_BASE/shibboleth/shibboleth-idp/current
ANSIBLE_HOSTS_FILE=$LOCAL_REPO/ansible_hosts
ANSIBLE_HOST_VARS=$LOCAL_REPO/host_vars/$HOST_NAME
ANSIBLE_CFG=$LOCAL_REPO/ansible.cfg
UPDATE_IDP_SCRIPT=$LOCAL_REPO/update_idp.sh
ASSETS=$LOCAL_REPO/assets/$HOST_NAME
APACHE_ASSETS=$ASSETS/apache
CREDENTIAL_BACKUP_PATH=$ASSETS/idp/credentials
LDAP_PROPERTIES=$ASSETS/idp/conf/ldap.properties
APACHE_IDP_CONFIG=$ASSETS/apache/idp.conf

GIT_REPO=https://github.com/ausaccessfed/shibboleth-idp-installer.git
GIT_BRANCH=master

FR_TEST_REG=https://manager.test.aaf.edu.au/federationregistry/registration/idp
FR_PROD_REG=https://manager.aaf.edu.au/federationregistry/registration/idp

function ensure_mandatory_variables_set {
  for var in HOST_NAME ENVIRONMENT ORGANISATION_NAME ORGANISATION_BASE_DOMAIN \
    HOME_ORG_TYPE SOURCE_ATTRIBUTE_ID INSTALL_BASE; do
    if [ ! -n "${!var:-}" ]; then
      echo "Variable '$var' is not set! Set this in `basename $0`"
      exit 1
    fi
  done
}

function ensure_install_base_exists {
  if [ ! -d "$INSTALL_BASE" ]; then
    echo "The directory $INSTALL_BASE where you have requested the install"
    echo "to occur does not exist."
    exit 1
  fi
}

function install_yum_dependencies {
  yum -y update
  yum -y install git
  yum -y install ansible
}

function pull_repo {
  pushd $LOCAL_REPO > /dev/null
  git pull
  popd > /dev/null
}

function setup_repo {
  if [ -d "$LOCAL_REPO" ]; then
    echo "$LOCAL_REPO already exists, not cloning repository"
    pull_repo
  else
    mkdir -p $LOCAL_REPO
    git clone -b $GIT_BRANCH $GIT_REPO $LOCAL_REPO
  fi
}

function set_ansible_hosts {
  if [ ! -f $ANSIBLE_HOSTS_FILE ]; then
    cat > $ANSIBLE_HOSTS_FILE << EOF
[idp-servers]
$HOST_NAME
EOF
  else
    echo "$ANSIBLE_HOSTS_FILE already exists, not creating hostfile"
  fi
}

function replace_property {
  local property=$1
  local value=$2
  local file=$3
  if [ ! -z "$value" ]; then
    sed -i "s/.*$property.*/$property $value/g" $file
  fi
}

function replase_string {
  local string=$1
  local value=$2
  locat file=$3
  if [ ! -z "$value" ]; then
    sed -i "s/.*$string.*/$value/g" $file
  fi
}

function set_ansible_host_vars {
  local entity_id="https:\/\/$HOST_NAME\/idp\/shibboleth"
  replace_property 'idp_host_name:' "\"$HOST_NAME\"" $ANSIBLE_HOST_VARS
  replace_property 'idp_entity_id:' "\"$entity_id\"" $ANSIBLE_HOST_VARS
  replace_property 'idp_attribute_scope:' "\"$ORGANISATION_BASE_DOMAIN\"" \
    $ANSIBLE_HOST_VARS
  replace_property 'organisation_name:' "\"$ORGANISATION_NAME\"" \
    $ANSIBLE_HOST_VARS
  replace_property 'home_organisation:' "\"$ORGANISATION_BASE_DOMAIN\"" \
    $ANSIBLE_HOST_VARS
  replace_property 'home_organisation_type:' "\"$HOME_ORG_TYPE\"" \
    $ANSIBLE_HOST_VARS
  replace_property 'install_base:' "\""${INSTALL_BASE////\\/}"\"" \
    $ANSIBLE_HOST_VARS
}

function set_ansible_cfg_log_path {
  replace_string 'INSTALL_BASE:' "\""${INSTALL_BASE////\\/}"\"" \
    $ANSIBLE_CFG
}

function set_update_idp_script_cd_path {
  replase_string ''INSTALL_BASE:' "\""${INSTALL_BASE////\\/}"\"" \
    $UPDATE_IDP_SCRIPT
}

function set_source_attribute_in_attribute_resolver {
  local attr_resolver=$ASSETS/idp/conf/attribute-resolver.xml
  sed -i "s/YOUR_SOURCE_ATTRIBUTE_HERE/$SOURCE_ATTRIBUTE_ID/g" $attr_resolver
}

function set_source_attribute_in_saml_nameid_properties {
  local saml_nameid_properties=$ASSETS/idp/conf/saml-nameid.properties
  sed -i "s/YOUR_SOURCE_ATTRIBUTE_HERE/$SOURCE_ATTRIBUTE_ID/g" $saml_nameid_properties
}

function set_ldap_properties {
  replace_property 'idp.authn.LDAP.ldapURL =' \
    "ldap:\/\/$LDAP_HOST" $LDAP_PROPERTIES
  replace_property 'idp.authn.LDAP.baseDN =' \
    "$LDAP_BASE_DN" $LDAP_PROPERTIES
  replace_property 'idp.authn.LDAP.bindDN =' \
    "$LDAP_BIND_DN" $LDAP_PROPERTIES
  replace_property 'idp.authn.LDAP.bindDNCredential =' \
    "$LDAP_BIND_DN_PASSWORD" $LDAP_PROPERTIES
  replace_property 'idp.authn.LDAP.userFilter =' \
    "($LDAP_USER_FILTER_ATTRIBUTE={user})" $LDAP_PROPERTIES
}

function set_apache_ecp_ldap_properties {
  replace_property 'AuthLDAPURL' \
    "\"ldap:\/\/$LDAP_HOST\/$LDAP_BASE_DN?$LDAP_USER_FILTER_ATTRIBUTE\"" \
    $APACHE_IDP_CONFIG
  replace_property 'AuthLDAPBindDN' "\"$LDAP_BIND_DN\"" $APACHE_IDP_CONFIG
  replace_property 'AuthLDAPBindPassword' "\"$LDAP_BIND_DN_PASSWORD\"" \
    $APACHE_IDP_CONFIG
}

function create_ansible_assets {
  cd $LOCAL_REPO
  sh create_assets.sh $HOST_NAME $ENVIRONMENT
}

function create_apache_self_signed_certs {
  if [ ! -s $APACHE_ASSETS/server.key ] &&
     [ ! -s $APACHE_ASSETS/server.crt ] &&
     [ ! -s $APACHE_ASSETS/intermediate.crt ]; then
    openssl genrsa -out $APACHE_ASSETS/server.key 2048
    openssl req -new -x509 -key $APACHE_ASSETS/server.key \
      -out $APACHE_ASSETS/server.crt -sha256 -subj "/CN=$HOST_NAME/"
    cp $APACHE_ASSETS/server.crt $APACHE_ASSETS/intermediate.crt
  else
    echo "Apache keypair ($APACHE_ASSETS) already exists, skipping"
  fi
}

function run_ansible {
  pushd $LOCAL_REPO > /dev/null
  ansible-playbook -i ansible_hosts site.yml --force-handlers
  popd > /dev/null
}

function backup_shibboleth_credentials {
  if [ ! -d "$CREDENTIAL_BACKUP_PATH" ]; then
    mkdir $CREDENTIAL_BACKUP_PATH
  fi

  cp -R $SHIBBOLETH_IDP_INSTANCE/credentials/* $CREDENTIAL_BACKUP_PATH
}

function display_fr_idp_registration_link {
  if [ "$ENVIRONMENT" == "test" ]; then
    echo "$FR_TEST_REG"
  else
    echo "$FR_PROD_REG"
  fi
}

function display_completion_message {
  cat << EOF

Bootstrap finished!

To make your IdP functional follow these steps:

1. Register your IdP in Federation Registry:
   `display_fr_idp_registration_link`

   - For 'Step 3. SAML Configuration' we suggest using the "Easy registration
     using defaults" with the value 'https://$HOST_NAME'

   - For 'Step 4. Attribute Scope' use '$ORGANISATION_BASE_DOMAIN'.

   - For 'Step 5. Cryptography'

       * For the 'Signing Certificate' paste the contents of $SHIBBOLETH_IDP_INSTANCE/credentials/idp-signing.crt
       * For the 'Backchannel Certificate' paste the contents of $SHIBBOLETH_IDP_INSTANCE/credentials/idp-backchannel.crt
       * For the 'Encryption Certificate' paste the contents of $SHIBBOLETH_IDP_INSTANCE/credentials/idp-encryption.crt

   - For 'Step 6. Supported Attributes' select the following:
       * auEduPersonSharedToken
       * commonName
       * displayName
       * eduPersonAffiliation
       * eduPersonAssurance
       * eduPersonScopedAffiliation
       * eduPersonTargetedID
       * email
       * organizationName
       * surname
       * givenName
       * homeOrganization
       * homeOrganizationType

   After completing this form, you will receive an email from the federation
   indicating your IdP is pending.

   You should now continue with the installation steps documented at
   http://ausaccessfed.github.io/shibboleth-idp-installer/installation.html

EOF
}

function prevent_duplicate_execution {
  touch "/root/.lock-idp-bootstrap"
}

function duplicate_execution_warning {
  if [ -e "/root/.lock-idp-bootstrap" ]
  then
    echo -e "\n\n-----"
    echo "The bootstrap process has already been executed and could be destructive if run again."
    echo "It is likely you want to run an update instead."
    echo "Please see http://ausaccessfed.github.io/shibboleth-idp-installer/customisation.html for further details."
    echo -e "\n\nIn certain cases you may need to re-run the bootstrap process if you've made an error during initial installation."
    echo "Please see http://ausaccessfed.github.io/shibboleth-idp-installer/installation.html to disable this warning."
    echo -e "-----\n\n"
    exit 0
  fi
}

function bootstrap {
  ensure_mandatory_variables_set
  ensure_install_base_exists
  duplicate_execution_warning
  install_yum_dependencies
  setup_repo
  set_ansible_hosts
  create_ansible_assets
  set_ansible_host_vars
  set_update_idp_script_cd_path
  set_ansible_cfg_log_path
  set_source_attribute_in_attribute_resolver
  set_source_attribute_in_saml_nameid_properties

  if [ ${LDAP_HOST} ];
  then
    set_ldap_properties
    set_apache_ecp_ldap_properties
  fi

  create_apache_self_signed_certs
  run_ansible
  backup_shibboleth_credentials
  display_completion_message
  prevent_duplicate_execution
}

bootstrap

