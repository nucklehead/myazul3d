FROM golang:1.7-wheezy

RUN apt-get update
RUN apt-get install -y build-essential git mesa-common-dev \
    libx11-dev libx11-xcb-dev libxcb-icccm4-dev libxcb-image0-dev \
    libxcb-randr0-dev libxcb-render-util0-dev libfreetype6-dev \
    libbz2-dev libxxf86vm-dev libgl1-mesa-dev libxrandr-dev libxcursor-dev libxi-dev

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt-get install -y python-software-properties && \
    add-apt-repository 'deb http://http.debian.net/debian wheezy-backports main' &&\
    apt-get update
RUN apt-get -t wheezy-backports install -y git

RUN apt-get install -y git-lfs

RUN git lfs install

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    mkdir /etc/sudoers.d/ && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
VOLUME src $GOPATH/src/github.com/myazul
CMD /bin/bash
