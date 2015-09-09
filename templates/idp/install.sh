#!/bin/sh
set -e
export ANT_OPTS=" \
      -Didp.src.dir={{ shib_idp.src }} \
      -Didp.target.dir={{ shib_idp.home }}"
export JAVA_HOME="/usr/lib/jvm/java"
sh {{ shib_idp.src }}/bin/install.sh
