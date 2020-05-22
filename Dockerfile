# Dockerfile to run a linux quake live server
FROM ubuntu:16.04
MAINTAINER Dan Padgett <dumbledore3@gmail.com>

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libstdc++6:i386 wget software-properties-common
#RUN add-apt-repository ppa:fkrull/deadsnakes
#RUN apt-get update
RUN apt-get install -y python3.5 python3.5-dev build-essential libzmq3-dev

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
COPY vpql.factories ql/baseq3/scripts/
COPY slojo.factories ql/baseq3/scripts/
COPY ctrl.factories ql/baseq3/scripts/
COPY dft.factories ql/baseq3/scripts/
RUN chown -R quake:quake ql/baseq3/scripts
COPY workshop.txt ql/baseq3/
RUN chown quake:quake ql/baseq3/workshop.txt
COPY access.txt .quakelive/27960/baseq3/
RUN chown -R quake:quake .quakelive
COPY download-workshop.sh ./
RUN chown quake:quake download-workshop.sh
USER quake

# download the workshop items
RUN ./download-workshop.sh

# download and install latest minqlx
# http://stackoverflow.com/a/26738019
RUN wget -O - https://api.github.com/repos/MinoMino/minqlx/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4 | xargs wget
RUN cd ql && tar xzf ~/minqlx_v*.tar.gz
USER root
COPY minqlx-plugins ql/minqlx-plugins
COPY Quake-Live/minqlx-plugins ql/minqlx-plugins
COPY factory_lock.py ql/minqlx-plugins/
COPY install_minqlx_plugins.sh ./
RUN cd ql && ~/install_minqlx_plugins.sh
RUN chown -R quake:quake ql/
USER quake

# ports to connect to: 27960 is udp and tcp, 28960 is tcp
EXPOSE 27960 28960

CMD ql/server.sh 0
