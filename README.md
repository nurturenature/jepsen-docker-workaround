# Jepsen in Docker Workaround

This repository is a temporary work-a-round to run [Jepsen](https://github.com/jepsen-io/jepsen) in a Docker environment.

Current docker compose has lost, doesn't have the ability to configure systemd container's `cgroupns` correctly.

Jepesen's [docker compose](https://github.com/jepsen-io/jepsen/blob/main/docker) has been decomposed into a series of individual `docker run` commands.

In addition, the Dockerfiles have been modified to preserve some of the original compose capabilities.

----

### This is a substandard environment compared to the original `docker compose` and using LXC. It is driven by the necessity to share Jepsen tests.

----

## LXC Recommended

If you are developing or running Jepsen tests in a meaningful way, [setting up](https://github.com/jepsen-io/jepsen/blob/main/doc/lxc.md) an LXC environment is recommended.

----
## Demo

```bash
# build a release of AntidoteDB and the fuzz_dist client
bin/build-db

# bring up a Jepsen control node and 5 database nodes
bin/up

# open a terminal on the control node
bin/console
```
