# Build fuzz_dist & AntidoteDB into mounted volume:
#   /release-dir           # <- mount to dir on host
#   /release-dir/fuzz_dist # <- built release
#   /release-dir/antidote  # <- built release
FROM elixir
# image is from Erlang 24, Debian 11

# Docker + systemd cooperation
ENV container docker
STOPSIGNAL SIGRTMIN+3

# system tools
RUN apt-get -qy update && \
    apt-get -qy install dos2unix

# Elixir/Erlang tools
RUN mix local.hex --force && \
    mix local.rebar --force

# script to git and build releases
ADD ./build-db /root/build-db
RUN dos2unix /root/build-db && \
    chmod +x /root/build-db
