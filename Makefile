APP=vos

.PHONY: help up down

help:
	@echo "Make what? Try: up, down"

up:
	docker stack deploy -c docker-compose.yml $(APP)

down:
	docker stack rm $(APP)
