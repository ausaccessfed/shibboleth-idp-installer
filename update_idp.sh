#!/bin/sh

echo -e "\n\n-----"
echo "This script will update the Shibboleth IdP installed on this host."
echo -e "This includes running an update of all OS packages.\n"
echo "You MUST have a tested rollback plan in place before continuing."
echo -e "-----\n\n"

read -r -p "Are you ready to undertake the update? [y/N] " response
response=${response,,}

if [[ $response =~ ^(yes|y)$ ]]
then
  cd /opt/shibboleth-idp-installer/repository/
  ansible-playbook -i ansible_hosts site.yml --force-handlers
else
  exit 0
fi
