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

# pre-add Jepsen
RUN git clone -b "main" --single-branch --depth 1 "https://github.com/jepsen-io/jepsen.git" /jepsen-src && \
    cd /jepsen-src/jepsen && \
    lein install && \
    cd ~ && \
    rm -rf /jepsen-src

# pre-add fuzz_dist
RUN git clone -b "main" --single-branch --depth 1 "https://github.com/nurturenature/fuzz_dist.git" /fuzz_dist-src && \
    cd /fuzz_dist-src/jepsen.fuzz_dist && \
    lein install && \
    cd ~ && \
    rm -rf /fuzz_dist-src

ADD ./bashrc /root/.bashrc
ADD ./init.sh /init.sh
RUN dos2unix /init.sh /root/.bashrc \
    && chmod +x /init.sh

CMD [ "/init.sh" ]
