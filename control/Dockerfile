FROM debian:bullseye

# Docker + systemd cooperation
ENV container docker
STOPSIGNAL SIGRTMIN+3

ENV LEIN_ROOT true

# Jepsen control dependencies
RUN apt-get -qy update && \
    apt-get -qy install \
    openjdk-11-jdk-headless \
    libjna-java \
    vim \
    emacs \
    git \
    htop \
    screen \
    pssh \
    curl \
    wget \
    gnuplot \
    graphviz \
    dos2unix

RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    mv lein /usr/bin && \
    chmod +x /usr/bin/lein && \
    lein self-install

# without --dev flag up.sh copies jepsen to these subfolders
# with --dev flag they are empty until mounted

# TODO ???
# COPY jepsen/jepsen /jepsen/jepsen/
# RUN if [ -f /jepsen/jepsen/project.clj ]; then cd /jepsen/jepsen && lein install; fi
# COPY jepsen /jepsen/

# pre-add Jepsen deps
ADD ./project.clj /root/project.clj
RUN cd /root && lein deps

ADD ./bashrc /root/.bashrc
ADD ./init.sh /init.sh
RUN dos2unix /init.sh /root/.bashrc \
    && chmod +x /init.sh

CMD [ "/init.sh" ]
