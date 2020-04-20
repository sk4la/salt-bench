# Salt — Test Bench

[![version](https://img.shields.io/badge/version-2020.1a-blue)](https://github.com/sk4la/salt-bench)

This is a Docker-based test bench for [Salt](https://docs.saltstack.com/en/latest/).

## Requirements

To use the project, the following components need to be installed on the system:

* [Docker](https://docs.docker.com/install/) toolchain (at least the Docker Engine and [Docker Compose](https://docs.docker.com/compose/install/)) ;
* GNU Make.

The provided Docker Compose recipe is only compatible with the 18.06.0 version (or ulterior) of the Docker Engine. Make sure you have the correct version installed by running `docker --version`. Docker Compose 1.25.4 (or ulterior) is also required.

## Build

Pre-built images are available on [Docker Hub](https://hub.docker.com/u/sk4labs).

To build the images locally, just navigate to the root of the repository and run:

```shell
make build
```

## Usage

Once the images have been built, one can bring the stack up and running using:

```shell
make up
```

Then, spawn an interactive shell inside the Salt Master container by issuing:

```shell
make shell
```

Finally, execute the following command to bring the whole stack down:

```shell
make down
```

## Issues

In case you spot a mistake or encounter an issue, please file a [ticket](https://github.com/sk4la/salt-bench/issues).
