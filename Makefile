BOXLINK='https://arizona.box.com/shared/static/0iw01873do5qy9unqaha7nxfrwwao0s6.gz'
ENVLOC=/etc/trhenv
PGDB=$(shell docker container ls --filter name=pgdb -q)

VDB=vosdbmgr
VDB_IMG=astrolabe/vosdbmgr:latest

IMGS=${PWD}/images
NAME=vos
NET=vos_net
STACK=vos

.PHONY: help down exec execdb loadData setup up

help:
	@echo 'Make what? help, up, setup, loadData, down'
	@echo '  where: help     - show this help message'
	@echo '         up       - start all VOS production containers'
	@echo '         setup    - download/update all component containers from DockerHub'
	@echo '         loadData - download data and load it into the VOS database (ONLY RUN ONCE)'
	@echo '         down     - stop all VOS containers'

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker cp .psqlrc   ${NAME}:/root
	docker exec -it ${NAME} bash

execdb:
	echo "EXECing into PGDB container ${PGDB}"
	docker cp .bash_env ${PGDB}:${ENVLOC}
	docker cp .psqlrc   ${PGDB}:/root
	docker exec -it ${PGDB} bash


# get the correct versions of the component containers on the local host
setup-base:
	docker pull ubuntu:18.04
	docker pull redis:5.0-alpine
	docker pull python:3.7.9
	docker pull postgres:10.15
	docker pull tomcat:8.5.49
	# docker pull jupyter/scipy-notebook:45bfe5a474fa
	docker pull ipac/firefly:release-2020.3.2
	docker pull nginx:1.17.9

setup: setup-base
	docker pull astrolabe/cuts:5.0
	docker pull astrolabe/dals:3.1
	docker pull astrolabe/ffal:2.0
	docker pull astrolabe/vosdb:4.1
	docker pull astrolabe/vosdbmgr:1.1


# start or stop a development or production stack of containers
down:
	docker stack rm ${STACK}

up-dev: # setup-base
	docker stack deploy -c docker-compose-dev.yml ${STACK}

up: # setup
	echo "Starting PRODUCTION stack..."
	docker stack deploy -c docker-compose.yml ${STACK}


# load data from the localhost into the VOS database
loadData:
	docker run -it --rm --name ${VDB} --network ${NET} ${VDB_IMG} -c load -l ${BOXLINK} -v
	# cp -fp HorseHead.fits ${IMGS}
