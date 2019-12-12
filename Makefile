ENVLOC=/etc/trhenv
FF=ff
FFIMG=ipac/firefly:release-2019.3.2
FFP=ffp
FFPIMG=ffp:devel
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8092m'
NAME=vos_vos.1
NET=vos_net
PORT=8888
STACK=vos

.PHONY: help down execff runff runffD setup stopff up-dev up-pro loadData loadCatalogs loadImages

help:
	@echo 'Make what? help, up, down, execff, runff, runffD'
	@echo '    where: help   - show this help message'
	@echo '           down   - stop all VOS containers'
	@echo '           execff - exec into running Firefly container'
	@echo '           runff  - start a standalone Firefly container'
	@echo '           runffD - start a standalone Firefly container in DEBUG mode'
	@echo '           setup  - download all component containers from DockerHub'
	@echo '           stopff - stop a running standalone Firefly container'
	@echo '           up-dev - start all VOS development containers'
	@echo '           up-pro - start all VOS production containers'
	@echo '           loadData - load all FITS files from ./images into database (ONLY RUN ONCE)'
	@echo '           loadCatalogs - load FITS catalogs from ./images into database (ONLY RUN ONCE)'
	@echo '           loadImages - load FITS images from ./images into database (ONLY RUN ONCE)'

up-pro:
	echo "Starting PRODUCTION stack..."
	docker stack deploy -c docker-compose.yml ${STACK}

up-dev:
	docker stack deploy -c docker-compose-dev.yml ${STACK}

down:
	docker stack rm ${STACK}

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker exec -it ${NAME} bash

execff:
	docker exec -it ${FF} bash

runff:
	docker run -d --rm --name ${FF} --network ${NET} -p${PORT}:8080 -e ${JOPTS} -v ${PWD}/images:/external ${FFIMG}

runffD:
	docker run -d --rm --name ${FF} --network ${NET} -p${PORT}:8080 -e ${JOPTS} -e 'DEBUG=TRUE' -v ${PWD}/images:/external ${FFIMG}

runff-nonet:
	docker run -d --rm --name ${FF} -p${PORT}:8080 -e ${JOPTS} -v ${PWD}/images:/external ${FFIMG}

setup:
	docker pull ubuntu:18.04
	docker pull redis:5.0-alpine
	docker pull jupyter/scipy-notebook:7a0c7325e470
	docker pull ipac/firefly:release-2019.3.2
	docker pull astrolabe/ffal:1h
	docker pull astrolabe/ffp:1h
	docker pull astrolabe/cuts:1h
	docker pull astrolabe/dals:1h
	docker pull astrolabe/jupal:1h
	docker pull astrolabe/vosdb:1h
	docker pull astrolabe/vosdbmgr:1h

stopff:
	docker stop ${FF}

loadData:
	docker run -it --rm --network ${NET} --name ${FFP} -v ${PWD}/images:/images ${FFPIMG} --verbose /images

loadCatalogs:
	docker run -it --rm --network ${NET} --name ${FFP} -v ${PWD}/images:/images ${FFPIMG} --verbose --skip-images /images

loadImages:
	docker run -it --rm --network ${NET} --name ${FFP} -v ${PWD}/images:/images ${FFPIMG} --verbose --skip-catalogs /images
