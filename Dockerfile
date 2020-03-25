FROM debian:latest

MAINTAINER niavasha <niavasha@gmail.com>

# && apt-get update \
# && apt-get install -y default-jre-headless libjna-java mediainfo libchromaprint-tools unrar p7zip-full p7zip-rar mkvtoolnix mp4v2-utils gnupg curl file inotify-tools \
# && apt-get install -y --no-install-recommends filebot \
# && rm -rvf /var/lib/apt/lists/*
#RUN wget -r  -e robots=off  -np -nH --cut-dirs=3 -A 'FileBot_*_universal.deb' https://get.filebot.net/filebot/BETA/
#RUN apt-get install -y --no-install-recommends ./FileBot_*_universal.deb

RUN apt-get update
RUN echo "deb http://ftp.de.debian.org/debian buster main non-free" >> /etc/apt/sources.list \
&& echo "deb http://www.deb-multimedia.org buster main non-free" >> /etc/apt/sources.list \
&& apt-get update -oAcquire::AllowInsecureRepositories=true && apt-get install -y --allow-unauthenticated deb-multimedia-keyring \
&& apt-get update && apt-get -y dist-upgrade
#RUN apt-get install -y --no-install-recommends default-jre-headless libjna-java mediainfo libchromaprint-tools unrar p7zip-full p7zip-rar mkvtoolnix mp4v2-utils gnupg curl file inotify-tools wget par2
RUN apt-get install -y --no-install-recommends default-jre-headless libjna-java mediainfo libchromaprint-tools unrar p7zip-full p7zip-rar mkvtoolnix mp4v2-utils gnupg curl file inotify-tools wget par2 openjfx
RUN apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub 
RUN echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list \
&& apt-get update \
&& apt-get install -y --no-install-recommends filebot gawk git \
&& rm -rvf /var/lib/apt/lists/*
#RUN rm -rvf /var/lib/apt/lists/*
RUN useradd -g 100 -u 99 abc

VOLUME /data
VOLUME /volume1

RUN git clone https://github.com/filebot/scripts.git
RUN mv scripts /data

ENV HOME /data
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Duser.home=$HOME"

WORKDIR /volume1

COPY filebot-watcher /usr/bin/filebot-watcher

ENV SETTLE_DOWN_TIME 60

ENTRYPOINT ["/usr/bin/filebot-watcher"]
