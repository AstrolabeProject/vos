FF=ff
FFIMG=ipac/firefly:release-2019.2.1
JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8092m'
NET=vos_net
PORT=8888
STACK=vos

.PHONY: help up down execff runff runffD stopff

help:
	@echo 'Make what? help, up, down, execff, runff, runffD'
	@echo '    where: help   - show this help message'
	@echo '           up     - start all VOS containers'
	@echo '           down   - stop all VOS containers'
	@echo '           execff - exec into running Firefly container'
	@echo '           runff  - start a standalone Firefly container'
	@echo '           runffD - start a standalone Firefly container in DEBUG mode'
	@echo '           stopff - stop a running standalone Firefly container'

up:
	docker stack deploy -c docker-compose.yml ${STACK}

down:
	docker stack rm ${STACK}

execff:
	docker exec -it ${FF} bash

runff:
	docker run -d --rm --name ${FF} --network ${NET} -p${PORT}:8080 -e ${JOPTS} -v ${PWD}/images:/external ${FFIMG}

runffD:
	docker run -d --rm --name ${FF} --network ${NET} -p${PORT}:8080 -e ${JOPTS} -e 'DEBUG=TRUE' -v ${PWD}/images:/external ${FFIMG}

stopff:
	docker stop ${FF}
