ENVLOC=/etc/trhenv

FFAL=ffal
FFAL_IMG=ffal:1H
FFAL_JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx10240m'
FFAL_PORT=8888

JAL=jupal
JAL_IMG=jupal:1H
JAL_JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8192m'
JAL_NB=${PWD}/notebooks
JAL_PORT=9999

VDB=vosdbmgr
VDB_IMG=vosdbmgr:devel

IMGS=${PWD}/images
NAME=vos
NET=vos_net
STACK=vos

.PHONY: help down runff stopff runjl stopjl setup loadData

help:
	@echo 'Make what? help, down, loadData, runff, stopff, runjl, stopjl, setup, up-dev, up-pro'
	@echo '  where: help   - show this help message'
	@echo '         down   - stop all VOS containers'
	@echo '         runff  - start the custom Firefly container on the VOS network'
	@echo '         stopff - stop the running Firefly container'
	@echo '         runjl  - start the custom JupyterLab container on the VOS network'
	@echo '         stopjl - stop the running JupyterLab container immediately (CAUTION)'
	@echo '         setup  - download/update all component containers from DockerHub'
	@echo '         up-dev - start all VOS development containers'
	@echo '         up-pro - start all VOS production containers'
	@echo '         loadData - download data and load it into the VOS database (ONLY RUN ONCE)'

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker exec -it ${NAME} bash


# get the correct versions of the component containers on the local host
setup-base:
	docker pull ubuntu:18.04
	docker pull redis:5.0-alpine
	docker pull python:3.7.5
	docker pull postgres:10.11
	docker pull tomcat:8.5.49
	docker pull jupyter/scipy-notebook:7a0c7325e470
	docker pull ipac/firefly:release-2019.3.2

setup: setup-base
	docker pull astrolabe/ffal:1h
	docker pull astrolabe/cuts:latest
	docker pull astrolabe/dals:1h
	docker pull astrolabe/jupal:1h
	docker pull astrolabe/vosdb:latest
	docker pull astrolabe/vosdbmgr:latest


# start or stop a development or production stack of containers
down:
	docker stack rm ${STACK}

up-dev: setup-base
	docker stack deploy -c docker-compose-dev.yml ${STACK}

up-pro: setup-pro
	echo "Starting PRODUCTION stack..."
	docker stack deploy -c docker-compose.yml ${STACK}


# run a custom version of Firefly on the VOS network
runff:
	docker run -d --rm --name ${FFAL} --network ${NET} -p${FFAL_PORT}:8080 -e ${FFAL_JOPTS} -v ${IMGS}:/external ${FFAL_IMG}

stopff:
	docker stop ${FFAL}


# run a custom version of JupyterLab on the VOS network
runjl:
	docker run -d --rm --name ${JAL} --network ${NET} -e ${JAL_JOPTS} -p${JAL_PORT}:8888 -v ${JAL_NB}:/home/jovyan/notebooks ${JAL_IMG}

stopjl:
	docker stop ${JAL}


# load data from the localhost into the VOS database
loadData:
	docker run -it --rm --name ${VDB} --network ${NET} ${VDB_IMG} -c load -l 'https://arizona.box.com/shared/static/hzfpzj71k4r3x2tpouccfycsug3yaxf4.gz' -v
