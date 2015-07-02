#!/bin/sh
set -e
export ANT_OPTS=" \
      -Didp.src.dir={{ shib_idp.src }} \
      -Didp.target.dir={{ shib_idp.home }} \
      -Didp.entityID={{ idp_entity_id }} \
      -Didp.host.name={{ idp_host_name }} \
      -Didp.scope={{ idp_attribute_scope }} \
      -Didp.merge.properties={{ shib_idp.src }}/conf/idp.merge.properties"
export JAVA_HOME="/usr/lib/jvm/java"
sh {{ shib_idp.src }}/bin/install.sh
