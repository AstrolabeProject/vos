BOXLINK='https://arizona.box.com/shared/static/0iw01873do5qy9unqaha7nxfrwwao0s6.gz'
ENVLOC=/etc/trhenv
PGDB=$(shell docker container ls --filter name=pgdb -q)

VDBM=vosdbmgr
VDBM_IMG=astrolabe/vosdbmgr:1.1

NAME=vos
NET=vos_net
GROUP=vos

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
	docker pull ubuntu:20.04
	docker pull redis:5.0-alpine
	docker pull python:3.7.9
	docker pull postgres:14.0
	docker pull tomcat:8.5.49
	docker pull ipac/firefly:release-2021.3.3
	docker pull nginx:1.17.9

setup: setup-base
	docker pull astrolabe/cuts:5.0
	docker pull astrolabe/dals:3.1
	docker pull astrolabe/ffal:2.0
	docker pull astrolabe/vosdb:5.0
	docker pull astrolabe/vosdbmgr:1.1


# start or stop a development or production group of containers
down:
	docker compose -p ${GROUP} down

up-dev: # setup-base
	docker compose -f docker-compose-dev.yml -p ${GROUP} up

up: # setup
	echo "Starting PRODUCTION group..."
	docker compose -f docker-compose.yml -p ${GROUP} up --detach


# load data from the localhost into the VOS database
loadData:
	docker run -it --rm --name ${VDBM} --network ${NET} ${VDBM_IMG} -c load -l ${BOXLINK} -v
