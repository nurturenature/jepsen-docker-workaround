# Jepsen in Docker Workaround

## This repository is no longer needed.

### `docker compose` can now configure OS/systemd containers correctly, which Jepsen and others use.

# Please see [Dockerized Jepsen](https://github.com/jepsen-io/jepsen/tree/main/docker) at [jepsen-io/jepsen](https://github.com/jepsen-io/jepsen).

----

----

This repository is a temporary workaround to run [Jepsen](https://github.com/jepsen-io/jepsen) in a Docker environment.

Current `docker compose` [doesn't have the ability](https://github.com/docker/compose/issues/8167) to [configure](https://github.com/docker/compose/issues/9457) systemd container's `cgroupns` correctly. `docker run` can configure the containers correctly.

Jepesen's [docker compose](https://github.com/jepsen-io/jepsen/blob/main/docker) has been decomposed into a series of individual `docker run` commands.

This is a temporary solution to support the sharing of Jepsen tests until Docker fixes compose.

----

## LXC Recommended

If you are developing or running Jepsen tests in a meaningful way, [setting up](https://github.com/jepsen-io/jepsen/blob/main/doc/lxc.md) an LXC environment is recommended.

----

## Demo

Let's run some tests with a 5 node cluster of [AntidoteDB](https://github.com/AntidoteDB/antidote) running in a single data center. Here's the commands we'll be using:

### Host (local machine) commands:

(run from the top level directory of this repository)

```bash
# run from a host terminal:

# build AntidoteDB and the fuzz_dist client
bin/build-db

# bring up Jepsen control node, 5 database nodes as Docker containers
bin/up

# open a terminal on the control node
# it is common to have several open terminals
bin/control

# open a browser window to the control node's web server
bin/web

# stop and remove Docker containers, network, and volumes
bin/down
```

### Control node (Docker container) commands:

(run on control node after `bin/control`)

```bash
# run from a control node terminal:

# run a simple test
lein run test --workload g-set --nemesis partition

# run a web server for test results (leave terminal open to leave web server running)
lein run serve

# from the control node, you can ssh to any database node
ssh n1
```

### Typical Usage

```bash
# build AntidoteDB, bring up Docker environment and connect to control node:
host$ bin/build-db
host$ bin/up
host$ bin/control

# run webserver on control node:
# (will take over terminal)
control$ lein run serve

# open a new control node terminal, then run tests:
control$ lein run test --workload pn-counter
control$ lein run test --nemesis kill --antidote-sync-log true

# while tests are running, open a browser window on the host
host$ bin/web
```

----

### Local Development

To run the tests using a local copy of the AntidoteDB source:

```bash
host$ bin/build-db --antidote-src /full/path/to/antidote/source/dir
```

To attach an Erlang shell to a running AntidoteDB:

```bash
control$ ssh n1
n1$ cd /root/antidote
n1$ NODE_NAME=antidote@n1. COOKIE=secret bin/antidote remote_console
```

The database can also be left running for post test inspection:

```bash
control$ lein run test --leave-db-running
```

----

## etcd

To run the [Jepsen etcd tests](https://github.com/jepsen-io/etcd):

```bash
# clone the Jepsen etcd repository and copy it to jepsen_dev Docker volume:

host$ git clone https://github.com/jepsen-io/etcd.git
host$ bin/cp-to-control --cp-from /full/path/to/etcd --cp-to etcd

# bring up Jepsen control node, database nodes,
# and connect to control node:
host$ bin/up
host$ bin/control

# on control node, start a webserver for test results:
control$ cd /jepsen/etcd
control$ lein run serve

# open another terminal and connect to the control node and run tests:
control$ cd /jepsen/etcd
control$ lein run test-all --concurrency 2n --workload lock-set

# to demonstrate lost updates to a set protected by an etcd lock, try:
control$ lein run test --workload lock-set --nemesis pause --time-limit 120

# while tests are running, open up a browser window on the host
host$ bin/web
```

----

## jepsen_dev Docker volume

`jepsen-docker-workaround` will make ***no*** changes to your local filesystem.

For convience, the persistent docker volume `jepsen_dev` is created.

See `./store` for test results, log files from all db nodes, analysis, etc.

It can be manually deleted when the data is no longer of interest:

```bash
docker volume rm jepsen_dev
```

----

### The AntidoteDB tests are under [active development](https://github.com/nurturenature/fuzz_dist) and are not indicative at this time. AntidoteDB is interesting:
- being further developed by [Vaxine](https://github.com/vaxine-io/vaxine)
- rich CRDTs
- well behaved BEAM (Erlang) application
- easy to work with
