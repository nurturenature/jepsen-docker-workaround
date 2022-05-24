FROM jgoerzen/debian-base-standard:bullseye

# Docker + systemd cooperation
ENV container docker
STOPSIGNAL SIGRTMIN+3

# Enable SSH server
ENV DEBBASE_SSH enabled

# Basic system packages
RUN apt-get -qy update && \
    apt-get -qy install \
    apt-transport-https \
    dos2unix \
    openssh-server \
    pwgen

# Jepsen node deps
RUN apt-get -qy update && \
    apt-get -qy install \
    build-essential \
    bzip2 \
    curl \
    dnsutils \
    faketime \
    iproute2 \
    iptables \
    iputils-ping \
    libzip4 \
    logrotate \
    man \
    man-db \
    net-tools \
    ntpdate \
    psmisc \
    python \
    rsyslog \
    sudo \
    tar \
    unzip \
    vim \
    wget \
    ca-certificates

# When run, boot-debian-base will call this script, which does final
# per-db-node setup stuff.
ADD setup-jepsen.sh /usr/local/preinit/03-setup-jepsen
RUN chmod +x /usr/local/preinit/03-setup-jepsen

# Configure SSHD
RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# util script to cp control's key as authorized host for this node
ADD ssh-dance.sh /root/ssh-dance.sh
RUN chmod +x /root/ssh-dance.sh

# Jepsen defaults use user admin with sudo
RUN apt-get -qy update && \
    apt-get -qy install \
    sudo
RUN useradd --create-home --shell /bin/bash admin && \
    usermod -aG sudo admin
SHELL [ "/bin/bash", "-c" ]
RUN echo -e "admin\nadmin\n" | passwd admin

EXPOSE 22

CMD [ "/usr/local/bin/boot-debian-base" ]
