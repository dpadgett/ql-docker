# Dockerfile to run a linux quake live server
FROM ubuntu:14.04
MAINTAINER Dan Padgett <dumbledore3@gmail.com>

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libstdc++6:i386 wget

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
COPY access.txt .quakelive/30960/baseq3/
RUN chown -R quake:quake .quakelive
USER quake

# ports to connect to: 27960 is udp, 28960 is tcp
EXPOSE 30960 31960

CMD ql/server.sh 0 > /tmp/qlout 2>&1
