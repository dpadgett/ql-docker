#!/bin/bash

# set owner
OWNER=$(grep "|admin$" ~/.quakelive/30960/baseq3/access.txt | sed 's/|admin$//')
echo Setting owner $OWNER
sed -i "s/^Owner: .*/Owner: $OWNER/" ~/ql/minqlx/config.cfg
sed -i 's/Host: .*/Host: redis:6379/' ~/ql/minqlx/config.cfg
sed -i 's/UseUnixSocket: True/UseUnixSocket: False/' ~/ql/minqlx/config.cfg
