# Dockerfile to run a linux quake live server
FROM ubuntu:14.04
MAINTAINER Dan Padgett <dumbledore3@gmail.com>

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libstdc++6:i386 wget software-properties-common
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get update
RUN apt-get install -y python3.5 python3.5-dev build-essential

RUN useradd -ms /bin/bash quake

# copy the nice dotfiles that dockerfile/ubuntu gives us:
RUN cd && cp -R .bashrc .profile /home/quake

WORKDIR /home/quake

RUN chown -R quake:quake /home/quake

USER quake
ENV HOME /home/quake
ENV USER quake

# download and extract steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

# install the quake live server program
RUN ./steamcmd.sh +login anonymous +app_update 349090 +quit
RUN ln -s "Steam/steamapps/common/Quake Live Dedicated Server/" ql

# copy over the custom game files
USER root
COPY server.sh ql/
RUN chown quake:quake ql/server.sh
COPY server.cfg ql/baseq3/
RUN chown quake:quake ql/baseq3/server.cfg
COPY mappool_turboca.txt ql/baseq3/
RUN chown quake:quake ql/baseq3/mappool_turboca.txt
COPY turboca.factories ql/baseq3/scripts/
RUN chown -R quake:quake ql/baseq3/scripts
COPY workshop.txt ql/baseq3/
RUN chown quake:quake ql/baseq3/workshop.txt
COPY access.txt .quakelive/30960/baseq3/
RUN chown -R quake:quake .quakelive
USER quake

# download the workshop items
RUN ./steamcmd.sh \
    +login anonymous \
    +workshop_download_item 282440 539421606 \
    +workshop_download_item 282440 539421982 \
    +workshop_download_item 282440 546664071 \
    +workshop_download_item 282440 545368609 \
    +workshop_download_item 282440 550850908 \
    +workshop_download_item 282440 550843679 \
    +workshop_download_item 282440 551678612 \
    +workshop_download_item 282440 551367534 \
    +workshop_download_item 282440 550575965 \
    +workshop_download_item 282440 549447613 \
    +workshop_download_item 282440 551699225 \
    +workshop_download_item 282440 547440173 \
    +workshop_download_item 282440 542684362 \
    +workshop_download_item 282440 549208258 \
    +workshop_download_item 282440 550003921 \
    +workshop_download_item 282440 550674410 \
    +workshop_download_item 282440 551229107 \
    +workshop_download_item 282440 544872333 \
    +workshop_download_item 282440 544276062 \
    +workshop_download_item 282440 546209430 \
    +workshop_download_item 282440 546895198 \
    +workshop_download_item 282440 546129401 \
    +workshop_download_item 282440 545699336 \
    +workshop_download_item 282440 546960020 \
    +workshop_download_item 282440 547252823 \
    +workshop_download_item 282440 553088484 \
    +workshop_download_item 282440 553095317 \
    +workshop_download_item 282440 550566693 \
    +workshop_download_item 282440 550747161 \
    +workshop_download_item 282440 551148976 \
    +workshop_download_item 282440 547937675 \
    +workshop_download_item 282440 552722973 \
    +workshop_download_item 282440 547481475 \
    +workshop_download_item 282440 549600167 \
    +quit && \
    mv steamapps ql/

# download and install minqlx
RUN wget https://github.com/MinoMino/minqlx/releases/download/v0.1.0/minqlx_v0.1.0.tar.gz
RUN cd ql && tar xzf ~/minqlx_v0.1.0.tar.gz
USER root
COPY minqlx-plugins ql/minqlx-plugins
COPY Quake-Live/minqlx-plugins ql/minqlx-plugins
COPY install_minqlx_plugins.sh ./
RUN cd ql && ~/install_minqlx_plugins.sh
RUN chown -R quake:quake ql/
USER quake

# ports to connect to: 27960 is udp, 28960 is tcp
EXPOSE 30960 31960

CMD ql/server.sh 0
