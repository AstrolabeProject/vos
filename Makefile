APP=vos
FF=ipac/firefly:release-2019.2.1
JOPTS=-Xms512m -Xmx8092m
NET=vos_net
PORT=8888

.PHONY: help up down execff runff runffD

help:
	@echo 'Make what? help, up, down, execff, runff, runffD'
	@echo '    where: help   - show this help message'
	@echo '           up     - start all VOS containers'
	@echo '           down   - stop all VOS containers'
	@echo '           execff - exec into running Firefly container'
	@echo '           runff  - start a standalone Firefly container'
	@echo '           runffD - start a standalone Firefly container in DEBUG mode'

up:
	docker stack deploy -c docker-compose.yml $(APP)

down:
	docker stack rm $(APP)

execff:
	docker exec -it ff bash

runff:
	docker run -d --rm --name ff --network $(NET) -p$(PORT):8080 -e '_JAVA_OPTIONS=$(JOPTS)' -v ${PWD}/images:/external $(FF)

runffD:
	docker run -d --rm --name ff --network $(NET) -p$(PORT):8080 -e '_JAVA_OPTIONS=$(JOPTS)' -e 'DEBUG=TRUE' -v ${PWD}/images:/external $(FF)

stopff:
	docker stop ff
