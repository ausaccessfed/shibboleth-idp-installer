#!/bin/bash

declare -a nodes

function git_update_details {
  remote=`git config --get remote.origin.url`
  current_branch=`git symbolic-ref -q --short HEAD`

  echo -e "The process will also perform the following UPGRADES:\n"
  echo "  1. Upgrade to the most recent version of the installer: "
  echo "    * The update will be retrieved from: ${remote}"
  echo "    * It will be based on the most recent release from: ${current_branch}"
  echo ""
  echo "  2. May add additional files to your Assets area to allow for advanced configuration"
  echo ""
  echo "  3. Upgrade, if necessary, to the most recently vetted versions of: "
  echo "    * Shibboleth IdP"
  echo -e "    * Jetty\n\n"
}


function get_nodes {
echo "get_nodes"
  i=1
  getting_nodes=false
  for line in $(cat ansible_hosts)
  do
echo "$line"
    if [ $line == "[idp-servers]" ]; then
      getting_nodes=true
echo "Starting nodes"
    else
      if [[ "$line" == [* ]]; then
echo "Finished nodes"
        getting_nodes=false
      else
        if ( $getting_nodes ); then
echo "Got node $line"
          nodes[$i]=$line
	else
echo "Skip $line"
        fi
      fi
    fi
  done
}

function server_patch () {
  patch=`grep "server_patch:" host_vars/$1`

  if [[ $patch == "server_patch: \"false\"" ]]; then
    echo "      Node: $1 will NOT be patched"
  else
    echo "      Node: $1 will be patched"
  fi
}

cd /opt/shibboleth-idp-installer/repository || exit

get_nodes

echo ${nodes[*]}

upgrade=false
while getopts ":u" opt; do
  case $opt in
    u) upgrade=true;;
  esac
done

echo -e "\n-----\n"
echo -e "This process will perform the following UPDATES: \n"
echo "  1. Update underlying operating system packages to ensure any security issues are addressed"
echo ""
for x in ${nodes[*]}
do
  server_patch $x
done
echo ""
echo "  2. Apply any configuration changes made within the assets directory for: "
echo "    * Shibboleth IdP"
echo "    * Jetty"
echo "    * Apache HTTPD"
echo ""
echo -e "  3. RESTART all dependant processes.\n"

if [[ $upgrade = true ]]
then
  git_update_details
fi

echo "You MUST have a tested rollback plan in place before continuing."
echo -e "\n-----\n"

read -r -p "Are you sure you wish to continue with the process as detailed above? [y/N] " response
response=${response,,}

if [[ $response =~ ^(yes|y)$ ]]
then
  if [[ $upgrade = true ]]
  then
    git pull
    ansible-playbook -i ansible_hosts update.yml
  fi

  ansible-playbook -i ansible_hosts site.yml --force-handlers
else
  echo "No changes made, exiting."
  exit 0
fi
