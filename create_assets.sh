#!/bin/bash
set -e

EXAMPLE_HOST=idp.example.edu.dist
HOST=$1

function create_assets {
  mkdir assets/$HOST
  cp -R assets/$EXAMPLE_HOST/* assets/$HOST/
  echo "Created directory 'assets/$HOST'. This is the source for your IdP " \
    "configuration."
}

function create_host_var {
  local host_var="host_vars/$HOST"
  if [ ! -f $host_var ]; then
    touch $host_var
    echo "Created file '$host_var', see host_vars/$EXAMPLE_HOST for example values."
  else
    echo "$host_var already exists, aborting"
    exit 1
  fi
}

function setup_assets {
  create_host_var
  create_assets
}

if [ "$#" -eq 1 ]
then
  setup_assets
else
  echo "Usage: `basename $0` <hostname>"
  exit 1
fi

