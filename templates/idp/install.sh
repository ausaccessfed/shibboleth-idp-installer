#!/bin/sh
set -e
export ANT_OPTS=" \
      -Didp.src.dir={{ idp_inst_home }} \
      -Didp.target.dir={{ shib_idp.home }} \
      -Didp.entityID={{ idp_entity_id }} \
      -Didp.host.name={{ idp_host_name }} \
      -Didp.scope={{ idp_attribute_scope }} \
      -Didp.merge.properties={{ idp_inst_home }}/conf/idp.merge.properties"
export JAVA_HOME="/usr/lib/jvm/java"
sh {{ idp_inst_home }}/bin/install.sh
