#!/bin/bash
gameport=`expr $1 + 30960`
rconport=`expr $1 + 31960`
servernum=`expr $1 + 1`

stdbuf -oL -eL /home/${USER}/Steam/steamapps/common/Quake\ Live\ Dedicated\ Server/run_server_x64.sh \
    +set net_strict 1 \
    +set net_port $gameport \
    +set sv_hostname "teh1337 Turbo CA [US Central]" \
    +set fs_homepath /home/${USER}/.quakelive/$gameport \
    +set zmq_rcon_enable 1 \
    +set zmq_rcon_password "quake1337!" \
    +set zmq_rcon_port $rconport \
    +set zmq_stats_enable 1 \
    +set zmq_stats_password "stats" \
    +set zmq_stats_port $gameport

