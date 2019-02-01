<!-- ![Actively maintained](https://img.shields.io/maintenance/yes/2018.svg) ![Alpine Linux 3.7](https://img.shields.io/badge/Alpine_Linux-3.7-brightgreen.svg) ![Ubuntu 17.10](https://img.shields.io/badge/Ubuntu-17.10-brightgreen.svg) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../LICENSE) -->

# Docker Base Image (aisberg/base-alpine) (aisberg/base-ubuntu)


https://thenewstack.io/six-lessons-bitnamis-transition-container-based-world/

- Intention
  - Examples ...
- Features (short)


- How to Build
- Structure
- How to use
  - Build upon
- Included Software

**Alpine Linux Base Image:**
Image size: ~100MB
Image hierarchy: [`alpine:3.7`](https://hub.docker.com/_/alpine/) ← `aisberg/base-alpine`
Source repository: https://github.com/Aisbergg/dockerfiles/base

**Ubuntu Base Image:**
Image size: ~200MB
Image hierarchy: [`ubuntu:17.10`](https://hub.docker.com/_/ubuntu/) ← `aisberg/base-ubuntu`
Source repository: https://github.com/Aisbergg/dockerfiles/base

**Table of contents**
<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Get the Image](#get-the-image)
	- [Download from Docker Hub](#download-from-docker-hub)
	- [Build it yourself](#build-it-yourself)
- [Run Containers](#run-containers)
	- [Commands](#commands)
	- [Configuration Parameters](#configuration-parameters)
		- [Supervisor](#supervisor)
- [Use as a Base Image](#use-as-a-base-image)
	- [Basic structure of the Image](#basic-structure-of-the-image)
	- [Provisioning](#provisioning)
		- [Tasks](#tasks)
		- [Templates](#templates)
	- [Init](#init)
	- [Build upon](#build-upon)
		- [Examples](#examples)
- [License](#license)

<!-- /TOC -->

## Get the Image
### Download from Docker Hub
Use the Docker Pull command for the Alpine Linux version:
```bash
docker pull aisberg/base-alpine:3.8

# or pull the latest tag:
docker pull aisberg/base-alpine:latest
```

or for the Ubuntu version:
```bash
docker pull aisberg/base-ubuntu:17.10

# or pull the latest tag:
docker pull aisberg/base-ubuntu:latest
```

### Build it yourself
Using the `make` command:
```bash
# for the Alpine Linux version
make build-alpine

# for the Ubuntu version
make build-ubuntu
```

Using *Docker Compose* the image can be simply build by running the following command inside the root of this repository:
```
docker-compose build
```

The equivalent *Docker* commands are:
```
docker build -t aisberg/base-alpine --build-arg CREATED="`date -R`" -f Dockerfile-Alpine .
docker build -t aisberg/base-ubuntu --build-arg CREATED="`date -R`" -f Dockerfile-Ubuntu .
```

## Run Containers

Intended as an base image...
not as

See [](#...) on how to build upon



### Commands
When the Container is started a specific command will be executed. The syntax for specifying a command is: `docker run ... aisberg/base-alpine CMD [OPTIONS]`

The Base Image provides following commands. More commands might be included by subimages:

Command   | Description
----------|----------------------------------------------------------------
cmd       | Executes any linux command
debug     | Drops into bash for debugging purpose
provision | Executes the provision tasks and renders the templates
run       | Executes the `provision` and `start` commands (default command)
start     | Starts the init program of the Container

The OPTIONS of each command can be looked up using `CMD --help`.

### Configuration Parameters


the intention behind parameters

How to define


`docker run ... -e PARAM_1="value" -e PARAM_2="value" ... -e PARAM_N="value" aisberg/base-alpine`

[Docker Secretes](https://docs.docker.com/engine/swarm/secrets/) when using Docker Swarm

[Docker Configs](https://docs.docker.com/engine/swarm/configs/)

or mounting a env file directly...

/etc/container_environment
```
VAR1=...
```

-e PARAM=value

--env-file FILE

```bash
PARAM_1=value
PARAM_2=value
...
```


#### Supervisor

Parameter | Description | Default
----------|-------------|--------
`SUPERVISOR_LOGLEVEL` | Define the amount of logged informations by the supervisor process. Possible values are: critical, error, warn, info, debug, trace, blather | error
`SUPERVISOR_HTTP_SERVER` | Enable a HTTP server to interrogate and control the supervisor process and the program it runs. Possible values are: unix, inet, disabled | disabled
`SUPERVISOR_UNIX_HTTP_SERVER_FILE` | The file path of the Unix socket to communicate with. Only used when `SUPERVISOR_HTTP_SERVER` is set to `unix`. | /tmp/supervisord.sock
`SUPERVISOR_UNIX_HTTP_SERVER_USERNAME` | The username required for authentication to the HTTP server. |
`SUPERVISOR_UNIX_HTTP_SERVER_PASSWORD` | The password required for authentication to the HTTP server. |
`SUPERVISOR_INET_HTTP_SERVER_HOST` | The host to listen for HTTP requests. Use `*` to accept commands from all hosts. Only used when `SUPERVISOR_HTTP_SERVER` is set to `inet`. | 127.0.0.1
`SUPERVISOR_INET_HTTP_SERVER_USERNAME` | The username required for authentication to the HTTP server. |
`SUPERVISOR_INET_HTTP_SERVER_PASSWORD` | The password required for authentication to the HTTP server. |

## Use as a Base Image
### Basic structure of the Image

```bash
.
├── Dockerfile-Alpine   # Dockerfile for Alpine Linux Base Image
├── Dockerfile-Ubuntu   # Dockerfile for Ubuntu Base Image
├── provision           # Dir containing all necessary files for provisioning
│   ├── cmds            # Commands that get executed on container startup
│   ├── post_tasks      # Provision tasks run after templating
│   ├── tasks           # Provision tasks run before templating
│   ├── templates       # Configuration file templates
│   └── vars            # Default variables used while rendering the templates
└── static              # Static files that are copied into the file system while building the Image
    └── entrypoint      # Entrypoint of the Container
```

### Provision a container
The provisioning process is triggered with the `provision` command. It will execute the provision tasks and render the included templates.

The detailed execution order is:
1. Turn [*Docker Secrets*](https://docs.docker.com/engine/reference/commandline/secret/) into environment variables.
2. Execute the scripts (bash `*.sh` or python `*.py`) inside the `/provision/tasks` directory.
3. Render all included templates (`/provision/templates/**.j2`) and copy them into the file system.
4. Execute the scripts inside the `/provision/post_tasks` directory.

#### Tasks
[TODO]

#### Templates
The directory `/provision/templates` contains the templates (`*.j2`) of configuration files that are rendered with the template engine [*Jinja*](http://jinja.pocoo.org) and put into the right path of the file system.

The process of rendering the templates is done with the [Templer - Python Templating Script](https://github.com/Aisbergg/python-templer). It will use the default variables defined in the `/provision/vars/*.yml` context files and the provided environment variables. For details about Templer see the [documentation](https://github.com/Aisbergg/python-templer#templer---templating-with-jinja2).

Besides the templating script there is another tool included for merging different types of configuration files if necessary. The tool called *ConfMerge* and respectiv documentation can be found [here](https://github.com/Aisbergg/python-confmerge#confmerge---python3-configuration-file-merge-utility).

### Init
There are three different init services provided with the Image. Depending on the requirements either one or another init might be more suitable to run the programs inside the containers.

**Supervisor**
[*Supervisor*](https://github.com/ochinchina/supervisord) allows controlling and monitoring of processes on UNIX-like operating systems. The *Supervisor* program included in this Base Image is a re-implemented Golang version of the original Python [*Supervisor*](http://supervisord.org/index.html). It does not provide all features of the original version offers, but it has the most crucial features and is more gentle on system resources. If it is desired to run multiple programs inside the container and also be able to control the processes from outside the container, then *Supervisor* might be a good choice.

Features:
- Run and control multiple programs
- Create and rotate logs or forward them to *Rsyslog* or *Logstash*
- Restart failing programs
- Control processes through XML-RPC interface over TCP or Unix socket
- Extensible through extension points
- Event notification

Documentation:
- [Official Version](http://supervisord.org/configuration.html)
- [Re-Implemented Version](https://github.com/ochinchina/supervisord#run-the-supervisord)

To use Supervisor a proper configuration for the program to run must be created in the `/provision/templates/etc/supervisor/conf.d` directory. Refer to the official Supervisor documentation for details. Besides creating a configuration the environment variable `INIT` must be set to `supervisor` which can be done in the Dockerfile:
```dockerfile
ENV INIT=supervisor
```

**Runit**
[*Runit*](http://smarden.org/runit/index.html) is a lightweight init scheme with service supervision. It might be more lightweight than *Supervisor* but isn't as powerful. It also can be used to run multiple programs inside the container.

Features:
- Run and control multiple programs
- Create and rotate logs or forward them to *Rsyslog*
- Restart failing programs

Documentation: http://smarden.org/runit/index.html

To enable Runit the environment variable `INIT` must be set to `runit` which can be done in the Dockerfile:
```dockerfile
ENV INIT=runit
```
Furthermore a service needs to be defined in the `/provision/templates/etc/service` directory. See the Runit documentation for details.

**Tini**
[*Tini*](https://github.com/krallin/tini) is an ultra simple init system especially designed for containers. It spawns a single child process and takes care of reaping zombie processes. If it is desired to run only one program inside the container then Tini is a good choice.

To use Tini as an init process the following two environment variables must be set **in a provision task**, not in the Dockerfile.
```bash
export INIT=tini
# the single program to execute
export INIT_ARGS=(/usr/sbin/nginx -c /etc/nginx/nginx.conf)
```

### Build upon


```dockerfile
# use this base image
FROM aisberg/base-alpine

# define the init system to use
ENV INIT=supervisor

# install the software
RUN apk add --update --no-cache --no-progress \
        pkg1 \
        pkg2 \
        pkg3

# copy provisioning data (templates, scripts, etc.)
COPY provision /provision

# take care of directories and files
RUN find /provision -type f -exec chmod 0664 {} + &&\
    find /provision -type d -exec chmod 0775 {} + &&\
    mkdir -p /var/www/html &&\
    chown nginx -R \
				/var/www \
        /etc/nginx \
        /var/lib/nginx

# define a volume
VOLUME /var/www/html

# use a non-root user when executing the container
USER nginx

# expose some ports
EXPOSE 8080 8443
```

#### Examples
A variety of real world examples that build upon this base image can be found [here](https://github.com/Aisbergg/dockerfiles). Just to mention some good examples:
- [`aisberg/nginx`](https://github.com/Aisbergg/dockerfiles/nginx)
- [`aisberg/gogs`](https://github.com/Aisbergg/dockerfiles/gogs)
- [`aisberg/mumble-server`](https://github.com/Aisbergg/dockerfiles/mumble-server)

## License
This Dockerfile is released under the MIT License. See [LICENSE](../LICENSE) for more information.
