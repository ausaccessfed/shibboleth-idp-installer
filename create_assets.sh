#!/bin/bash
set -e

EXAMPLE_HOST=idp.example.edu.dist
HOST=$1
HOST_VAR_FOR_HOST="host_vars/$HOST"
ASSETS_FOR_HOST="assets/$HOST"

function create_assets {
  if [ -d "$ASSETS_FOR_HOST" ]; then
    echo "$ASSETS_FOR_HOST already exists, skipping"
  else
    mkdir $ASSETS_FOR_HOST
    cp -R assets/$EXAMPLE_HOST/* $ASSETS_FOR_HOST
  fi
}

function create_host_var {
  if [ ! -f $HOST_VAR_FOR_HOST ]; then
    touch $HOST_VAR_FOR_HOST
  else
    echo "$HOST_VAR_FOR_HOST already exists, skipping"
  fi
}

function setup_assets {
  create_host_var
  create_assets
  echo "Now configure your IdP:"
  echo "1. Customise your host_var file: '$HOST_VAR_FOR_HOST'"
  echo "   See 'host_vars/$EXAMPLE_HOST.[ENVIRONMENT]' for example values."
  echo "2. Customise the IdP's asset directory: '$ASSETS_FOR_HOST'"
  echo "   This will permanently hold your IdP configuration."
}

if [ "$#" -eq 1 ]
then
  setup_assets
else
  echo "Usage: `basename $0` <hostname>"
  exit 1
fi

